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


#import <UIKit/UIKit.h>

//! Project version number for ccdaparser.
FOUNDATION_EXPORT double ccdaparserVersionNumber;

//! Project version string for ccdaparser.
FOUNDATION_EXPORT const unsigned char ccdaparserVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <ccdaparser/PublicHeader.h>

#import <ccdaparser/HL7Parser.h>
#import <ccdaparser/HL7SummaryInfo.h>
#import <ccdaparser/HL7Enums.h>
#import <ccdaparser/HL7Const.h>
#import <ccdaparser/HL7SummaryProtocol.h>
#import <ccdaparser/HL7SummarySearchProtocol.h>
#import <ccdaparser/HL7Element.h>
#import <ccdaparser/HL7NullFlavorElement.h>
#import <ccdaparser/HL7NamePart.h>
#import <ccdaparser/HL7Name.h>
#import <ccdaparser/HL7NullFlavorElement.h>
#import <ccdaparser/HL7DateRange.h>
#import <ccdaparser/HL7CodeSystem.h>
#import <ccdaparser/HL7LanguageCommunication.h>
#import <ccdaparser/HL7CodeSummary.h>
#import <ccdaparser/HL7PatientSummary.h>
#import <ccdaparser/HL7GuardianSummary.h>
#import <ccdaparser/HL7Summary.h>
#import <ccdaparser/HL7SummaryEntry.h>
#import <ccdaparser/HL7CCDSummary.h>
#import <ccdaparser/HL7SectionInfo.h>
#import <ccdaparser/HL7AllergyReactionSummary.h>
#import <ccdaparser/HL7AllergySummaryEntry.h>
#import <ccdaparser/HL7AllergySummary.h>
#import <ccdaparser/HL7ChiefComplainSummary.h>
#import <ccdaparser/HL7SocialHistorySummaryEntry.h>
#import <ccdaparser/HL7SocialHistorySummary.h>
#import <ccdaparser/HL7VitalSignsSummaryItem.h>
#import <ccdaparser/HL7VitalSignsSummaryEntry.h>
#import <ccdaparser/HL7VitalSignsSummary.h>
#import <ccdaparser/HL7MedicationSummaryEntry.h>
#import <ccdaparser/HL7MedicationSummary.h>
#import <ccdaparser/HL7ResultSummaryEntry.h>
#import <ccdaparser/HL7ResultSummary.h>
#import <ccdaparser/HL7PlanOfCareSummaryEntry.h>
#import <ccdaparser/HL7PlanOfCareSummary.h>
#import <ccdaparser/HL7PatientInstructionsSummaryEntry.h>
#import <ccdaparser/HL7PatientInstructionsSummary.h>
#import <ccdaparser/HL7ProblemSummaryEntry.h>
#import <ccdaparser/HL7ProblemSummary.h>
#import <ccdaparser/HL7ProcedureSummaryEntry.h>
#import <ccdaparser/HL7ProcedureSummary.h>
#import <ccdaparser/HL7EncounterSummaryEntry.h>
#import <ccdaparser/HL7EncounterSummary.h>
#import <ccdaparser/HL7ClinicalDocumentSummary.h>
