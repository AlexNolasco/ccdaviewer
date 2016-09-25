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


#import "HL7ResultAnalyzer.h"
#import "HL7Const.h"
#import "HL7CCD.h"
#import "HL7Summary_Private.h"
#import "HL7ResultSummary_Private.h"
#import "HL7ResultSummaryEntry_Private.h"
#import "HL7ResultEntry.h"
#import "HL7ResultSection.h"
#import "HL7ResultObservation.h"
#import "HL7ResultOrganizer.h"
#import "HL7ResultRangeAnalyzer.h"
#import "HL7ClinicalDocument.h"
#import "HL7PatientRole.h"
#import "HL7Patient.h"

@interface  HL7ResultAnalyzer ()
@property (nonatomic, strong) HL7ResultRangeAnalyzer * resultRangeAnalyzer;
@end

@implementation HL7ResultAnalyzer
- (HL7ResultRangeAnalyzer *) resultRangeAnalyzer
{
    if (_resultRangeAnalyzer == nil) {
        _resultRangeAnalyzer = [HL7ResultRangeAnalyzer new];
    }
    return _resultRangeAnalyzer;
}

- (NSString *_Nullable)templateId
{
    return HL7TemplateResultsEntriesRequired;
}

- (HL7ResultSummaryEntry *_Nullable)createSummaryEntryFromElement:(HL7ResultObservation *)observation genderCode:(HL7AdministrativeGenderCode) genderCode
{
    if (![observation isEmpty]) {
        HL7ResultSummaryEntry * summaryEntry =  [[HL7ResultSummaryEntry alloc] initWithObservation:observation];
        summaryEntry.resultRange = [self.resultRangeAnalyzer resultRangeForSummaryEntry:observation forGender:genderCode];
        return summaryEntry;
    }
    return nil;
}

- (id<HL7SummaryProtocol> _Nonnull)analyzeSectionUsingDocument:(HL7CCD *_Nonnull)document
{
    HL7ResultSection *section = (HL7ResultSection *)[document getSectionByTemplateId:[self templateId]];
    HL7ResultSummary *summary = [[HL7ResultSummary alloc] initWithElement:section];

    
    for (HL7ResultEntry *entry in [section entries]) {
        for (HL7ResultObservation *observation in [[entry organizer] observations]) {
            // gender must have been analyzed prior to this section
            HL7ResultSummaryEntry *summaryEntry = [self createSummaryEntryFromElement:observation genderCode:document.clinicalDocument.patientRole.patient.gender];
            if (summaryEntry != nil) {
                [[summary entries] addObject:summaryEntry];
            }
        }
    }
    return summary;
}
@end
