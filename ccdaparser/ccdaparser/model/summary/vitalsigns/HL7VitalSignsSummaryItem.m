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


#import "HL7VitalSignsSummaryItem_Private.h"
#import "HL7CodeSummary_Private.h"
#import "HL7VitalSignsObservation.h"
#import "HL7EffectiveTime.h"
#import "HL7Value.h"
#import "HL7Section.h"

@implementation HL7VitalSignsSummaryItem

- (instancetype _Nonnull)initWithObservation:(HL7VitalSignsObservation *_Nonnull)observation
{
    if ((self = [super init])) {
        [self setCodeSummary:[[HL7CodeSummary alloc] initWithCode:[observation code]]];
        [self setEffectiveTime:[[observation effectiveTime] valueAsNSDate]];
        [self setUnit:[[[observation value] unit] copy]];
        [self setValue:[[[observation value] value] copy]];

        [[self codeSummary] setResolvedName:[observation getTextFromDisplayName:[[observation code] displayName] orSectionText:[[observation parentSection] text]]];
    }
    return self;
}

+ (instancetype _Nullable)createWithObservation:(HL7VitalSignsObservation *_Nonnull)observation
{
    if (observation == nil) {
        return nil;
    }
    return [[HL7VitalSignsSummaryItem alloc] initWithObservation:observation];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@:%@ (%@)", [[self codeSummary] displayName], [self value], [self unit]];
}

- (NSString *_Nullable)unitName
{
    if (![[self unit] length]) {
        return [self unit];
    }
    if ([[self unit] isEqualToString:@"[lb_av]"] || [[self unit] isEqualToString:@"lbs"]) {
        return @"pounds";
    } else if ([[self unit] isEqualToString:@"[oz_av]"]) {
        return @"ounces";
    } else if ([[self unit] isEqualToString:@"g"]) {
        return @"grams";
    } else if ([[self unit] isEqualToString:@"[in_us]"] || [[self unit] isEqualToString:@"in"]) {
        return @"inches";
    } else {
        return [self unit];
    }
}

#pragma mark NSCopying
- (id)copyWithZone:(nullable NSZone *)zone
{
    HL7VitalSignsSummaryItem *clone = [[HL7VitalSignsSummaryItem allocWithZone:zone] init];
    [clone setValue:[[self value] copy]];
    [clone setEffectiveTime:[[self effectiveTime] copy]];
    [clone setUnit:[[self unit] copy]];
    [clone setCodeSummary:[[self codeSummary] copy]];
    return clone;
}

#pragma mark NSCoding
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        [self setCodeSummary:[decoder decodeObjectForKey:@"codeSummary"]];
        [self setEffectiveTime:[decoder decodeObjectForKey:@"effectiveTime"]];
        [self setValue:[decoder decodeObjectForKey:@"value"]];
        [self setUnit:[decoder decodeObjectForKey:@"unit"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:[self codeSummary] forKey:@"codeSummary"];
    [encoder encodeObject:[self effectiveTime] forKey:@"effectiveTime"];
    [encoder encodeObject:[self value] forKey:@"value"];
    [encoder encodeObject:[self unit] forKey:@"unit"];
}
@end
