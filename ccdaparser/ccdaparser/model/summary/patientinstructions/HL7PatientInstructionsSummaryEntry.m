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


#import "HL7PatientInstructionsSummaryEntry_Private.h"
#import "HL7SummaryEntry_Private.h"
#import "HL7Act.h"
#import "HL7DateRange_Private.h"
#import "HL7Text.h"

@implementation HL7PatientInstructionsSummaryEntry

- (instancetype _Nonnull)initWithAct:(HL7Act *_Nonnull)act
{
    if ((self = [super init])) {
        [self setEffectiveTime:[[HL7DateRange alloc] initWithEffectiveTime:[act effectiveTime]]];
        [self setNarrative:[[act text] text]];
    }
    return self;
}

#pragma mark NSCopying
- (id)copyWithZone:(nullable NSZone *)zone
{
    HL7PatientInstructionsSummaryEntry *clone = [super copyWithZone:zone];
    [clone setEffectiveTime:[[self effectiveTime] copy]];
    [clone setMoodCode:[self moodCode]];
    return clone;
}

#pragma mark NSCoding
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder]) {
        [self setEffectiveTime:[decoder decodeObjectForKey:@"effectiveTime"]];
        [self setMoodCode:[decoder decodeIntegerForKey:@"moodCode"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeObject:[self effectiveTime] forKey:@"effectiveTime"];
    [encoder encodeInteger:[self moodCode] forKey:@"moodCode"];
}
@end
