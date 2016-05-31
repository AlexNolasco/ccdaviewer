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


#import "FHIRPatientManagerApi.h"
#import "URLManager.h"
#import "FHIRDataModels.h"

typedef NSMutableArray<FHIRPatient *> PatientsMutableArray;

@interface FHIRPatientManagerApi ()
@property (nonatomic, strong) NetworkManager *networkManager;
@end

@implementation FHIRPatientManagerApi
- (instancetype)initWithURLManager:(URLManager *)urlManager networkManager:(NetworkManager *)networkManager
{
    if ((self = [super init])) {
        [self setUrlManager:urlManager];
        [self setNetworkManager:networkManager];
    }
    return self;
}

#pragma mark - Private

- (NSError *)errorForParsingError:(NSError *)error
{
    return [NSError errorWithDomain:NSURLErrorDomain code:-1 userInfo:@{ NSLocalizedFailureReasonErrorKey : @"URL must not be nil", NSLocalizedRecoverySuggestionErrorKey : @"Provider a URL" }];
}

- (PatientsArray *)dataToPatients:(NSData *)data error:(NSError **)error
{
    NSError *jsonError = nil;
    if (!data) {
        return nil;
    }

    NSArray *arrayOfDictionaries = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];

    if (!arrayOfDictionaries) {
        if (error != NULL) {
            *error = jsonError;
        }
        return nil;
    }

    PatientsMutableArray *result = [[PatientsMutableArray alloc] initWithCapacity:10];

    for (NSDictionary *dictionary in arrayOfDictionaries) {
        [result addObject:[FHIRPatient modelObjectWithDictionary:dictionary]];
    }

    return [result copy];
}

#pragma mark - Public
- (void)getPatientsByIdentifier:(NSString *)identifier completed:(FHIRApiManagerCompletedBlock)completedBlock
{
    NSURL *url = [[self urlManager] getPatientsByIdentifier:identifier];

    [[self networkManager] requestURL:url
                                 type:NetworkManagerRequestMethodGET
                        beforeRequest:nil
                            completed:^(id data, NSError *error) {
                                if (!completedBlock) {
                                    return;
                                }

                                if (error) {
                                    completedBlock(data, error);
                                } else {
                                    NSError *parsingError = nil;
                                    PatientsArray *result = [self dataToPatients:data error:&parsingError];

                                    completedBlock(result, parsingError);
                                }
                            }];
}

- (void)getCcda:(NSString *)ccda completed:(NetworkManagerAPICompletedBlock)completedBlock
{
    NSURL *url = [[self urlManager] getCcda:ccda];
    [[self networkManager] requestURL:url
                                 type:NetworkManagerRequestMethodGET
                        beforeRequest:nil
                            completed:^(id data, NSError *error) {
                                if (!completedBlock) {
                                    return;
                                }
                                completedBlock(data, error);
                            }];
}
@end
