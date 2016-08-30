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


#import "PatientsTableViewController.h"
#import "URLManager.h"
#import "ThemeManager.h"
#import "FHIRPatientManagerApi.h"
#import "NetworkSettingsStorage.h"
#import "NetworkSettings.h"
#import "UIViewController+AlertMessage.h"
#import "UIViewController+RegisterCell.h"
#import "SectionStorage.h"
#import "PatientViewController.h"
#import "FHIRPatient+Extensions.h"
#import <SVProgressHUD/SVProgressHUD.h>

static NSString *kPatientsTableViewControllerCell = @"PatientCell";

@interface PatientsTableViewController ()
@property (nonatomic, strong) PatientsArray *patients;
@property (strong, nonatomic) HL7CCDSummary *ccdSummary;
@end

@implementation PatientsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.clearsSelectionOnViewWillAppear = YES;
    [self setTitle:NSLocalizedString(@"Patients.Title", nil)];

    // overrides UI setting
    [[self tableView] setRowHeight:60.0f];

    [[self refreshControl] setTintColor:[ThemeManager labelColor]];
    [self makePatientsRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self setCcdSummary:nil];
}

#pragma mark -

- (FHIRPatientManagerApi *)api
{
    return [[FHIRPatientManagerApi alloc] initWithURLManager:[URLManager sharedInstance] networkManager:[NetworkManager sharedInstance]];
}

- (void)makePatientsRequest
{
    NetworkSettings *networkSettings = [[NetworkSettingsStorage sharedIntance] load];

    [SVProgressHUD showWithStatus:NSLocalizedString(@"Loading.Patients", nil)];
    [[self api] getPatientsByIdentifier:[networkSettings npi]
                              completed:^(PatientsArray *data, NSError *error) {

                                  [SVProgressHUD dismiss];
                                  if ([[self refreshControl] isRefreshing]) {
                                      [[self refreshControl] endRefreshing];
                                  }

                                  if (error) {
                                      [self alertMessageWithError:error];
                                      return;
                                  }
                                  _patients = data;
                                  [[self tableView] reloadData];
                                  [[self tableView] setNeedsLayout];
                                  [[self tableView] layoutIfNeeded];
                                  [[self tableView] reloadData];
                              }];
}

- (void)makeCcdaRequestForPatient:(FHIRPatient *)patient
{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Loading.Ccda", nil)];
    [[self api] getCcda:[patient ccdaLink]
              completed:^(id data, NSError *error) {
                  [SVProgressHUD dismiss];
                  if (error) {
                      [self alertMessageWithError:error];
                      return;
                  }
                  [self parseXMLNSData:data];
              }];
}

- (void)parseXMLNSData:(NSData *)xmlData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void) {

        NSError *error;
        HL7Parser *parser = [HL7Parser new];

        [MMStopwatchARC start:@"ccda"];
        HL7CCDSummary *summary = [parser parseXMLNSData:xmlData templates:[SectionStorage activeTemplateIds] withEncoding:@"UTF-8" error:&error];
        [self setCcdSummary:summary];
        [MMStopwatchARC stop:@"ccda"];
        [SVProgressHUD dismiss];

        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self performSegueWithIdentifier:@"ccdaSegue" sender:self];
        });
    });
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self patients] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FHIRPatient *patient = self.patients[indexPath.row];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPatientsTableViewControllerCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kPatientsTableViewControllerCell];
        cell.textLabel.numberOfLines = 0;
        cell.detailTextLabel.text = nil;
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = patient.fullName;
    cell.detailTextLabel.text = patient.summary;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self makeCcdaRequestForPatient:[[self patients] objectAtIndex:indexPath.row]];
}

- (IBAction)doRefresh:(UIRefreshControl *)sender
{
    [self setPatients:nil];
    [self makePatientsRequest];
}

#pragma mark Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ccdaSegue"]) {
        UINavigationController *navController = [segue destinationViewController];
        PatientViewController *vc = ([navController viewControllers][0]);
        vc.ccdSummary = self.ccdSummary;
    }
}
@end
