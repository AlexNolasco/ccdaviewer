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


#import "HL7SocialHistoryAnalyzer.h"
#import "HL7Const.h"
#import "HL7CCD.h"
#import "HL7Value.h"
#import "HL7CodeSummary_Private.h"
#import "HL7SummaryEntry_Private.h"
#import "HL7DateRange_Private.h"
#import "HL7SocialHistorySection.h"
#import "HL7SocialHistorySummary_Private.h"
#import "HL7SocialHistorySummaryEntry_Private.h"
#import "HL7SocialHistoryObservation.h"
#import "HL7SocialHistoryEntry.h"
#import "HL7PhysicalQuantityInterval.h"
#import "HL7Summary_Private.h"

@implementation HL7SocialHistoryAnalyzer
- (NSString *_Nullable)templateId
{
    return HL7TemplateSocialHistory;
}

- (void)setQuantityNarrativeForSummary:(HL7SocialHistorySummaryEntry *)entry withObservation:(HL7SocialHistoryObservation *)observation
{

    HL7XSIType dataType = [entry dataType];
    HL7Value *value = [observation value];
    if (value == nil) {
        return;
    }

    if (dataType == HL7XSITypeUnknown || dataType == HL7XSITypeCode) {
        return;
    } else if (dataType == HL7XSITypePhysicalQuality) {
        // e.g. <value xsi:type="PQ" value="12"/>
        // e.g. <value xsi:type="PQ" value="150" unit="mm[Hg]"/>
        NSString *formatted;

        if ([[value unit] length] && [[value value] length]) {
            formatted = [NSString stringWithFormat:@"%@ %@", [value value], [value unit]];
        } else if ([[value value] length]) {
            formatted = [value value];
        }

        [entry setQuantityNarrative:[formatted copy]];
    } else if (dataType == HL7XSITypeCodedConcept) {
        // e.g. <value xsi:type="CD" code="..." displayName="Moderate cigarette smoker, 10-19/day" codeSystem="2.16.840.1.113883.6.96"/>

        // override previous narrative
        if ([[value displayName] length]) {
            [entry setNarrative:[[value displayName] copy]];
        } else {
            [entry setNarrative:[observation getTextFromDisplayName:nil orSectionText:[[observation parentSection] text]]];
        }
    } else if (dataType == HL7XSITypeQuantityRange) {
        if ([[[value low] value] length] && [[[value high] value] length]) {
            NSString *formatted;
            formatted = [NSString stringWithFormat:@"%@ (%@) - %@ (%@)", [[value low] value], [[value low] unit], [[value high] value], [[value high] unit]];
            [entry setQuantityNarrative:[formatted copy]];
        }
    } else if (dataType == HL7XSITypeStructuredText) {
        // e.g. <value xsi:type="ST">None</value>
        [entry setQuantityNarrative:[[[observation value] text] copy]];
    }
}

- (HL7SocialHistorySummaryEntry *)createSocialHistorySummaryFromObservation:(HL7SocialHistoryObservation *)observation andSection:(HL7SocialHistorySection *)section
{

    HL7SocialHistorySummaryEntry *entry = [[HL7SocialHistorySummaryEntry alloc] init];
    [entry setCodeSummary:[[HL7CodeSummary alloc] initWithCode:[observation code]]];
    [entry setDateRange:[HL7DateRange dateRangeWithEffectiveTime:[observation effectiveTime]]];
    [entry setTemplateId:[[observation firstTemplateId] copy]];
    [entry setDataType:[[observation value] xsiType]];
    [[entry codeSummary] setResolvedName:[[observation getTextFromDisplayName:[[observation code] displayName] orSectionText:[section text]] copy]];

    [self setQuantityNarrativeForSummary:entry withObservation:observation];

    if (![[entry narrative] length]) { // use the display name if none set
        [entry setNarrative:[[[entry codeSummary] displayName] copy]];
    }

    return entry;
}

- (id<HL7SummaryProtocol> _Nonnull)analyzeSectionUsingDocument:(HL7CCD *_Nonnull)document
{
    HL7SocialHistorySection *socialHistorySection = (HL7SocialHistorySection *)[document getSectionByTemplateId:[self templateId]];

    HL7SocialHistorySummary *summary = [[HL7SocialHistorySummary alloc] initWithElement:socialHistorySection];

    if (socialHistorySection != nil) {

        [summary setCodeSummary:[[HL7CodeSummary alloc] initWithCode:[socialHistorySection code]]];
        for (HL7SocialHistoryEntry *socialHistoryEntry in [socialHistorySection entries]) {
            HL7SocialHistorySummaryEntry *entry = [self createSocialHistorySummaryFromObservation:[socialHistoryEntry observation] andSection:socialHistorySection];
            if (entry != nil) {
                [[summary entries] addObject:entry];
            }
        }
    }
    return summary;
}
@end
