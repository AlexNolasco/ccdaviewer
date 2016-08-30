//
//  HL7CCDSummary+BMI.m
//  ccdaviewer
//
//  Created by alexander nolasco on 8/28/16.
//  Copyright © 2016 coladapp.com. All rights reserved.
//

#import "HL7CCDSummary+BMI.h"

@implementation HL7CCDSummary (BMI)
- (NSString *)bmiFromCCDSummary
{
    HL7VitalSignsSummary *vitalSigns = (HL7VitalSignsSummary *)[self getSummaryByClass:[HL7VitalSignsSummary class]];
    if (!vitalSigns) {
        return NSLocalizedString(@"Common.NoData", nil);
    }
    HL7VitalSignsSummaryEntry *mostRecentEntry = [vitalSigns mostRecentEntry];
    if (!mostRecentEntry || ![mostRecentEntry.bmi.value length]) {
        return NSLocalizedString(@"Common.NoData", nil);
    }
    return mostRecentEntry.bmi.value;

}

- (NSString *)weightFromCCDSummary
{
    HL7VitalSignsSummary *vitalSigns = (HL7VitalSignsSummary *)[self getSummaryByClass:[HL7VitalSignsSummary class]];
    if (!vitalSigns) {
        return NSLocalizedString(@"Common.NoData", nil);
    }
    HL7VitalSignsSummaryEntry *mostRecentEntry = [vitalSigns mostRecentEntry];
    if (!mostRecentEntry || ![mostRecentEntry.weight.value length]) {
        return NSLocalizedString(@"Common.NoData", nil);
    }
    return mostRecentEntry.weight.value;
}

- (NSString *)weightUnitsFromCCDSummary
{
    HL7VitalSignsSummary *vitalSigns = (HL7VitalSignsSummary *)[self getSummaryByClass:[HL7VitalSignsSummary class]];
    if (!vitalSigns) {
        return NSLocalizedString(@"Common.Pounds", nil);
    }
    HL7VitalSignsSummaryEntry *mostRecentEntry = [vitalSigns mostRecentEntry];
    if (!mostRecentEntry || ![mostRecentEntry.weight.unitName length]) {
        return NSLocalizedString(@"Common.Pounds", nil);
    }

    return [mostRecentEntry.weight.unitName capitalizedString];
}

- (NSString *)ageFromCCDSummary
{
    if (!self.patient.ageHasValue) {
        return NSLocalizedString(@"Common.NoData", nil);
    }
    return [self.patient.age stringValue];
}

- (NSString *)heightFromCCDSummary
{
    HL7VitalSignsSummary *vitalSigns = (HL7VitalSignsSummary *)[self getSummaryByClass:[HL7VitalSignsSummary class]];
    if (!vitalSigns) {
        return NSLocalizedString(@"Common.NoData", nil);
    }
    HL7VitalSignsSummaryEntry *mostRecentEntry = [vitalSigns mostRecentEntry];
    if (!mostRecentEntry || ![mostRecentEntry.height.value length]) {
        return NSLocalizedString(@"Common.NoData", nil);
    }
    return mostRecentEntry.height.value;
}

- (NSString *)heightUnitsFromCCDSummary
{
    HL7VitalSignsSummary *vitalSigns = (HL7VitalSignsSummary *)[self getSummaryByClass:[HL7VitalSignsSummary class]];
    if (!vitalSigns) {
        return NSLocalizedString(@"Common.Feet", nil);
    }
    HL7VitalSignsSummaryEntry *mostRecentEntry = [vitalSigns mostRecentEntry];
    if (!mostRecentEntry || ![mostRecentEntry.height.unitName length]) {
        return NSLocalizedString(@"Common.Feet", nil);
    }
    return [mostRecentEntry.height.unitName capitalizedString];
}
@end
