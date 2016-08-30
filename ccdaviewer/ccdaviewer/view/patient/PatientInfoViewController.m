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


#import "PatientInfoViewController.h"
#import <ccdaparser/ccdaparser.h>
#import "PatientInfoNameViewCell.h"
#import "PatientInfoPhoneViewCell.h"
#import "PatientInfoGuardianViewCell.h"

static NSString* kPatientInfoNoDataViewCell = @"PatientInfoNoDataViewCell";

@interface PatientInfoViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation PatientInfoViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PatientInfoNameViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([PatientInfoNameViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PatientInfoPhoneViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([PatientInfoPhoneViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PatientInfoGuardianViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([PatientInfoGuardianViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:kPatientInfoNoDataViewCell bundle:nil] forCellReuseIdentifier:kPatientInfoNoDataViewCell];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if (section == 0) {
        return 1;
    }
    else if (section == 1) {
        return 1;
    }
    else if (section == 2) {
        return MAX(1, [self.ccdSummary.patient.guardians count]);
    }
    else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        PatientInfoNameViewCell * cell = (PatientInfoNameViewCell*)[self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PatientInfoNameViewCell class])];
        [cell fillWithCCDSummary:self.ccdSummary];
        return cell;
    }
    else if (indexPath.section == 1) {
        if ([self.ccdSummary.patient.phoneNumber length]) {
            PatientInfoPhoneViewCell * cell = (PatientInfoPhoneViewCell*)[self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PatientInfoPhoneViewCell class])];
            [cell fillWithPhoneNumber:self.ccdSummary.patient.phoneNumber];
            return cell;
        }
    }
    else if (indexPath.section == 2) {
        
        if ([self.ccdSummary.patient.guardians count]) {
            PatientInfoGuardianViewCell * cell = (PatientInfoGuardianViewCell*)[self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PatientInfoGuardianViewCell class])];
            [cell fillWithGuardian:self.ccdSummary.patient.guardians[indexPath.row]];
            return cell;
        }
    }
    return [tableView dequeueReusableCellWithIdentifier:kPatientInfoNoDataViewCell];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

#pragma mark UITableViewDelegate

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return @"Communication";
    }
    else if (section == 2) {
        return @"Guardians";
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01f;
    }
    return UITableViewAutomaticDimension;
}
@end
