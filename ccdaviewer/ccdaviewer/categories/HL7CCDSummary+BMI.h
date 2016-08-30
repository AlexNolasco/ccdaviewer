//
//  HL7CCDSummary+BMI.h
//  ccdaviewer
//
//  Created by alexander nolasco on 8/28/16.
//  Copyright © 2016 coladapp.com. All rights reserved.
//

#import <ccdaparser/ccdaparser.h>

@interface HL7CCDSummary (BMI)
- (NSString *)bmiFromCCDSummary;
- (NSString *)weightFromCCDSummary;
- (NSString *)weightUnitsFromCCDSummary;
- (NSString *)ageFromCCDSummary;
- (NSString *)heightFromCCDSummary;
- (NSString *)heightUnitsFromCCDSummary;
@end
