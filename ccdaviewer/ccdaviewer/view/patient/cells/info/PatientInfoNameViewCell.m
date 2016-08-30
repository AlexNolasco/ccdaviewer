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

#import "PatientInfoNameViewCell.h"
#import <ccdaparser/ccdaparser.h>
#import "HL7CCDSummary+BMI.h"
#import "ThemeManager.h"

@interface PatientInfoNameViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bmiLabel;
@property (weak, nonatomic) IBOutlet UILabel *bmiUnitsLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightUnitsLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearsLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearsUnitsLabel;
@property (weak, nonatomic) IBOutlet UILabel *heightLabel;
@property (weak, nonatomic) IBOutlet UILabel *heightUnitsLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@end

@implementation PatientInfoNameViewCell

- (void)fillWithCCDSummary:(HL7CCDSummary *)ccdSummary
{
   [self populateLabelsWithSummary:ccdSummary];
   [self populateSummaryLabelWithSummary:ccdSummary];
}

- (void)populateSummaryLabelWithSummary:(HL7CCDSummary *)ccdSummary
{
    NSString * firstName = [ccdSummary.patient.name.first length] ? ccdSummary.patient.name.first : @"Patient";
    
    NSString * maritalStatus = ccdSummary.patient.maritalStatusCode != HL7MaritalStatusCodeUnknown ? [NSString stringWithFormat:@" %@ ", [ccdSummary.patient.maritalStatus lowercaseString]] : @"" ;

    NSString * race = [ccdSummary.patient.race length] ? [NSString stringWithFormat:@" %@ ", ccdSummary.patient.race] : @"";

    NSString * gender = ccdSummary.patient.genderCode  != HL7AdministrativeGenderCodeUnknown ? [NSString stringWithFormat:@" %@ ", [ccdSummary.patient.gender lowercaseString]]  : @"";
    
    NSString * religiousAffiliation = [ccdSummary.patient.religiousAffiliation length] ? ccdSummary.patient.religiousAffiliation : @"unknown";
    
    NSString * language = [ccdSummary.patient.preferredLanguage length] ? ccdSummary.patient.preferredLanguage : @"no English";

    NSString * text = [NSString stringWithFormat:@"%@ is a%@%@%@ whose religion is %@ and speaks %@", firstName, maritalStatus, race, gender, religiousAffiliation, language];
    
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:[ThemeManager labelColor] range:[text rangeOfString:firstName]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[ThemeManager labelColor] range:[text rangeOfString:maritalStatus]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[ThemeManager labelColor] range:[text rangeOfString:gender]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[ThemeManager labelColor] range:[text rangeOfString:language]];
    
    self.summaryLabel.attributedText = attributedString;
}

- (void)populateLabelsWithSummary:(HL7CCDSummary *)ccdSummary
{
    self.nameLabel.text = ccdSummary.patient.fullName;
    self.bmiUnitsLabel.textColor = [ThemeManager labelColor];
    self.weightUnitsLabel.textColor = [ThemeManager labelColor];
    self.yearsUnitsLabel.textColor = [ThemeManager labelColor];
    self.heightUnitsLabel.textColor = [ThemeManager labelColor];
    
    self.bmiLabel.text = [ccdSummary bmiFromCCDSummary];
    self.weightLabel.text = [ccdSummary weightFromCCDSummary];
    self.weightUnitsLabel.text = [ccdSummary weightUnitsFromCCDSummary];
    self.yearsLabel.text = [ccdSummary ageFromCCDSummary];
    self.heightLabel.text = [ccdSummary heightFromCCDSummary];
    self.heightUnitsLabel.text = [ccdSummary heightUnitsFromCCDSummary];
}
@end
