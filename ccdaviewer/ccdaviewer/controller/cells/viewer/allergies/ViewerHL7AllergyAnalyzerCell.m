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

#import "ViewerHL7AllergyAnalyzerCell.h"
#import "UIColor+LightAndDark.h"

@interface ViewerHL7AllergyAnalyzerCell ()
@property (weak, nonatomic) IBOutlet UILabel *allergyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *severityLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *reactionLabel;
@end

@implementation ViewerHL7AllergyAnalyzerCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (UIColor *)getServerityColorFromCode:(HL7ProblemSeverityCode)severityCode
{
    switch (severityCode) {
        case HL7ProblemSeverityCodeFatal:
            return [UIColor colorWithRed:0.996 green:0.800 blue:0.831 alpha:1.00];

        case HL7ProblemSeverityCodeSevere:
        case HL7ProblemSeverityCodeModerateToSevere:
            return [UIColor colorWithRed:1.000 green:0.914 blue:0.800 alpha:1.00];

        case HL7ProblemSeverityCodeModerate:
            return [UIColor colorWithRed:0.992 green:0.973 blue:0.800 alpha:1.00];

        case HL7ProblemSeverityCodeMildToModerate:
            return [UIColor colorWithRed:0.902 green:0.941 blue:0.980 alpha:1.00];

        case HL7ProblemSeverityCodeMild:
            return [UIColor colorWithRed:0.831 green:0.894 blue:0.957 alpha:1.00];

        case HL7ProblemSeverityCodeUnknown:
            return [UIColor colorWithRed:0.800 green:0.933 blue:0.886 alpha:1.00];
    }
    return [UIColor redColor];
}

- (UIColor *)getServerityBarColorFromCode:(HL7ProblemSeverityCode)severityCode
{
    switch (severityCode) {
        case HL7ProblemSeverityCodeFatal:
            return [UIColor colorWithRed:0.992 green:0.000 blue:0.165 alpha:1.00];

        case HL7ProblemSeverityCodeSevere:
        case HL7ProblemSeverityCodeModerateToSevere:
            return [UIColor colorWithRed:1.000 green:0.584 blue:0.000 alpha:1.00];

        case HL7ProblemSeverityCodeModerate:
            return [UIColor colorWithRed:0.969 green:0.871 blue:0.000 alpha:1.00];

        case HL7ProblemSeverityCodeMildToModerate:
            return [UIColor colorWithRed:0.165 green:0.482 blue:0.796 alpha:1.00];

        case HL7ProblemSeverityCodeMild:
            return [UIColor colorWithRed:0.000 green:0.682 blue:0.435 alpha:1.00];

        case HL7ProblemSeverityCodeUnknown:
            return [UIColor colorWithRed:0.000 green:0.682 blue:0.435 alpha:1.00];
    }
    return [UIColor redColor];
}

- (void)addVerticalLineWithColor:(UIColor *)color
{
    UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(4.0, 0.0, 2.0, self.contentView.bounds.size.height)];
    verticalLine.backgroundColor = color;
    verticalLine.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    [self.contentView addSubview:verticalLine];
}

#pragma mark -
- (void)fillUsingSummary:(id<HL7SummaryProtocol>)summary
{
    // not supported by entry
}

- (void)fillUsingSummaryEntry:(HL7SummaryEntry *)entry rowIndex:(NSUInteger)row
{
    if (![entry isKindOfClass:[HL7AllergySummaryEntry class]]) {
        return;
    }
    HL7AllergySummaryEntry *allergySummaryEntry = (HL7AllergySummaryEntry *)entry;
    UIColor *color = [self getServerityColorFromCode:[allergySummaryEntry problemSeverityCode]];
    [[self contentView] setBackgroundColor:color];

    [[self allergyNameLabel] setText:[allergySummaryEntry allergen]];
    [[self severityLabel] setText:[allergySummaryEntry severity]];
    [[self statusLabel] setText:[allergySummaryEntry status]];

    const NSUInteger reactions = [[allergySummaryEntry allReactions] count];
    if (reactions > 1) {
        NSString *reactionMessage = [NSString stringWithFormat:NSLocalizedString(@"SummaryAllergy.ReactionAndOther", nil), [allergySummaryEntry firstReaction], reactions];
        [[self reactionLabel] setText:reactionMessage];
    } else {
        [[self reactionLabel] setText:[allergySummaryEntry firstReaction]];
    }


    [self addVerticalLineWithColor:[self getServerityBarColorFromCode:[allergySummaryEntry problemSeverityCode]]];
}
@end
