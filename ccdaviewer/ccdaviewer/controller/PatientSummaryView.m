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

#import "PatientSummaryView.h"
#import <ccdaparser/ccdaparser.h>

typedef NS_ENUM(NSInteger, PatientSummaryViewState) { PatientSummaryViewStateAge = 0, PatientSummaryViewStateMarriageStatus = 1, PatientSummaryViewStateLast = 2 };

@interface PatientSummaryView ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *legendLabel;
@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (nonatomic, assign) PatientSummaryViewState viewState;
@property (nonatomic, strong) NSString *ageLegend;
@property (nonatomic, strong) NSString *marriageStatusLegend;
@end

@implementation PatientSummaryView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self == nil) {
        return nil;
    }
    [self initalizeSubviews];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self == nil) {
        return nil;
    }
    [self initalizeSubviews];
    return self;
}

- (void)initalizeSubviews
{
    // Load the contents of the nib
    NSString *nibName = NSStringFromClass([self class]);
    UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
    [nib instantiateWithOwner:self options:nil];
    [[self container] setBackgroundColor:[UIColor redColor]];

    [self addSubview:self.container];
    [self resizeView:[self container] toParent:self];
    [self addSwipes];
}

- (void)addSwipes
{
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeViewLeft)];
    [swipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    [[self container] addGestureRecognizer:swipe];
}

- (void)swipeViewLeft
{
    [self setViewState:[self viewState] + 1];
    if ([self viewState] == PatientSummaryViewStateLast) {
        [self setViewState:PatientSummaryViewStateAge];
    }

    [UIView transitionWithView:self.legendLabel
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        switch ([self viewState]) {
                            case PatientSummaryViewStateAge:
                                [[self legendLabel] setText:[self ageLegend]];
                                break;
                            default:
                                [[self legendLabel] setText:[NSString stringWithFormat:NSLocalizedString(@"SummaryPatientInfo.MarriageStatus", nil), [self marriageStatusLegend]]];
                                break;
                        }
                    }
                    completion:nil];
}

- (void)resizeView:(UIView *)child toParent:(UIView *)parent
{
    [child setBackgroundColor:[UIColor orangeColor]];
    [child setTranslatesAutoresizingMaskIntoConstraints:NO];
    [parent addConstraints:@[
        [NSLayoutConstraint constraintWithItem:child attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:parent attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],

        [NSLayoutConstraint constraintWithItem:child attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:parent attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],

        [NSLayoutConstraint constraintWithItem:child attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:parent attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0],

        [NSLayoutConstraint constraintWithItem:child attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:parent attribute:NSLayoutAttributeRight multiplier:1 constant:0],
    ]];
}

#pragma mark -
- (void)fillWithCcdaSummary:(HL7CCDSummary *)summary
{
    HL7PatientSummary *patientSummary = [summary patient];

    switch ([patientSummary genderCode]) {
        case HL7AdministrativeGenderCodeMale:
            [[self picture] setImage:[UIImage imageNamed:@"Male"]];
            [[self container] setBackgroundColor:[ThemeManager male]];
            break;

        case HL7AdministrativeGenderCodeFemale:
            [[self picture] setImage:[UIImage imageNamed:@"Female"]];
            [[self container] setBackgroundColor:[ThemeManager female]];
            break;

        default:
            [[self picture] setImage:[UIImage imageNamed:@"UnknownGender"]];
            break;
    }
    [[self nameLabel] setText:[patientSummary fullName]];
    [self setAgeLegend:[self getLegendFromSummary:summary]];
    [self setMarriageStatusLegend:[self getMarriageStatusFromSummary:summary]];

    [[self legendLabel] setText:[self getLegendFromSummary:summary]];
}

- (NSString *)getMarriageStatusFromSummary:(HL7CCDSummary *)summary
{
    HL7PatientSummary *patientSummary = [summary patient];
    return [patientSummary maritalStatus];
}

- (NSString *)getLegendFromSummary:(HL7CCDSummary *)summary
{
    NSString *result;
    HL7PatientSummary *patientSummary = [summary patient];

    if ([patientSummary ageHasValue]) {
        result = [NSString stringWithFormat:NSLocalizedString(@"SummaryPatient.Legend", nil), [patientSummary gender], [patientSummary age], [self getWeightFromSummary:summary]];
    } else {
        result = NSLocalizedString(@"SummaryPatient.LegendEmpty", nil);
    }
    return result;
}

- (NSString *)getWeightFromSummary:(HL7CCDSummary *)summary
{
    HL7VitalSignsSummary *vitalSigns = (HL7VitalSignsSummary *)[summary getSummaryByClass:[HL7VitalSignsSummary class]];
    if (vitalSigns) {
        HL7VitalSignsSummaryEntry *latest = [vitalSigns mostRecentEntry];
        if ([latest weight]) {
            return [NSString stringWithFormat:@"%@ (%@)", [[latest weight] value], [[latest weight] unitName]];
        }
    }
    return @"";
}
@end
