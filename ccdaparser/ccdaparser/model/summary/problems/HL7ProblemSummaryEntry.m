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


#import "HL7ProblemSummaryEntry_Private.h"
#import "HL7Const.h"
#import "HL7ProblemObservation.h"
#import "HL7ProblemConcernAct.h"
#import "HL7SummaryEntry_Private.h"
#import "HL7EffectiveTime.h"
#import "HL7EffectiveTimeElement.h"
#import "HL7DateRange_Private.h"
#import "HL7StatusCode.h"
#import "HL7Value.h"
#import "HL7Text.h"
#import "HL7OriginalText.h"
#import "HL7Section.h"
#import "HL7Codes.h"

@implementation HL7ProblemSummaryEntry

- (instancetype _Nonnull)initWithAct:(HL7ProblemConcernAct *_Nonnull)act
{
    if ((self = [super init])) {

        [self setStatusCode:[[act statusCode] statusCode]];
        [self setConcernAuthored:[HL7DateRange dateRangeWithEffectiveTime:[act effectiveTime]]];

        HL7ProblemObservation *observation = [act problemObservation];
        if (observation) {
            [self setBiologicalOnSet:[HL7DateRange dateRangeWithEffectiveTime:[observation effectiveTime]]];

            if ([[[observation value] displayName] length]) {


                if ([[observation value] isCodeSystem:CodeSystemIdSNOMEDCT] && [[observation value] originalTextElement]) { // just letting us know it's a "problem"
                    // NSString * referenceWithoutHash = [[[observation value] originalTextElement] referenceValueWithoutHash];

                    NSString *possibleValue = [[[observation value] originalTextElement] getActualValueFromTextElement:[[observation parentSection] text]];

                    [self setNarrative:possibleValue];
                }


                if (![[self narrative] length]) {
                    [self setNarrative:[[[observation value] displayName] copy]];
                }
            }
        }
    }
    return self;
}

- (NSString *)status
{
    return [HL7Enumerations statusCodeAsString:[self statusCode]];
}

#pragma mark -
- (id)copyWithZone:(nullable NSZone *)zone
{
    HL7ProblemSummaryEntry *clone = [super copyWithZone:zone];
    [clone setBiologicalOnSet:[[self biologicalOnSet] copy]];
    [clone setConcernAuthored:[[self concernAuthored] copy]];
    [clone setStatusCode:[self statusCode]];
    [clone setStatus:[[self status] copy]];
    return clone;
}

#pragma mark -
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder]) {
        [self setBiologicalOnSet:[decoder decodeObjectForKey:@"biologicalOnSet"]];
        [self setConcernAuthored:[decoder decodeObjectForKey:@"concernAuthored"]];
        [self setStatusCode:[decoder decodeIntegerForKey:@"statusCode"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeObject:[self biologicalOnSet] forKey:@"biologicalOnSet"];
    [encoder encodeObject:[self concernAuthored] forKey:@"concernAuthored"];
    [encoder encodeInteger:[self statusCode] forKey:@"statusCode"];
}
@end
