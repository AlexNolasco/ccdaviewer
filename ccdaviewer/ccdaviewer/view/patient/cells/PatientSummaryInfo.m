//
//  PatientSummaryInfo.m
//  ccdaviewer
//
//  Created by alexander nolasco on 7/22/16.
//  Copyright © 2016 coladapp.com. All rights reserved.
//

#import <ccdaparser/ccdaparser.h>
#import "PatientSummaryInfo.h"
#import "UIView+AutoLayout.h"
#import "HL7CCDSummary+BMI.h"

@interface PatientSummaryInfo ()

@property (weak, nonatomic) IBOutlet UILabel *bmiLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearsLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightUnitsLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearsUnitsLabel;
@property (weak, nonatomic) IBOutlet UILabel *bmiUnitsLabel;
@end

@implementation PatientSummaryInfo

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.bmiUnitsLabel.textColor = [ThemeManager labelColor];
    self.weightUnitsLabel.textColor = [ThemeManager labelColor];
    self.yearsUnitsLabel.textColor = [ThemeManager labelColor];
}

- (void)fillWithCCDSummary:(HL7CCDSummary *)ccdSummary
{
    self.bmiLabel.text = [ccdSummary bmiFromCCDSummary];
    self.weightLabel.text = [ccdSummary weightFromCCDSummary];
    self.weightUnitsLabel.text = [ccdSummary weightUnitsFromCCDSummary];
    self.yearsLabel.text = [ccdSummary ageFromCCDSummary];
}
@end
