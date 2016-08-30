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

#import "HL7ProcedureSummaryEntry_Private.h"
#import "HL7SummaryEntry_Private.h"
#import "HL7ProcedureEntry.h"
#import "HL7ProcedureActivityProcedure.h"
#import "HL7ProcedureActivityObservation.h"
#import "HL7ProcedureActivityAct.h"
#import "HL7Code.h"
#import "HL7EffectiveTime.h"
#import "HL7Time.h"
#import "NSString+StripSpaces.h"
#import "NSDate+Additions.h"

@implementation HL7ProcedureSummaryEntry

- (instancetype _Nonnull)initWithProcedureEntry:(HL7ProcedureEntry *)procedureEntry
{
    if ((self = [super init])) {
        HL7ProcedureActivityProcedure *procedure = [procedureEntry procedure];
        HL7ProcedureActivityObservation *observation = [procedureEntry observation];
        HL7ProcedureActivityAct *act = [procedureEntry act];

        if (procedure != nil) {
            [self setNarrative:[[[procedure code] displayName] removeMultipleSpaces]];
            [self setDate:[[procedure effectiveTime] valueTimeOrLowElementNSDate]];
        } else if (observation != nil) {
            [self setNarrative:[[[observation code] displayName] copy]];
            [self setDate:[[[observation effectiveTime] valueAsNSDate] copy]];
        } else if (act != nil) {
            [self setNarrative:[[[act code] displayName] copy]];
            [self setDate:[[[act effectiveTime] valueAsNSDate] copy]];
        }
    }
    return self;
}

#pragma mark NSCopying
- (id)copyWithZone:(nullable NSZone *)zone
{
    HL7ProcedureSummaryEntry *clone = [super copyWithZone:zone];
    [clone setDate:[self date]];
    return clone;
}

#pragma mark NSCoding
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
