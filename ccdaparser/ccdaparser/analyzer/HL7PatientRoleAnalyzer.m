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


#import "HL7CCD.h"
#import "HL7PatientRoleAnalyzer.h"
#import "HL7SummaryProtocol.h"
#import "HL7ClinicalDocument.h"
#import "HL7PatientRole.h"
#import "HL7PatientSummary.h"
#import "HL7PatientSummary_Private.h"

@implementation HL7PatientRoleAnalyzer

- (id<HL7SummaryProtocol> _Nonnull)analyzeSectionUsingDocument:(HL7CCD *_Nonnull)document
{
    HL7PatientRole *patientRole = [[document clinicalDocument] patientRole];
    HL7PatientSummary *patientSummary = [[HL7PatientSummary alloc] initWithPatientRole:patientRole];
    return patientSummary;
}
@end
