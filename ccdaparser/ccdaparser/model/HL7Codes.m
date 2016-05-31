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


#import "HL7Codes.h"


NSString *const StatusCodeActive = @"Active";
NSString *const StatusCodeCompleted = @"Completed";

NSString *const ActCodeAssertion = @"ASSERTION";
NSString *const CodeSystemIdActCode = @"2.16.840.1.113883.5.4";
NSString *const CodeSystemIdSNOMEDCT = @"2.16.840.1.113883.6.96";

NSString *const CODESNOMEDCT = @"SNOMED CT";
NSString *const CODESNOMEDCTAllergyToSubstance = @"419199007";
NSString *const CODESNOMEDCTAllergyToDrug = @"416098002";
NSString *const CODESNOMEDSmokingStatusCurrentEveryDaySmoker = @"449868002";
NSString *const CODESNOMEDSmokingStatusCurrentSomeDaySmoker = @"230059006";
NSString *const CODESNOMEDSmokingStatusFormerSmoker = @"8517006";
NSString *const CODESNOMEDSmokingStatusNeverSmoker = @"266919005";
NSString *const CODESNOMEDSmokingStatusUnknownStatus = @"266927001";
NSString *const CODESNOMEDSmokingStatusUnknownIfEverSmoked = @"405746006";

NSString *const CODELOINCHeartRate = @"8867-4";
NSString *const CODELOINCBPSystolic = @"8480-6";
NSString *const CODELOINCBPDiastolic = @"8462-4";
NSString *const CODELOINCHeight = @"8302-2";
NSString *const CODELOINCWeight = @"3141-9";
NSString *const CODELOINCBMI = @"39156-5";
NSString *const CODELOINCTemperature = @"8310-5";
NSString *const CODELOINCSmokingStatus = @"72166-2";

// 2.16.840.1.113883.5.83
NSString *const CODEObservationInterpretation = @"2.16.840.1.113883.5.83";
