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


#import "HL7AllergySummaryEntry.h"
#import "HL7AllergySummaryEntry_Private.h"
#import "HL7DateRange.h"
#import "HL7CodeSummary.h"
#import "HL7Enums_Private.h"
#import "NSDate+TimeAgo.h"

@implementation HL7AllergySummaryEntry

- (NSString *)allergen
{
    return [[[self allergenCode] resolvedName] copy];
}

- (NSString *)firstReaction
{
    return [[[self reactionCode] resolvedName] copy];
}

- (NSString *)status
{
    return [[[self statusCode] resolvedName] copy];
}

- (NSString *)severity
{
    return [[[self severityCode] resolvedName] copy];
}

- (NSDate *)dateOfOnset
{
    return [[[self dateOfOnsetRange] start] copy];
}

- (NSMutableArray<HL7AllergyReactionSummary *> *_Nonnull)allReactions
{
    return [[self reactions] copy];
}

- (HL7ProblemSeverityCode)problemSeverityCode
{
    return [HL7Enumerations hl7ProblemSeverityCodeFromString:[[self severityCode] code]];
}

- (NSString *)narrative
{
    return [self allergen];
}

#pragma mark NSCopying
- (id)copyWithZone:(nullable NSZone *)zone
{
    HL7AllergySummaryEntry *clone = [[HL7AllergySummaryEntry allocWithZone:zone] init];
    [clone setAllergenCode:[[self allergenCode] copyWithZone:zone]];
    [clone setAllergenValue:[[self allergenValue] copyWithZone:zone]];
    [clone setReactionCode:[[self reactionCode] copyWithZone:zone]];
    [clone setStatusCode:[[self statusCode] copyWithZone:zone]];
    [clone setSeverityCode:[[self severityCode] copyWithZone:zone]];
    [clone setDateRecorded:[[self dateRecorded] copyWithZone:zone]];
    [clone setDateOfOnsetRange:[[self dateOfOnsetRange] copyWithZone:zone]];
    [clone setReactions:[[NSMutableArray allocWithZone:zone] initWithArray:[self reactions] copyItems:YES]];
    return clone;
}

#pragma mark NSCoding
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        [self setAllergenCode:[decoder decodeObjectForKey:@"allergenCode"]];
        [self setAllergenValue:[decoder decodeObjectForKey:@"allergyValue"]];
        [self setReactionCode:[decoder decodeObjectForKey:@"reactionCode"]];
        [self setStatusCode:[decoder decodeObjectForKey:@"statusCode"]];
        [self setSeverityCode:[decoder decodeObjectForKey:@"severityCode"]];
        [self setReactions:[decoder decodeObjectForKey:@"reactions"]];
        [self setDateOfOnsetRange:[decoder decodeObjectForKey:@"dateOfOnsetRange"]];
        [self setDateRecorded:[decoder decodeObjectForKey:@"dateRecorded"]];
        [self setProblemSeverityCode:[decoder decodeIntegerForKey:@"problemSeverityCode"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:[self allergenCode] forKey:@"allergenCode"];
    [encoder encodeObject:[self allergenValue] forKey:@"allergenValue"];
    [encoder encodeObject:[self reactionCode] forKey:@"reactionCode"];
    [encoder encodeObject:[self statusCode] forKey:@"statusCode"];
    [encoder encodeObject:[self severityCode] forKey:@"severityCode"];
    [encoder encodeObject:[self reactions] forKey:@"reactions"];
    [encoder encodeObject:[self dateOfOnsetRange] forKey:@"dateOfOnsetRange"];
    [encoder encodeObject:[self dateRecorded] forKey:@"dateRecorded"];
    [encoder encodeInteger:[self problemSeverityCode] forKey:@"problemSeverityCode"];
}
@end
