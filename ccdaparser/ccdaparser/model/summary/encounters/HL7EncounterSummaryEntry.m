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


#import "HL7EncounterSummaryEntry_Private.h"
#import "HL7SummaryEntry_Private.h"
#import "HL7EncounterEntry.h"
#import "HL7EncounterActivity.h"
#import "HL7IndicationObservation.h"
#import "HL7EncounterDiagnosis.h"
#import "HL7EffectiveTime.h"
#import "HL7ProblemObservation.h"
#import "HL7Value.h"

@implementation HL7EncounterSummaryEntry

- (instancetype _Nonnull)initWithEntry:(HL7EncounterEntry *_Nonnull)entry
{
    if ((self = [super init])) {

        if ([entry encounterActivity] != nil) {

            HL7IndicationObservation *indicationObservation = [[entry encounterActivity] indicationObservation];
            HL7EncounterDiagnosis *encounterDiagnosis = [[entry encounterActivity] encounterDiagnosis];

            [self setDate:[[[[entry encounterActivity] effectiveTime] valueAsNSDate] copy]];

            if (indicationObservation != nil) {
                [self setNarrative:[[[indicationObservation value] displayName] copy]];
            } else if (encounterDiagnosis != nil) {
                HL7IndicationObservation *indicationObservation = [encounterDiagnosis problemObservation];
                [self setNarrative:[[[indicationObservation value] displayName] copy]];
            }
        }
    }
    return self;
}

#pragma mark -
- (id)copyWithZone:(nullable NSZone *)zone
{
    HL7EncounterSummaryEntry *clone = [super copyWithZone:zone];
    [clone setDate:[[self date] copy]];
    return clone;
}

#pragma mark -
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder]) {
        [self setDate:[decoder decodeObjectForKey:@"date"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeObject:[self date] forKey:@"date"];
}
@end
