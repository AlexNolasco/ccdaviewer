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

#import "HL7PatientInstrutionsAnalyzer.h"
#import "HL7Const.h"
#import "HL7CCD.h"
#import "HL7Code.h"
#import "HL7Enums.h"
#import "HL7OriginalText.h"
#import "HL7EffectiveTime.h"
#import "HL7Summary_Private.h"
#import "HL7PatientInstructionsSummary_Private.h"
#import "HL7PatientInstructionsSummaryEntry_Private.h"
#import "HL7PatientInstructionsSection.h"
#import "HL7PatientInstructionsSummary.h"
#import "HL7PatientInstructionsEntry.h"

@implementation HL7PatientInstrutionsAnalyzer

- (NSString *_Nullable)templateId
{
    return HL7TemplatePatientInstructions;
}

- (HL7PatientInstructionsSummaryEntry *)createInstructionSummaryEntryFromAct:(HL7Act *)act
{
    return [[HL7PatientInstructionsSummaryEntry alloc] initWithAct:act];
}

- (id<HL7SummaryProtocol> _Nonnull)analyzeSectionUsingDocument:(HL7CCD *_Nonnull)document
{
    HL7PatientInstructionsSection *section = (HL7PatientInstructionsSection *)[document getSectionByTemplateId:[self templateId]];
    HL7PatientInstructionsSummary *summary = [[HL7PatientInstructionsSummary alloc] initWithElement:section];

    for (HL7PatientInstructionsEntry *entry in [section entries]) {
        HL7PatientInstructionsSummaryEntry *instruction = [self createInstructionSummaryEntryFromAct:[entry act]];

        if ([[instruction narrative] length]) {
            [[summary entries] addObject:instruction];
        }
    }
    return summary;
}
@end
