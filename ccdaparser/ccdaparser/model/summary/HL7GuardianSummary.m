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


#import "HL7GuardianSummary_Private.h"
#import "HL7Guardian.h"
#import "HL7Name.h"
#import "HL7Code.h"
#import "HL7Codes.h"
#import "HL7CodeSummary.h"
#import "HL7Telecom_Private.h"

@implementation HL7GuardianSummary
- (instancetype)initWithGuardian:(HL7Guardian *)guardian
{
    if ((self = [super init])) {
        [self setName:[[guardian name] copy]];
        [self setCode:[[guardian code] copy]];
        [self setTelecoms:[[NSArray alloc] initWithArray:[guardian telecoms] copyItems:YES]];
    }
    return self;
}

- (NSString *)fullName
{
    return [[self name] description];
}

- (NSString *)phoneNumber
{
    return [[self phoneNumbers] firstObject];
}

- (NSArray<NSString*>* _Nonnull)phoneNumbers
{
    NSMutableArray<NSString*>* numbers = [[NSMutableArray alloc] initWithCapacity:[[self telecoms] count]];
    for (HL7Telecom *telecom in [self telecoms]) {
        if ([telecom telecomType] == HL7TelecomTypeTelephone) {
            [numbers addObject:[telecom valueWithoutPrefix]];
        }
    }
    return [numbers copy];
}

- (NSString *_Nullable)relationship
{
    if ([self code] == nil || ![[[self code] codeSystem] isEqualToString:CODEHL7Role]) {
        return nil;
    }
    return [[self code] displayName];
}

#pragma mark NSCopying
- (id)copyWithZone:(nullable NSZone *)zone
{
    HL7GuardianSummary *clone = [HL7GuardianSummary allocWithZone:zone];
    [clone setCode:[[self code] copy]];
    [clone setName:[[self name] copy]];
    [clone setTelecoms:[[NSArray alloc] initWithArray:[self telecoms] copyItems:YES]];
    return clone;
}

#pragma mark NSCoding
- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init])) {
        [self setCode:[decoder decodeObjectForKey:@"code"]];
        [self setName:[decoder decodeObjectForKey:@"name"]];
        [self setTelecoms:[decoder decodeObjectForKey:@"telecoms"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:[self code] forKey:@"code"];
    [encoder encodeObject:[self name] forKey:@"name"];
    [encoder encodeObject:[self telecoms] forKey:@"telecoms"];
}
@end
