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


#import "URLManager.h"
#import "NetworkSettingsStorage.h"
#import "NetworkSettings.h"

@interface URLManager ()

@end

@implementation URLManager

- (instancetype)initWithUrl:(NSURL *)url
{
    if ((self = [super init])) {
        [self setUrl:url];
    }
    return self;
}

- (instancetype)initWithString:(NSString *)string
{
    if (![string length]) {
        return nil;
    }
    return [self initWithUrl:[NSURL URLWithString:string]];
}

- (instancetype)init
{
    NetworkSettings *settings = [[NetworkSettingsStorage sharedIntance] load];
    return [self initWithUrl:[settings url]];
}

+ (instancetype)sharedInstance
{
    static URLManager *sharedMyManager = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

+ (NSString *)defaultUrl
{
    return @"https://ccdaviewer-coladapp.rhcloud.com/patients/";
}

+ (NSString *)defaultNpi
{
    return @"DEMONPI";
}

- (NSURL *)getPatientsByIdentifier:(NSString *)identifier
{
    if (![identifier length]) {
        return [self url];
    }

    return [[self url] URLByAppendingPathComponent:identifier];
}

- (NSURL *)getCcda:(NSString *)ccda
{
    if (![ccda length]) {
        return [self url];
    }

    return [NSURL URLWithString:ccda];
}
@end
