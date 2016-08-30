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
#import "PatientSummaryViewFooter.h"
#import "UIView+AutoLayout.h"
#import "NSDate+Formatting.h"

@interface PatientSummaryViewFooter ()
@property (nonatomic, weak) HL7CCDSummary *ccdSummary;
@property (nonatomic, weak) UILabel *title;
@property (nonatomic, weak) UILabel *dateTimeLabel;
@property (nonatomic, weak) UIStackView *stackView;

@end

@implementation PatientSummaryViewFooter


- (UIStackView *)stackView
{
    if (_stackView == nil) {
        UIStackView *stackView = [[UIStackView alloc] init];
        stackView.axis = UILayoutConstraintAxisVertical;
        stackView.distribution = UIStackViewDistributionEqualSpacing;
        stackView.alignment = UIStackViewAlignmentCenter;
        stackView.spacing = 5.0f;
        stackView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:stackView];
        _stackView = stackView;
    }
    return _stackView;
}
- (UILabel *)title
{
    if (_title == nil) {
        UILabel *label = [UILabel new];
        label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        label.textColor = [UIColor darkGrayColor];
        label.numberOfLines = 2;
        [label setTranslatesAutoresizingMaskIntoConstraints:NO];
        label.textAlignment = NSTextAlignmentCenter;
        [self.stackView addArrangedSubview:label];
        _title = label;
    }
    return _title;
}

- (UILabel *)dateTimeLabel
{
    if (_dateTimeLabel == nil) {
        UILabel *label = [UILabel new];
        label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
        label.textColor = [UIColor lightGrayColor];
        label.numberOfLines = 1;
        [label setTranslatesAutoresizingMaskIntoConstraints:NO];
        label.textAlignment = NSTextAlignmentCenter;
        [self.stackView addArrangedSubview:label];
        _dateTimeLabel = label;
    }
    return _dateTimeLabel;
}

- (void)fillWithCCDSummary:(HL7CCDSummary *)ccdSummary
{
    if ([ccdSummary.document.code.displayName length]) {
        self.title.text = [ccdSummary.document.code.displayName localizedCapitalizedString];
    } else {
        self.title.text = ccdSummary.document.title;
    }

    if (ccdSummary.document.effectiveTime) {
        self.dateTimeLabel.text = [ccdSummary.document.effectiveTime toShortDateString];
    } else {
        self.dateTimeLabel.text = NSLocalizedString(@"SummaryPatientInfo.DocumentDateUnknown", nil);
    }
    [self.stackView pinEdges:JRTViewPinTopEdge | JRTViewPinLeftEdge | JRTViewPinRightEdge toSameEdgesOfView:self.contentView inset:10.0f];
}
@end
