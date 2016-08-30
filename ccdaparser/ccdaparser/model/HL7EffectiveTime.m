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


#import "HL7EffectiveTime.h"
#import "HL7EffectiveTimeElement.h"
#import "HL7Period.h"
#import "NSDate+Additions.h"

@implementation HL7EffectiveTime
- (HL7EffectiveTimeElement *)low
{
    if (_low == nil) {
        _low = [[HL7EffectiveTimeElement alloc] init];
    }
    return _low;
}

- (HL7EffectiveTimeElement *)high
{
    if (_high == nil) {
        _high = [[HL7EffectiveTimeElement alloc] init];
    }
    return _high;
}

- (HL7XSITimeInterval)xsiTimeInterval
{
    if ([[self type] isEqualToString:@"TS"]) {
        return HL7XSITimeIntervalsTimeStamp;
    } else if ([[self type] isEqualToString:@"IVL_TS"]) {
        return HL7XSITimeIntervalsContiguousTimeInterval;
    } else if ([[self type] isEqualToString:@"PIVL_TS"]) {
        return HL7XSITimeIntervalsPeriodicTimeInterval;
    } else if ([[self type] isEqualToString:@"EIVL"]) {
        return HL7XSITimeIntervalsEventRelatedTimeInterval;
    } else {
        return HL7XSITimeIntervalsUnknown;
    }
}

- (NSString *)valueTimeOrLowElementString
{
    if ([[self value] length]) {
        return [self value];
    }

    if ([[[self low] value] length]) {
        return [[self low] value];
    }

    return nil;
}

- (NSDate *_Nullable)valueTimeOrLowElementNSDate
{
    return [NSDate fromISO8601String:[self valueTimeOrLowElementString]];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"\n%@: {\tlow=%@, high=%@}", [[self class] description], [[self low] description], [[self high] description]];
}

#pragma mark NSCopying

- (id)copyWithZone:(nullable NSZone *)zone
{
    HL7EffectiveTime *clone = [super copyWithZone:zone];
    [self setLow:[[self low] copyWithZone:zone]];
    [self setHigh:[[self high] copyWithZone:zone]];
    [self setPeriod:[[self period] copyWithZone:zone]];
    [self setType:[[self type] copyWithZone:zone]];
    return clone;
}

#pragma mark NSCoding
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        [self setLow:[decoder decodeObjectForKey:@"low"]];
        [self setHigh:[decoder decodeObjectForKey:@"high"]];
        [self setPeriod:[decoder decodeObjectForKey:@"period"]];
        [self setType:[decoder decodeObjectForKey:@"type"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeObject:[self low] forKey:@"low"];
    [encoder encodeObject:[self high] forKey:@"high"];
    [encoder encodeObject:[self period] forKey:@"period"];
    [encoder encodeObject:[self type] forKey:@"type"];
}
@end
