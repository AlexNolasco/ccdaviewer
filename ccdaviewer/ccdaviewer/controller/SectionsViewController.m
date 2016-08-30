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


#import "SectionsViewController.h"
#import "SectionViewCell.h"
#import "SectionStorage.h"
#import "UIViewController+RegisterCell.h"

static NSString *ccdaSectionNibCellName = @"SectionCell";

@interface SectionsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (nonatomic, strong) HL7SectionInfoMutableArray *ccdaSections;
@end

@implementation SectionsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // navigation button
    [[self navigationItem] setRightBarButtonItem:[self editButtonItem]];
    [[[self navigationItem] rightBarButtonItem] setTarget:self];

    [[[self navigationItem] rightBarButtonItem] setAction:@selector(startEditing:)];
    [[self navigationItem] setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Toggle" style:UIBarButtonItemStylePlain target:self action:@selector(toggleButtonTapped:)]];
    [self setTitle:NSLocalizedString(@"Sections.Title", nil)];

    // register cells
    [self registerCellWithNibName:ccdaSectionNibCellName forTableView:[self table]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)toggleButtonTapped:(id)sender
{
    for (HL7SectionInfo *sectionInfo in [self ccdaSections]) {
        [sectionInfo setEnabled:![sectionInfo enabled]];
    }
    [[SectionStorage sharedIntance] save:[self ccdaSections]];
    [[self table] reloadData];
}

#pragma mark -
- (HL7SectionInfoMutableArray *)ccdaSections
{
    if (_ccdaSections == nil) {
        _ccdaSections = [[HL7SectionInfoMutableArray alloc] initWithArray:[[SectionStorage sharedIntance] sections]];
    }
    return _ccdaSections;
}

- (IBAction)startEditing:(id)sender
{
    if ([[self table] isEditing]) {
        [[SectionStorage sharedIntance] save:[self ccdaSections]];
        [[[self navigationItem] rightBarButtonItem] setTitle:NSLocalizedString(@"Common.Edit", nil)];
    } else {
        [[[self navigationItem] rightBarButtonItem] setTitle:NSLocalizedString(@"Common.Save", nil)];
    }

    [[self table] setEditing:![[self table] isEditing] animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [[self ccdaSections] count];
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SectionViewCell *sectionCell;
    switch (indexPath.section) {
        case 0:
            sectionCell = [tableView dequeueReusableCellWithIdentifier:ccdaSectionNibCellName];
            sectionCell.tag = indexPath.row;
            sectionCell.delegate = self;
            return sectionCell;
        default:
            return nil;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(SectionViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        HL7SectionInfo *sectionInfo = [[self ccdaSections] objectAtIndex:indexPath.row];
        cell.nameLabel.text = sectionInfo.name;
        cell.enabled = sectionInfo.enabled;
    }
}

#pragma mark - moving sections

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return YES;
    }
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    HL7SectionInfoMutableArray *sections = [self ccdaSections];

    HL7SectionInfo *section = [sections objectAtIndex:[sourceIndexPath row]];
    NSInteger row = [sourceIndexPath row];

    [sections removeObjectAtIndex:row];
    [sections insertObject:section atIndex:destinationIndexPath.row];
}

#pragma mark - SectionViewCellDelegate
- (void)didToggleSectionViewCell:(BOOL)newValue tag:(NSInteger)tag
{
    HL7SectionInfo *sectionInfo = [[self ccdaSections] objectAtIndex:tag];
    sectionInfo.enabled = newValue;
    [[SectionStorage sharedIntance] save:[self ccdaSections]];
}
@end
