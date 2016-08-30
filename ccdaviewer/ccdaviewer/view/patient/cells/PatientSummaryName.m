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

#import <ccdaparser/ccdaparser.h>
#import "PatientSummaryName.h"

@interface PatientSummaryName ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *legendLabel;
@end

@implementation PatientSummaryName
- (void)layoutSubviews
{
    [super layoutSubviews];
    [[self contentView] setBackgroundColor:[UIColor whiteColor]];
    [[self legendLabel] setTextColor:[ThemeManager labelColor]];
}

- (void)fillWithCCDSummary:(HL7CCDSummary *)ccdSummary
{
    self.nameLabel.text = ccdSummary.patient.fullName;
    self.legendLabel.text = [self summaryLabelFromCCDSummary:ccdSummary];
}

- (NSString *)summaryLabelFromCCDSummary:(HL7CCDSummary *)ccdSummary
{
    if (ccdSummary.patient.age && [ccdSummary.patient.gender length]) {
        return [NSString localizedStringWithFormat:NSLocalizedString(@"SummaryPatient.Legend", nil), ccdSummary.patient.gender, ccdSummary.patient.age];
    } else if (ccdSummary.patient.age) {
        return [NSString localizedStringWithFormat:NSLocalizedString(@"SummaryPatient.Legend.Age", nil), ccdSummary.patient.age];
    } else if (ccdSummary.patient.gender) {
        return ccdSummary.patient.gender;
    } else {
        return NSLocalizedString(@"Common.NoData", nil);
    }
}
@end
