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


#import "ViewerHL7AllergyAnalyzerHeaderView.h"
#import <ccdaparser/ccdaparser.h>
#import "ThemeManager.h"

@interface ViewerHL7AllergyAnalyzerHeader ()
@property (weak, nonatomic) IBOutlet UILabel *legendLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ViewerHL7AllergyAnalyzerHeader

- (void)fillUsingSummaryEntry:(HL7SummaryEntry *)entry rowIndex:(NSUInteger)row
{
    // not supported by a header
}

- (void)fillUsingSummary:(id<HL7SummaryProtocol>)summary
{
    [[self titleLabel] setTextColor:[ThemeManager labelColor]];

    if ([summary isKindOfClass:[HL7AllergySummary class]]) {
        HL7AllergySummary *allergySummary = (HL7AllergySummary *)summary;

        NSString *message;

        if ([allergySummary noKnownMedicationAllergiesFound] && [allergySummary noKnownAllergiesFound]) {

            message = NSLocalizedString(@"SummaryAllergy.NoAllergies", nil);
        } else if ([allergySummary noKnownAllergiesFound]) {
            message = NSLocalizedString(@"SummaryAllergy.NoKnownAllergies", nil);
        } else if ([allergySummary noKnownMedicationAllergiesFound]) {
            message = NSLocalizedString(@"SummaryAllergy.NoKnownMedicationAllergies", nil);
        } else if ([summary allEntries]) {
            message = [NSString stringWithFormat:NSLocalizedString(@"SummaryAllergy.PatientHasAllergies", nil), [[allergySummary allEntries] count]];
        }

        if ([message length]) {
            [[self legendLabel] setText:message];
        } else {
            [[self legendLabel] setText:NSLocalizedString(@"SummaryAllergy.NoAdditionalInformation", nil)];
        }

        NSString *title = [[allergySummary sectionTitle] uppercaseString];
        [[self titleLabel] setText:title];
    }
}

@end
