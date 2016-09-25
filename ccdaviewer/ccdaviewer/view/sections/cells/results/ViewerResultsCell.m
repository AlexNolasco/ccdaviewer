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

#import "ViewerResultsCell.h"
#import "NSDate+Formatting.h"


@interface ViewerResultsCell ()
@property (weak, nonatomic) IBOutlet UILabel *codeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultRangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultDateLabel;
@end

@implementation ViewerResultsCell

- (NSString *)getValueFromResultEntry:(HL7ResultSummaryEntry *)result
{
    if ([[result value] length]) {

        if ([[result units] length]) {
            return [NSString stringWithFormat:@"%@ (%@)", [result value], [result units]];
        } else {
            return [result value];
        }
    }
    return NSLocalizedString(@"Common.NoData", nil);
}

#pragma mark SummaryViewProtocol
- (void)fillUsingSummary:(id<HL7SummaryProtocol>)summary
{
    // not applicable
}

- (NSString *) resultRangeAsString: (HL7ResultRange) resultRange
{
    if (resultRange == HL7ResultRangeBelowNormal || resultRange == HL7ResultRangeAboveNormal) {
        return NSLocalizedString(@"ResultRange.Abnormal", nil);
    }
    else {
        return @"";
    }
}

- (NSAttributedString *) resultTextFromEntry:(HL7ResultSummaryEntry *)result
{
    NSString * resultRangString = [self resultRangeAsString: result.resultRange];
    NSString * resultString = [NSString stringWithFormat:@"%@ %@",[self getValueFromResultEntry:result], resultRangString];
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:resultString];
    
    if ([resultRangString length]) {
        [attributedString addAttribute:NSBackgroundColorAttributeName value:[UIColor yellowColor] range:[resultString rangeOfString:resultRangString]];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:8.0f] range:[resultString rangeOfString:resultRangString]];
    }
    return [attributedString copy];
}

- (void)fillUsingSummaryEntry:(HL7SummaryEntry *)entry rowIndex:(NSUInteger)row
{
    if (![entry isKindOfClass:[HL7ResultSummaryEntry class]]) {
        return;
    }
    HL7ResultSummaryEntry *result = (HL7ResultSummaryEntry *)entry;

    self.codeValueLabel.text = result.narrative;
    self.resultValueLabel.attributedText = [self resultTextFromEntry:result];

    if ([[result range] length]) {
        self.resultRangeLabel.text = result.range;
    } else {
        self.resultRangeLabel.text = NSLocalizedString(@"Common.NoData", nil);
    }
    if (result.date) {
        self.resultDateLabel.text = [result.date toShortDateString];
    } else {
        self.resultDateLabel.text = nil;
    }
}
@end
