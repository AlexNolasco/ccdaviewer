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


#import "HL7VitalSignsAnalyzer.h"
#import "HL7Const.h"
#import "HL7CCD.h"
#import "HL7Code.h"
#import "HL7Text.h"
#import "hL7Summary_Private.h"
#import "HL7SummaryEntry_Private.h"
#import "HL7VitalSignsSection.h"
#import "HL7VitalSignsSummary_Private.h"
#import "HL7VitalSignsEntry.h"
#import "HL7VitalSignsSummaryEntry_Private.h"
#import "HL7VitalSignsOrganizer_Private.h"

@implementation HL7VitalSignsAnalyzer

- (NSString *_Nullable)templateId
{
    return HL7TemplateVitalSignsEntriesRequired;
}

- (HL7VitalSignsSummaryEntry *)createVitalSignsSummaryEntryFromOrganizer:(HL7VitalSignsOrganizer *)organizer sectionText:(HL7Text *)sectionText
{
    if (organizer == nil || ![organizer hasAtLeastOneSummaryItem]) {
        return nil;
    }
    HL7VitalSignsSummaryEntry *entry = [[HL7VitalSignsSummaryEntry alloc] initWithOrganizer:organizer sectionText:sectionText];
    [entry setNarrative:[[[organizer code] displayName] copy]];
    return entry;
}

- (id<HL7SummaryProtocol> _Nonnull)analyzeSectionUsingDocument:(HL7CCD *_Nonnull)document
{
    HL7VitalSignsSection *vitalSignsSection = (HL7VitalSignsSection *)[document getSectionByTemplateId:[self templateId]];
    HL7VitalSignsSummary *summary = [[HL7VitalSignsSummary alloc] initWithElement:vitalSignsSection];

    if (vitalSignsSection != nil) {
        [summary setTitle:[[vitalSignsSection title] copy]];
        if (vitalSignsSection != nil) {
            for (HL7VitalSignsEntry *entry in [vitalSignsSection entries]) {
                HL7VitalSignsSummaryEntry *summaryEntry = [self createVitalSignsSummaryEntryFromOrganizer:[entry organizer] sectionText:[vitalSignsSection text]];
                if (summaryEntry != nil) {
                    [[summary entries] addObject:summaryEntry];
                }
            }
        }
    }
    return summary;
}
@end
