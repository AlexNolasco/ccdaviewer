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

#import "ViewerHL7VitalSignsAnalyzerCell.h"
#import "UIColor+LightAndDark.h"

@interface ViewerHL7VitalSignsAnalyzerCell ()
@property (weak, nonatomic) IBOutlet UILabel *bmiLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *heartRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *systolicLabel;
@property (weak, nonatomic) IBOutlet UILabel *diastolicLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation ViewerHL7VitalSignsAnalyzerCell
- (UIColor *)getBMIColorFromEntry:(HL7VitalSignsSummaryEntry *)entry
{
    if (![entry bmi] && [[[entry bmi] value] length]) {
        return nil;
    }
    float number = [[[entry bmi] value] floatValue];
    if (number >= 19.0f && number <= 24.9f) {
        return [UIColor colorWithRed:0.945 green:0.976 blue:0.737 alpha:1.00];
    } else if (number >= 25.0f && number <= 29.9f) {
        return [UIColor colorWithRed:1.000 green:0.875 blue:0.945 alpha:1.00];

    } else if (number >= 30.0f && number <= 34.9f) {
        return [UIColor colorWithRed:0.847 green:0.937 blue:1.000 alpha:1.00];

    } else if (number >= 35.0f && number <= 39.9f) {
        return [UIColor colorWithRed:1.000 green:0.933 blue:0.875 alpha:1.00];

    } else if (number >= 40.0f) {
        return [UIColor colorWithRed:1.000 green:0.749 blue:0.749 alpha:1.00];
    } else {
        return nil;
    }
}

#pragma mark -
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
        [[self dateLabel] setText:[vitals organizerEffectiveTimeHumanized]];
    } else {
        [[self dateLabel] setText:@""];
    }

    if (row == 0 && [vitals bmi]) {
        [[self contentView] setBackgroundColor:[self getBMIColorFromEntry:vitals]];
    }

    if ([vitals bmi]) {
        [[self bmiLabel] setText:[[vitals bmi] value]];
    } else {
        [[self bmiLabel] setText:@"--"];
    }

    if ([vitals weight]) {
        [[self weightLabel] setText:[[vitals weight] value]];
    } else {
        [[self weightLabel] setText:@"--"];
    }

    if ([vitals heartRate]) {
        [[self heartRateLabel] setText:[[vitals heartRate] value]];
    } else {
        [[self heartRateLabel] setText:@"--"];
    }

    if ([vitals bpSystolic]) {
        [[self systolicLabel] setText:[[vitals bpSystolic] value]];
    } else {
        [[self systolicLabel] setText:@"--"];
    }

    if ([vitals bpDiastolic]) {
        [[self diastolicLabel] setText:[[vitals bpDiastolic] value]];
    } else {
        [[self diastolicLabel] setText:@"--"];
    }
}
@end
