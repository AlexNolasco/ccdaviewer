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


#import "HL7CCDSummary.h"
#import "HL7CCDSummary_Private.h"
#import "HL7PatientSummary.h"

@implementation HL7CCDSummary

- (NSMutableDictionary<NSString *, id<HL7SummaryProtocol>> *)mutableSummaries
{
    if (_mutableSummaries == nil) {
        _mutableSummaries = [[NSMutableDictionary alloc] initWithCapacity:5];
    }
    return _mutableSummaries;
}


- (NSDictionary<NSString *, id<HL7SummaryProtocol>> *)summaries
{
    return [[self mutableSummaries] copy];
}

- (NSString *)description
{
    NSMutableString *result = [[NSMutableString alloc] initWithCapacity:100];
    [result appendFormat:@"\nFull name = %@", [[self patient] fullName]];
    [result appendFormat:@"\nAge       = %@", [[self patient] age]];
    return [result copy];
}

- (id<HL7SummaryProtocol> _Nullable)getSummaryByClass:(Class _Nonnull)className
{
    __block id<HL7SummaryProtocol> result;
    [[self summaries] enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, id<HL7SummaryProtocol> _Nonnull obj, BOOL *_Nonnull stop) {
        if ([obj isKindOfClass:className]) {
            result = obj;
            *stop = YES;
        }
    }];
    return result;
}

#pragma mark -
- (id)copyWithZone:(nullable NSZone *)zone
{
    HL7CCDSummary *clone = [[self class] allocWithZone:zone];

    [clone setMutableSummaries:[[NSMutableDictionary alloc] initWithDictionary:[self summaries] copyItems:YES]];
    [clone setPatient:[[self patient] copy]];
    return clone;
}

#pragma mark -
- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init])) {

        [self setMutableSummaries:[decoder decodeObjectForKey:@"summaries"]];
        [self setPatient:[decoder decodeObjectForKey:@"patient"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:[self mutableSummaries] forKey:@"summaries"];
    [encoder encodeObject:[self patient] forKey:@"patient"];
}
@end
