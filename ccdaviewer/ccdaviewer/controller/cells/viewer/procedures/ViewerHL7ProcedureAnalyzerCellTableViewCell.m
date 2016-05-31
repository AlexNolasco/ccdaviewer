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

#import "ViewerHL7ProcedureAnalyzerCellTableViewCell.h"

@interface ViewerHL7ProcedureAnalyzerCellTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *procedureNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation ViewerHL7ProcedureAnalyzerCellTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -
- (void)fillUsingSummary:(id<HL7SummaryProtocol>)summary
{
}

- (void)fillUsingSummaryEntry:(HL7SummaryEntry *)entry rowIndex:(NSUInteger)row
{
    if (![entry isKindOfClass:[HL7ProcedureSummaryEntry class]]) {
        return;
    }
    HL7ProcedureSummaryEntry *problemEntry = (HL7ProcedureSummaryEntry *)entry;

    [[self procedureNameLabel] setText:[problemEntry narrative]];
    if ([problemEntry date]) {
        [[self dateLabel] setText:[problemEntry dateAsString]];
    } else {
        [[self dateLabel] setText:@"--"];
    }
}
@end
