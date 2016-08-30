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
#import "PatientViewController.h"
#import "PatientController.h"
#import "PatientSummaryViewHeader.h"
#import "PatientSummaryViewFooter.h"
#import "SectionStorage.h"
#import "SectionViewController.h"
#import "SectionViewContext.h"
#import "PatientInfoViewController.h"

static NSString *kPatientViewControllerCell = @"PatientViewControllerCell";
static const CGFloat kPatientViewControllerHeaderHeight = 90.0f;
static const CGFloat kPatientViewControllerFooterHeight = 60.0f;
static const CGFloat kPatientViewControllerHeaderRowHeight = 80.0f;

@interface PatientViewController () <UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) PatientController *patientController;
@property (nonatomic, assign) NSInteger selectedSection;
@end

@implementation PatientViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(close:)];
    [self.tableView registerClass:[PatientSummaryViewHeader class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([PatientSummaryViewHeader class])];
    [self.tableView registerClass:[PatientSummaryViewFooter class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([PatientSummaryViewFooter class])];
    self.tableView.rowHeight = kPatientViewControllerHeaderRowHeight;
    self.tableView.sectionHeaderHeight = kPatientViewControllerHeaderHeight;
    self.tableView.sectionFooterHeight = kPatientViewControllerFooterHeight;

    [self setupSearchController];
    [self.patientController filterSectionsByString:nil];
}

- (void)setupSearchController
{
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    [self.searchController.searchBar sizeToFit];
    self.searchController.hidesNavigationBarDuringPresentation = YES;
    self.searchController.dimsBackgroundDuringPresentation = YES;
    self.definesPresentationContext = YES;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    [self.tableView setContentOffset:CGPointMake(0, self.searchController.searchBar.frame.size.height) animated:NO];
}

- (void)close:(id)sender
{
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 NSLog(@"controller dismissed");
                             }];
}

- (PatientController *)patientController
{
    if (_patientController == nil) {
        _patientController = [[PatientController alloc] initWithHL7CCDSummary:self.ccdSummary];
    }
    return _patientController;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if (section == 0) {
        return [self.patientController countOfActiveSectionsFilteredSections];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPatientViewControllerCell];
    HL7SectionInfo *sectionInfo = [self.patientController sectionInfoAtIndex:indexPath.row];
    id<HL7SummaryProtocol> summary = [self.patientController summaryByTemplateId:sectionInfo.templateId];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kPatientViewControllerCell];
        cell.textLabel.numberOfLines = 0;
        cell.detailTextLabel.text = nil;
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    if (summary) {
        cell.imageView.image = [[self patientController] imageForSection:sectionInfo];
        cell.imageView.tintColor = [ThemeManager labelColor];
        cell.textLabel.text = [[summary title] capitalizedString];

        [self.patientController entriesMessageForSummaryForSummary:summary
                                                         withBlock:^(BOOL hasEntries, NSString *message) {
                                                             if (hasEntries) {
                                                                 cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                                                             } else {
                                                                 cell.accessoryType = UITableViewCellAccessoryNone;
                                                             }
                                                             cell.detailTextLabel.text = message;
                                                         }];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([PatientSummaryViewHeader class])];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([PatientSummaryViewFooter class])];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    PatientSummaryViewHeader *header = (PatientSummaryViewHeader *)view;
    [header fillWithCCDSummary:self.ccdSummary];
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    PatientSummaryViewFooter *footer = (PatientSummaryViewFooter *)view;
    [footer fillWithCCDSummary:self.ccdSummary];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedSection = indexPath.row;
    [self performSegueWithIdentifier:@"ccdaSectionSegue" sender:self];
}

#pragma mark UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchText = searchController.searchBar.text;
    if ([searchController isActive]) {
        [self.patientController filterSectionsByString:searchText];
        [self.tableView reloadData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.patientController clearSectionFilter];
    [self.tableView reloadData];
}

#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchController setActive:NO];
}

#pragma mark Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"ccdaSectionSegue"]) {
        SectionViewController *targetViewController = (SectionViewController *)segue.destinationViewController;
 
         SectionViewContext *sectionViewContext = [SectionViewContext new];
         
         sectionViewContext.ccdSummary = self.ccdSummary;
         sectionViewContext.sectionInfo = [self.patientController sectionInfoAtIndex:self.selectedSection];
         sectionViewContext.sectionSummary = [self.patientController summaryByTemplateId:sectionViewContext.sectionInfo.templateId];
    
         targetViewController.sectionViewContext = sectionViewContext;
    }
    else if ([segue.identifier isEqualToString:@"patientInfoSegue"]) {
        PatientInfoViewController *patientInfoViewController = (PatientInfoViewController *)segue.destinationViewController;
        patientInfoViewController.ccdSummary = self.ccdSummary;
    }
}

@end
