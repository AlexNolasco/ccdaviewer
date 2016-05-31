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


#import "HL7VitalSignsSummaryEntry.h"
@class HL7VitalSignsSummaryItem;
@class HL7VitalSignsOrganizer;
@class HL7Text;

@interface HL7VitalSignsSummaryEntry ()
@property (nullable, nonatomic, strong) HL7VitalSignsSummaryItem *bmi;
@property (nullable, nonatomic, strong) HL7VitalSignsSummaryItem *heartRate;
@property (nullable, nonatomic, strong) HL7VitalSignsSummaryItem *bpSystolic;
@property (nullable, nonatomic, strong) HL7VitalSignsSummaryItem *bpDiastolic;
@property (nullable, nonatomic, strong) HL7VitalSignsSummaryItem *weight;
@property (nullable, nonatomic, strong) HL7VitalSignsSummaryItem *height;
@property (nullable, nonatomic, strong) HL7VitalSignsSummaryItem *temperature;
@property (nullable, nonatomic, strong) NSDate *organizerEffetiveTime;
@property (nullable, nonatomic, strong) NSString *organizerEffectiveTimeHumanized;
- (instancetype _Nonnull)initWithOrganizer:(HL7VitalSignsOrganizer *_Nonnull)organizer sectionText:(HL7Text *_Nullable)sectionText;
@end
