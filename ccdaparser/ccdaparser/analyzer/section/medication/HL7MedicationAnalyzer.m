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


#import "HL7MedicationAnalyzer.h"
#import "HL7Const.h"
#import "HL7CCD.h"
#import "HL7MedicationSection.h"
#import "HL7MedicationSummary_Private.h"
#import "HL7MedicationSummaryEntry_Private.h"
#import "HL7MedicationEntry.h"
#import "hL7Summary_Private.h"

@implementation HL7MedicationAnalyzer

- (NSString *_Nullable)templateId
{
    return HL7TemplateMedications;
}

- (HL7MedicationSummaryEntry *_Nullable)createMedicationSummaryEntryFromMedicationEntry:(HL7MedicationEntry *)medicationEntry
{

    if (![[medicationEntry medicationName] length]) {
        return nil;
    }
    HL7MedicationSummaryEntry *result = [[HL7MedicationSummaryEntry alloc] initWithMedicationEntry:medicationEntry];
    return result;
}

- (id<HL7SummaryProtocol> _Nonnull)analyzeSectionUsingDocument:(HL7CCD *_Nonnull)document
{
    HL7MedicationSection *medicationSection = (HL7MedicationSection *)[document getSectionByTemplateId:[self templateId]];
    HL7MedicationSummary *summary = [[HL7MedicationSummary alloc] initWithElement:medicationSection];
    if (medicationSection != nil) {
        for (HL7MedicationEntry *medicationEntry in [medicationSection entries]) {
            HL7MedicationSummaryEntry *medicationSummaryEntry = [self createMedicationSummaryEntryFromMedicationEntry:medicationEntry];
            if (medicationSummaryEntry != nil) {
                [[summary entries] addObject:medicationSummaryEntry];
            }
        }
    }
    return summary;
}
@end
