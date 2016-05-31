//
//  ViewerGenericHeader.m
//  ccdaviewer
//
//  Created by alexander nolasco on 5/28/16.
//  Copyright © 2016 coladapp.com. All rights reserved.
//

#import "ViewerGenericHeader.h"

@interface ViewerGenericHeader ()
@property (weak, nonatomic) IBOutlet UILabel *sectionLabel;
@end

@implementation ViewerGenericHeader

- (void)fillUsingSummaryEntry:(HL7SummaryEntry *)entry rowIndex:(NSUInteger)row
{
    // not supported by a header
}

- (void)fillUsingSummary:(id<HL7SummaryProtocol>)summary
{
    NSString *title = [summary sectionTitle];
    [[self sectionLabel] setText:[title uppercaseString]];
    [[self sectionLabel] setTextColor:[ThemeManager labelColor]];
}

@end
