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


#import "SettingsTableViewController.h"
#import "NetworkSettings.h"
#import "NetworkSettingsStorage.h"
#import "ThemeManager.h"
#import "UIViewController+AlertMessage.h"
#import "URLManager.h"

@interface SettingsTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *urlTextBox;
@property (weak, nonatomic) IBOutlet UITextField *npiTextBox;
@property (weak, nonatomic) IBOutlet UILabel *urlLabel;
@property (weak, nonatomic) IBOutlet UILabel *npiLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UILabel *aboutLabel;
@end

@implementation SettingsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationItem] setTitle:NSLocalizedString(@"Settings.Title", nil)];
    [[self saveButton] setTitle:NSLocalizedString(@"Common.Save", nil)];
    [[self aboutLabel] setText:NSLocalizedString(@"NetworkSettings.About", nil)];

    NetworkSettings *networkSettings = [[NetworkSettingsStorage sharedIntance] load];
    [[self urlTextBox] setText:[[networkSettings url] absoluteString]];
    [[self npiTextBox] setText:[networkSettings npi]];

    [[self urlLabel] setTextColor:[ThemeManager labelColor]];
    [[self npiLabel] setTextColor:[ThemeManager labelColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)useDemoValues:(UIButton *)sender
{
    NetworkSettings *networkSettings = [[NetworkSettings alloc] initWithURLString:[URLManager defaultUrl] npi:[URLManager defaultNpi]];

    [[self urlTextBox] setText:[[networkSettings url] absoluteString]];
    [[self npiTextBox] setText:[networkSettings npi]];
    [[self view] endEditing:YES];
}

- (IBAction)saveSettings:(UIBarButtonItem *)sender
{
    // Assuming url is valid
    NetworkSettings *networkSettings = [[NetworkSettings alloc] initWithURLString:[[self urlTextBox] text] npi:[[self npiTextBox] text]];

    // Update
    [[URLManager sharedInstance] setUrl:[[networkSettings url] copy]];

    // Store
    [[NetworkSettingsStorage sharedIntance] save:networkSettings];
    [[self tableView] endEditing:YES];
    [self alertMessage:NSLocalizedString(@"NetworkSettings.Saved", nil)];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self view] endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
}
@end
