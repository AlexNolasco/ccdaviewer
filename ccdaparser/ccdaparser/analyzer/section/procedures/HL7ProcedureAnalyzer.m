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


#import "HL7ProcedureAnalyzer.h"
#import "HL7Const.h"
#import "HL7CCD.h"
#import "HL7Code.h"
#import "HL7Enums.h"
#import "HL7Summary_Private.h"
#import "HL7ProcedureSummary_Private.h"
#import "HL7ProcedureSummaryEntry_Private.h"
#import "HL7ProcedureEntry.h"
#import "HL7ProcedureSection.h"

@implementation HL7ProcedureAnalyzer
- (NSString *_Nullable)templateId
{
    return HL7TemplateProcedures;
}

- (HL7ProcedureSummaryEntry *)createProblemsSummaryEntryFromAct:(HL7ProcedureEntry *)entry
{
    if (entry == nil) {
        return nil;
    }
    return [[HL7ProcedureSummaryEntry alloc] initWithProcedureEntry:entry];
}

- (id<HL7SummaryProtocol> _Nonnull)analyzeSectionUsingDocument:(HL7CCD *_Nonnull)document
{
    HL7ProcedureSection *section = (HL7ProcedureSection *)[document getSectionByTemplateId:[self templateId]];

    HL7ProcedureSummary *summary = [[HL7ProcedureSummary alloc] initWithElement:section];

    for (HL7ProcedureEntry *entry in [section entries]) {
        HL7ProcedureSummaryEntry *summaryEntry = [self createProblemsSummaryEntryFromAct:entry];
        if (summaryEntry != nil && [[summaryEntry narrative] length]) {
            [[summary entries] addObject:summaryEntry];
        }
    }
    return summary;
}
@end
