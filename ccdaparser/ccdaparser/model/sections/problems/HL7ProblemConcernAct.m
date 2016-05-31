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


#import "HL7Const.h"
#import "HL7StatusCode.h"
#import "HL7ProblemConcernAct.h"
#import "HL7ProblemObservation.h"
#import "HL7ProblemEntryRelationship.h"

@implementation HL7ProblemConcernAct
- (NSMutableArray<HL7EntryRelationship *> *)descendants
{
    if (_descendants == nil) {
        _descendants = [[NSMutableArray alloc] initWithCapacity:2];
    }
    return _descendants;
}

- (HL7ProblemObservation *_Nullable)observationByTemplateId:(NSString *)templateId inEntries:(NSMutableArray *)entries
{
    if (![entries count]) {
        return nil;
    }

    // Contains exactly one [1..1] Problem Observation (templateId: 2.16.840.1.113883.10.20.22.4.4)
    for (HL7EntryRelationship *entryRelationship in entries) {

        if ([[entryRelationship descendants] count]) {
            // Contains exactly one [1..1]
            HL7ProblemObservation *observation = (HL7ProblemObservation *)[[entryRelationship descendants] firstObject];
            if ([observation hasTemplateId:templateId]) {
                return observation;
            }
        }
    }
    return nil;
}

- (HL7ProblemObservation *_Nullable)observationByTemplateId:(NSString *)templateId
{

    HL7ProblemObservation *result;
    for (HL7EntryRelationship *element in [self descendants]) { // SHALL contain at least one [1..*] entryRelationship (CONF:15980)

        if (![[element descendants] count]) {
            continue;
        }

        // Contains exactly one [1..1] Problem Observation (templateId: 2.16.840.1.113883.10.20.22.4.4)
        HL7ProblemObservation *problemObservation = (HL7ProblemObservation *)[[element descendants] firstObject];


        if ([problemObservation hasTemplateId:templateId]) {
            return problemObservation;
        }

        result = [self observationByTemplateId:templateId inEntries:[problemObservation descendants]];
        if (result != nil) {
            break;
        }
    }
    return result;
}

- (HL7ProblemObservation *_Nullable)problemObservation
{
    return [self observationByTemplateId:HL7TemplateProblemsObservation];
}

- (HL7ProblemObservation *_Nullable)ageObservation
{
    return [self observationByTemplateId:HL7TemplateAgeObservation];
}

- (HL7ProblemObservation *_Nullable)problemStatus
{
    return [self observationByTemplateId:HL7TemplateFunctionalStatusProblemObservation];
}

- (HL7ProblemObservation *_Nullable)healthStatusObservation
{
    return [self observationByTemplateId:HL7TemplateHealthStatusObservation];
}

- (HL7ProblemObservation *_Nullable)statusObservation
{
    return [self observationByTemplateId:HL7TemplateStatusObservation];
}
@end
