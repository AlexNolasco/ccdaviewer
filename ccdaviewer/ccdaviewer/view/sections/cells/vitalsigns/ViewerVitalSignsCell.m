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

#import "ViewerVitalSignsCell.h"
#import "UIColor+LightAndDark.h"

@interface ViewerVitalSignsCell ()
@property (weak, nonatomic) IBOutlet UILabel *bmiLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *heartRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *systolicLabel;
@property (weak, nonatomic) IBOutlet UILabel *diastolicLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *bmiUnitsLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightUnitsLabel;
@property (weak, nonatomic) IBOutlet UILabel *heartRateUnitsLabel;
@property (weak, nonatomic) IBOutlet UILabel *systolicUnitsLabel;
@property (weak, nonatomic) IBOutlet UILabel *diastolicUnitsLabel;

@end

@implementation ViewerVitalSignsCell
- (UIColor *)getBMIColorFromEntry:(HL7VitalSignsSummaryEntry *)entry
{
    if (![entry bmi] && [[[entry bmi] value] length]) {
        return nil;
    }
    float number = [[[entry bmi] value] floatValue];
    if (number >= 19.0f && number <= 24.9f) {
        return [UIColor colorWithRed:0.945 green:0.976f blue:0.737f alpha:1.00f];
    } else if (number >= 25.0f && number <= 29.9f) {
        return [UIColor colorWithRed:1.000 green:0.875f blue:0.945f alpha:1.00f];
    } else if (number >= 30.0f && number <= 34.9f) {
        return [UIColor colorWithRed:0.847 green:0.937f blue:1.000f alpha:1.00f];
    } else if (number >= 35.0f && number <= 39.9f) {
        return [UIColor colorWithRed:1.000 green:0.933f blue:0.875f alpha:1.00f];
    } else if (number >= 40.0f) {
        return [UIColor colorWithRed:1.000 green:0.749f blue:0.749f alpha:1.00f];
    } else {
        return nil;
    }
}

#pragma mark SummaryViewProtocol
- (void)fillUsingSummary:(id<HL7SummaryProtocol>)summary
{
}

- (void)fillUsingSummaryEntry:(HL7SummaryEntry *)entry rowIndex:(NSUInteger)row
{
    if (![entry isKindOfClass:[HL7VitalSignsSummaryEntry class]]) {
        return;
    }
    HL7VitalSignsSummaryEntry *vitals = (HL7VitalSignsSummaryEntry *)entry;

    if ([vitals organizerEffectiveTime]) {
        self.dateLabel.text = [vitals organizerEffectiveTimeHumanized];
    } else {
        self.dateLabel.text = nil;
    }

    if (row == 0 && [vitals bmi]) {
        [[self contentView] setBackgroundColor:[self getBMIColorFromEntry:vitals]];
    }

    if (vitals.bmi) {
        self.bmiLabel.text = vitals.bmi.value;
        self.bmiUnitsLabel.text = vitals.bmi.unitName;
    } else {
        self.bmiLabel.text = NSLocalizedString(@"Common.NoData", nil);
        self.bmiUnitsLabel.text = nil;
    }

    if ([vitals weight]) {
        self.weightLabel.text = vitals.weight.value;
        self.weightUnitsLabel.text = vitals.weight.unitName;
    } else {
        self.weightLabel.text = NSLocalizedString(@"Common.NoData", nil);
        self.weightUnitsLabel.text = nil;
    }

    if ([vitals heartRate]) {
        self.heartRateLabel.text = vitals.heartRate.value;
        self.heartRateUnitsLabel.text = vitals.heartRate.unitName;
    } else {
        self.heartRateLabel.text = NSLocalizedString(@"Common.NoData", nil);
        self.heartRateUnitsLabel.text = nil;
    }

    if ([vitals bpSystolic]) {
        self.systolicLabel.text = vitals.bpSystolic.value;
        self.systolicUnitsLabel.text = vitals.bpSystolic.unitName;
    } else {
        self.systolicLabel.text = NSLocalizedString(@"Common.NoData", nil);
        self.systolicUnitsLabel.text = nil;
    }

    if ([vitals bpDiastolic]) {
        self.diastolicLabel.text = vitals.bpDiastolic.value;
        self.diastolicUnitsLabel.text = vitals.bpDiastolic.unitName;
    } else {
        self.diastolicLabel.text = NSLocalizedString(@"Common.NoData", nil);
        self.diastolicUnitsLabel.text = nil;
    }
}
@end
