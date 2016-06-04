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


#import <ccdaparser/ccdaparser.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "CcdaViewController.h"
#import "SectionStorage.h"
#import "UIViewController+RegisterCell.h"
#import "CellSectionInfoManager.h"
#import "SummaryCellSectionInfo.h"
#import "SummaryViewProtocol.h"
#import "PatientSummaryView.h"
#import "SectionActionSheet.h"

@interface CcdaViewController ()
@property (weak, nonatomic) IBOutlet PatientSummaryView *patientSummaryView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) HL7SectionInfoArray *activeSections;
@property (strong, nonatomic) CellSectionInfoManager *cellSectionInfoManager;
@property (strong, nonatomic) CellSectionInfoDictionary *cellSectionInfo;
@end

@implementation CcdaViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[self patientSummaryView] fillWithCcdaSummary:[self ccda]];
    [self setThemeSettings];

    // overrides UI setting


    [[self tableView] setEstimatedSectionHeaderHeight:120];
    [[self tableView] setSectionHeaderHeight:UITableViewAutomaticDimension];

    [[self tableView] setEstimatedRowHeight:80];
    [[self tableView] setRowHeight:UITableViewAutomaticDimension];


    // get ccda active sections
    [self setActiveSections:[SectionStorage activeSectionsFilteredBySummary:[self ccda]]];

    // register cells
    [[self cellSectionInfoManager] registerCellsForTableView:[self tableView] using:[self cellSectionInfo]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //    [[self tableView] reloadData];
    [[self tableView] setEstimatedSectionHeaderHeight:120];
    [[self tableView] setSectionHeaderHeight:UITableViewAutomaticDimension];

    [[self tableView] setEstimatedRowHeight:80];
    [[self tableView] setRowHeight:UITableViewAutomaticDimension];
}

- (void)setThemeSettings
{
    switch ([[[self ccda] patient] genderCode]) {
        case HL7AdministrativeGenderCodeMale:
            [[self view] setBackgroundColor:[ThemeManager male]];
            break;

        case HL7AdministrativeGenderCodeFemale:
            [[self view] setBackgroundColor:[ThemeManager female]];
            break;

        default:
            [[self view] setBackgroundColor:[ThemeManager labelColor]];
            break;
    }
}

- (CellSectionInfoManager *)cellSectionInfoManager
{
    if (_cellSectionInfoManager == nil) {
        _cellSectionInfoManager = [CellSectionInfoManager new];
    }
    return _cellSectionInfoManager;
}

- (CellSectionInfoDictionary *)cellSectionInfo
{
    if (_cellSectionInfo == nil) {
        _cellSectionInfo = [[self cellSectionInfoManager] getCellInfoForActiveSections];
    }
    return _cellSectionInfo;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)doneViewing:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (id<HL7SummaryProtocol>)getSummaryForSection:(NSUInteger)section
{
    HL7SectionInfo *sectionInfo = [[self activeSections] objectAtIndex:section];
    return [[[self ccda] summaries] objectForKey:[sectionInfo templateId]];
}

- (SummaryCellSectionInfo *)getSummaryCellInfoForSection:(NSUInteger)section
{
    HL7SectionInfo *sectionInfo = [[self activeSections] objectAtIndex:section];
    return [[self cellSectionInfo] objectForKey:[sectionInfo templateId]];
}

- (IBAction)sectionsAction:(id)sender
{
    SectionActionSheet *actionSheet = [[SectionActionSheet alloc] init];
    [actionSheet presentActionSheetUsingSectionsInArray:[self activeSections]
                                                 inView:self
                                                handler:^(NSUInteger section) {
                                                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
                                                    
                                                    id<HL7SummaryProtocol> summary = [self getSummaryForSection:section];
                                                    if ([[summary allEntries] count]>0) {
                                                        [[self tableView] scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                                                    }
                                                }];
}

#pragma mark - table delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self activeSections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (![self ccda]) {
        return 0;
    }
    id<HL7SummaryProtocol> summary = [self getSummaryForSection:section];
    return [[summary allEntries] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SummaryCellSectionInfo *cellViewInfo = [self getSummaryCellInfoForSection:indexPath.section];
    UITableViewCell *cell;

    if (cellViewInfo) {
        cell = [[self tableView] dequeueReusableCellWithIdentifier:[cellViewInfo detailCell]];
    }

    if (!cell) {
        cell = [[self tableView] dequeueReusableCellWithIdentifier:@"plainCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"plainCell"];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<HL7SummaryProtocol> summary = [self getSummaryForSection:[indexPath section]];
    if (!summary) {
        return;
    }

    HL7SummaryEntry *summaryEntry = [[summary allEntries] objectAtIndex:[indexPath row]];
    if ([cell conformsToProtocol:@protocol(SummaryViewProtocol)]) {
        [((id<SummaryViewProtocol>)cell) fillUsingSummaryEntry:summaryEntry rowIndex:indexPath.row];
    } else {
        [[cell textLabel] setText:[summaryEntry narrative]];
    }
}

#pragma mark - header

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    id<HL7SummaryProtocol> summary = [self getSummaryForSection:section];
    SummaryCellSectionInfo *cellInfo = [self getSummaryCellInfoForSection:section];

    if (!cellInfo) {
        return nil;
    }

    NSString *customHeaderName = [[self cellSectionInfoManager] getHeaderForSummary:summary defaultHeader:[cellInfo headerCell]];
    if (!customHeaderName) {
        return nil;
    }

    UITableViewHeaderFooterView *header = [[self tableView] dequeueReusableHeaderFooterViewWithIdentifier:customHeaderName];

    if ([header conformsToProtocol:@protocol(SummaryViewProtocol)]) {
        id<SummaryViewProtocol> svp = (id<SummaryViewProtocol>)header;
        [svp fillUsingSummary:summary];
    }
    return header;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    id<HL7SummaryProtocol> summary = [self getSummaryForSection:section];

    if ([[summary sectionTitle] length]) {
        return [summary sectionTitle];
    }

    HL7SectionInfo *sectionInfo = [[self activeSections] objectAtIndex:section];
    return [sectionInfo name];
}
@end
