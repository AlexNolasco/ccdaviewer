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


#import "HL7PlanOfCareAnalyzer.h"
#import "HL7Const.h"
#import "HL7CCD.h"
#import "HL7Code.h"
#import "HL7Enums.h"
#import "HL7Summary_Private.h"
#import "HL7SummaryEntry_Private.h"
#import "HL7OriginalText.h"
#import "HL7EffectiveTime.h"
#import "HL7PlanOfCareSummaryEntry_Private.h"
#import "HL7PlanOfCareSummary_Private.h"
#import "HL7PlanOfCareSection.h"
#import "HL7PlanOfCareEntry.h"
#import "HL7EffectiveTimeElement.h"
#import "HL7Element+Additions.h"

@implementation HL7PlanOfCareAnalyzer
- (NSString *_Nullable)templateId
{
    return HL7TemplatePlanOfCare;
}

- (HL7PlanOfCareSummaryEntry *)createSummaryEntryFromElement:(HL7PlanOfCareEntry *)entry
{
    HL7Code *code = [[entry planOfCareActivity] code];

    if ([[code displayName] length]) {
        HL7PlanOfCareSummaryEntry *summary = [[HL7PlanOfCareSummaryEntry alloc] init];
        NSString *displayName = [code displayName];

        if ([[code originalTextElement] hasReferenceId]) {
            NSString *referenceValue = [[code originalTextElement] referenceValue];
            [summary setNarrative:[[[entry parentSection] textById:referenceValue] copy]];
        } else {
            [summary setNarrative:[displayName copy]];
        }

        HL7EffectiveTime *effectiveTime = [[entry planOfCareActivity] effectiveTime];
        if ([effectiveTime valueAsNSDate] != nil) {
            [summary setDate:[effectiveTime valueAsNSDate]];
        } else if ([effectiveTime low]) {
            [summary setDate:[[effectiveTime low] valueAsNSDate]];
        }

        [summary setMoodCode:[[entry planOfCareActivity] hl7MoodCode]];
        return summary;
    } else {
        return nil;
    }
}

- (id<HL7SummaryProtocol> _Nonnull)analyzeSectionUsingDocument:(HL7CCD *_Nonnull)document
{
    HL7PlanOfCareSection *section = (HL7PlanOfCareSection *)[document getSectionByTemplateId:[self templateId]];
    HL7PlanOfCareSummary *summary = [[HL7PlanOfCareSummary alloc] initWithElement:section];
    for (HL7PlanOfCareEntry *entry in [section entries]) {
        HL7PlanOfCareSummaryEntry *summaryEntry = [self createSummaryEntryFromElement:entry];
        if (summaryEntry != nil) {
            [[summary entries] addObject:summaryEntry];
        }
    }
    return summary;
}
@end
