/********************************************************************************
 * The MIT License (MIT)                                                        *
 *                                                                              *
 * Copyright (C) 2016 Alex Nolasco                                              *
 *                                                                              *
 *Permission is hereby granted, free of charge, to any person obtaining a copy  *
 *of this software and associated documentation files (the "Software"), to deal *
 *in the Software without restriction, including without limitation the rights  *
 *to use, copy, modify, merge, publish, distribute, sublicense, and/or sell     *
 *copies of the Software, and to permit persons to whom the Software is         *
 *furnished to do so, subject to the following conditions:                      *
 *The above copyright notice and this permission notice shall be included in    *
 *all copies or substantial portions of the Software.                           *
 *                                                                              *
 *THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR    *
 *IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,      *
 *FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE   *
 *AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER        *
 *LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, *
 *OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN     *
 *THE SOFTWARE.                                                                 *
 *********************************************************************************/


#import "NetworkManager.h"
#import "UIKit/UIKit.h"
static const NSTimeInterval kDefaultTimeoutInSeconds = 15.0;

NSString *const HttpMimeHeaderContentType = @"Content-Type";

@interface NetworkManager ()

@property (nonatomic, readonly) NSURLSession *urlSession;
@property (nonatomic, readonly) NSSet *runningURLRequests;
@property (assign) NSTimeInterval timeout;
@end

@implementation NetworkManager {
    NSURLSession *_urlSession;
    NSSet *_runningURLRequests;
}

#pragma mark - Properties

- (NSSet *)runningURLRequests
{
    if (!_runningURLRequests) {
        _runningURLRequests = [[NSSet alloc] init];
    }
    return _runningURLRequests;
}

- (NSURLSession *)urlSession
{
    if (_urlSession) {
        return _urlSession;
    }

    // About configurations
    // *Ephemeral sessions do not store any data to disk; all caches, credential stores,
    // and so on are kept in RAM and tied to the session.

    // *Default sessions behave similarly to other Foundation methods for downloading URLs.
    // They use a persistent disk-based cache and store credentials in the user’s keychain.

    _urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
    [_urlSession setSessionDescription:@"com.coladapp.ccdaviewer"];
    return _urlSession;
}

- (void)addRequestedURL:(NSURL *)url
{
    @synchronized(self)
    {
        if (url) {
            NSMutableSet *requests = [self.runningURLRequests mutableCopy];
            [requests addObject:url];
            _runningURLRequests = [requests copy];
        }
    }
}

- (void)removeRequestedURL:(NSURL *)url
{
    @synchronized(self)
    {
        NSMutableSet *requests = [self.runningURLRequests mutableCopy];
        if (url && [requests containsObject:url]) {
            [requests removeObject:url];
            _runningURLRequests = [requests copy];
        }
    }
}

#pragma mark - Init
- (instancetype)init
{
    return [self initWithTimeout:kDefaultTimeoutInSeconds];
}

- (instancetype)initWithTimeout:(NSTimeInterval)timeout
{
    self = [super init];
    if (self) {
        [self setTimeout:timeout];
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static NetworkManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - API

- (void)requestURL:(NSURL *)url type:(NetworkManagerRequestMethod)method beforeRequest:(NetworkManagerAPIBlockBeforeRequest)beforeRequestBlock completed:(NetworkManagerAPICompletedBlock)completedBlock
{

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:[self timeout]];
    if (beforeRequestBlock) {
        beforeRequestBlock(request);
    }

    switch (method) {
        case NetworkManagerRequestMethodGET:
            [request setHTTPMethod:@"GET"];
            break;
        case NetworkManagerRequestMethodPOST:
            [request setHTTPMethod:@"POST"];
            break;
        case NetworkManagerRequestMethodDELETE:
            [request setHTTPMethod:@"DELETE"];
            break;
        case NetworkManagerRequestMethodPUT:
            [request setHTTPMethod:@"PUT"];
            break;
        default:
            [request setHTTPMethod:@"GET"];
            break;
    }
    [self requestURL:request beforeRequest:beforeRequestBlock completed:completedBlock];
}

#pragma mark - Private
static void BeginNetworkActivity()
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

static void EndNetworkActivity()
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (NSString *)getContentType:(NSHTTPURLResponse *)response
{
    NSDictionary *headers = [response allHeaderFields];
    return [headers objectForKey:HttpMimeHeaderContentType];
}

- (void)requestURL:(NSURLRequest *)request beforeRequest:(NetworkManagerAPIBlockBeforeRequest)beforeRequestBlock completed:(NetworkManagerAPICompletedBlock)completedBlock
{
    const NSInteger HttpErrorCodeBegin = 400;
    NSURL *url = [request URL];

    [self addRequestedURL:url];

    BeginNetworkActivity();

    NSURLSession *session = [self urlSession];
    [[session dataTaskWithRequest:request
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *connectionError) {

                    EndNetworkActivity();

                    NSError *resError = connectionError;
                    NSInteger statusCode = 0;
                    NSHTTPURLResponse *httpResponse;

                    if ([response respondsToSelector:@selector(statusCode)]) {
                        httpResponse = (NSHTTPURLResponse *)response;
                        statusCode = [httpResponse statusCode];
                    }

                    if (statusCode >= HttpErrorCodeBegin) {
                        NSMutableDictionary *errorUserInfo = [NSMutableDictionary dictionary];

                        errorUserInfo[@"HTTP statuscode"] = @(statusCode);
                        if (connectionError) {
                            errorUserInfo[@"underlying error"] = connectionError;
                        }

                        if (httpResponse) {
                            errorUserInfo[HttpMimeHeaderContentType] = [[httpResponse allHeaderFields] objectForKey:HttpMimeHeaderContentType];
                        }
                        // convert *connectionError* to *NSURLErrorDomain*
                        resError = [NSError errorWithDomain:NSURLErrorDomain code:statusCode userInfo:errorUserInfo];
                    }

                    [self removeRequestedURL:url];

                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completedBlock) {
                            completedBlock(data, resError);
                        }
                    });
                }] resume];
}

- (void)cancelAllRequests
{
    [_urlSession invalidateAndCancel];
    _urlSession = nil;
    _runningURLRequests = nil;
}
@end
