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

#import "SectionViewController.h"
#import <ccdaparser/ccdaparser.h>
#import "SectionViewContext.h"
#import "SummaryViewProtocol.h"
#import "SummarySectionProtocol.h"
#import "SectionController.h"

static NSString *kSectionViewControllerCell = @"SummaryCell";
static NSString *kSectionViewControllerHeader = @"SummaryHeader";
static const CGFloat kSectionViewControllerEstimatedRowHeight = 44.0f;
static const CGFloat kSectionViewControllerEstimatedSectionHeaderHeight = 64.0f;

@interface SectionViewController () <UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) SectionController *sectionController;
@property (nonatomic, assign) BOOL hasHeader;
@property (nonatomic, strong) UISearchController *searchController;
@end

@implementation SectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.sectionViewContext.sectionInfo.name;
    self.tableView.estimatedRowHeight = kSectionViewControllerEstimatedRowHeight;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = kSectionViewControllerEstimatedSectionHeaderHeight;

    [self registerCell];
    [self setupSearchIfNeeded];
}

- (void)registerCell
{
    NSString *cellName = [self.sectionController cellNameForSectionKey:self.sectionViewContext.sectionInfo.nameAsKey];
    NSString *headerCellName = [self.sectionController headerNameForSectionKey:self.sectionViewContext.sectionInfo.nameAsKey];

    // Header
    if ([headerCellName length]) {
        [self.tableView registerNib:[UINib nibWithNibName:headerCellName bundle:nil] forHeaderFooterViewReuseIdentifier:kSectionViewControllerHeader];
        self.hasHeader = YES;
    }

    // Cell
    [self.tableView registerNib:[UINib nibWithNibName:cellName bundle:nil] forCellReuseIdentifier:kSectionViewControllerCell];
}

- (void)setupSearchIfNeeded
{
    if (![self.sectionController allowSearch]) {
        return;
    }
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    [self.searchController.searchBar sizeToFit];
    self.searchController.hidesNavigationBarDuringPresentation = YES;
    self.searchController.dimsBackgroundDuringPresentation = YES;
    self.definesPresentationContext = YES;
    self.tableView.tableHeaderView = self.searchController.searchBar;
}

- (SectionController *)sectionController
{
    if (_sectionController == nil) {
        _sectionController = [[SectionController alloc] initWithSectionViewContext:self.sectionViewContext];
    }
    return _sectionController;
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sectionController numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sectionController numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSectionViewControllerCell];

    if ([cell conformsToProtocol:@protocol(SummaryViewProtocol)]) {
        [((id<SummaryViewProtocol>)cell) fillUsingSummaryEntry:[self.sectionController entryAtIndexPath:indexPath] rowIndex:indexPath.row];
    }
    return cell;
}

#pragma mark UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!self.hasHeader) {
        return nil;
    }

    UIView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kSectionViewControllerHeader];
    if ([view conformsToProtocol:@protocol(SummarySectionProtocol)]) {
        [((id<SummarySectionProtocol>)view) fillWithDataSource:self.sectionController.dataSource section:section];
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [self.sectionController heightForHeaderInSection:section];
}

#pragma mark UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchText = searchController.searchBar.text;
    if ([searchController isActive]) {

        [self.sectionController filterByText:searchText];
        [self.tableView reloadData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    //[self.patientController clearSectionFilter];
    [self.tableView reloadData];
}

#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchController setActive:NO];
}

@end
