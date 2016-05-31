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


#import "HL7SummaryEntry.h"
@class HL7VitalSignsSummaryItem;

/** Summary of organizer */
@interface HL7VitalSignsSummaryEntry : HL7SummaryEntry <NSCopying, NSCoding>
- (HL7VitalSignsSummaryItem *_Nullable)bmi;
- (HL7VitalSignsSummaryItem *_Nullable)heartRate;
- (HL7VitalSignsSummaryItem *_Nullable)bpSystolic;
- (HL7VitalSignsSummaryItem *_Nullable)bpDiastolic;
- (HL7VitalSignsSummaryItem *_Nullable)weight;
- (HL7VitalSignsSummaryItem *_Nullable)height;
- (HL7VitalSignsSummaryItem *_Nullable)temperature;
- (NSDate *_Nullable)organizerEffectiveTime;
- (NSString *_Nullable)organizerEffectiveTimeHumanized;
@end
