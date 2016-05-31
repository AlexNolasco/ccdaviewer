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


#import "HL7EncounterAnalyzer.h"
#import "HL7Const.h"
#import "HL7CCD.h"
#import "HL7Code.h"
#import "HL7Enums.h"
#import "HL7Summary_Private.h"
#import "HL7EncounterSection.h"
#import "HL7EncounterSummary_Private.h"
#import "HL7EncounterEntry.h"
#import "HL7EncounterSummaryEntry_Private.h"

@implementation HL7EncounterAnalyzer
- (NSString *_Nullable)templateId
{
    return HL7TemplateEncounters;
}

- (HL7EncounterSummaryEntry *)createEncounterSummaryEntryFromEntry:(HL7EncounterEntry *)entry
{
    HL7EncounterSummaryEntry *summaryEntry = [[HL7EncounterSummaryEntry alloc] initWithEntry:entry];
    if (![[summaryEntry narrative] length]) {
        return nil;
    }
    return summaryEntry;
}

- (id<HL7SummaryProtocol> _Nonnull)analyzeSectionUsingDocument:(HL7CCD *_Nonnull)document
{
    HL7EncounterSection *section = (HL7EncounterSection *)[document getSectionByTemplateId:[self templateId]];
    HL7EncounterSummary *summary = [[HL7EncounterSummary alloc] initWithElement:section];

    for (HL7EncounterEntry *entry in [section entries]) {
        HL7EncounterSummaryEntry *summaryEntry = [self createEncounterSummaryEntryFromEntry:entry];
        if (summaryEntry != nil) {
            [[summary entries] addObject:summaryEntry];
        }
    }
    return summary;
}
@end
