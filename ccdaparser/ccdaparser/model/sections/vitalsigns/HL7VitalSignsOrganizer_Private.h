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


#import "HL7VitalSignsOrganizer.h"
@class HL7VitalSignsObservation;

@interface HL7VitalSignsOrganizer ()
- (HL7VitalSignsObservation *_Nullable)getObservationByCodeId:(NSString *_Nonnull)codeId;
- (HL7VitalSignsObservation *_Nullable)bmi;
- (HL7VitalSignsObservation *_Nullable)height;
- (HL7VitalSignsObservation *_Nullable)weight;
- (HL7VitalSignsObservation *_Nullable)bpSystolic;
- (HL7VitalSignsObservation *_Nullable)bpDiastolic;
- (HL7VitalSignsObservation *_Nullable)heartRate;
- (HL7VitalSignsObservation *_Nullable)temperature;
- (BOOL)hasAtLeastOneSummaryItem;
@end
