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


#import "SectionController.h"
#import "SectionViewContext.h"
#import "SectionDataSourceSearchProtocol.h"

static NSString *kSectionControllerDataSourcePrefix = @"SectionDataSource";
static NSString *kSectionControllerDataSourceGeneric = @"Generic";

@interface SectionController ()
@property (nonatomic, weak) SectionViewContext *sectionViewContext;
@property (nonatomic, strong) id<SectionDataSourceProtocol> dataSource;
@end

@implementation SectionController
- (instancetype)initWithSectionViewContext:(SectionViewContext *)sectionViewContext
{
    if ((self = [super init])) {
        _sectionViewContext = sectionViewContext;
        _dataSource = [self createDataSourceInstanceForSection:sectionViewContext];
    }
    return self;
}

- (NSString *)genericDataSource
{
    return [NSString stringWithFormat:@"%@%@", kSectionControllerDataSourcePrefix, kSectionControllerDataSourceGeneric];
}

- (NSString *)dataSourceForSectionKeyName:(NSString *)sectionKeyName
{
    return [NSString stringWithFormat:@"%@%@", kSectionControllerDataSourcePrefix, sectionKeyName];
}

- (id<SectionDataSourceProtocol>)createDataSourceInstanceForSection:(SectionViewContext *)context
{
    NSString *className = [self dataSourceForSectionKeyName:context.sectionInfo.nameAsKey];
    Class dataSourceClass = NSClassFromString(className);

    if (!dataSourceClass) {
        className = [self genericDataSource];
    }

    dataSourceClass = NSClassFromString(className);
    return [[dataSourceClass alloc] initWithSummaryInfo:context.sectionSummary];
}

- (NSString *)cellNameForSectionKey:(NSString *)sectionKey
{
    NSString *cellName = [NSString stringWithFormat:@"Viewer%@Cell", sectionKey];

    if (![[NSBundle mainBundle] pathForResource:cellName ofType:@"nib"]) { // maybe as a name
        cellName = [NSString stringWithFormat:@"Viewer%@Cell", @"Generic"];
    }
    return cellName;
}

- (NSString *)headerNameForSectionKey:(NSString *)sectionKey
{
    if (![[self dataSource] shouldLoadCustomHeader]) {
        return nil;
    }
    NSString *headerCellName = [NSString stringWithFormat:@"Viewer%@Header", sectionKey];

    // Header
    if ([[NSBundle mainBundle] pathForResource:headerCellName ofType:@"nib"]) {
        return headerCellName;
    }
    return nil;
}

#pragma mark DataSource
- (id<SectionDataSourceProtocol>)dataSource
{
    return _dataSource;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource numberOfRowsInSection:section];
}

- (HL7SummaryEntry *)entryAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.dataSource entryAtIndexPath:indexPath];
}

- (NSInteger)numberOfSections
{
    return [self.dataSource numberOfSections];
}

- (NSString *)titleForSection:(NSInteger)section
{
    return [self.dataSource titleForSection:section];
}

- (CGFloat)heightForHeaderInSection:(NSInteger)section
{
    return [self.dataSource heightForHeaderInSection:section];
}

- (BOOL)allowSearch
{
    if (![self.dataSource conformsToProtocol:@protocol(SectionDataSourceSearchProtocol)]) {
        return NO;
    }
    return [((id<SectionDataSourceSearchProtocol>)self.dataSource)allowSearch];
}

- (void)filterByText:(NSString *)text
{
    [((id<SectionDataSourceSearchProtocol>)self.dataSource) filterByText:text];
}
@end
