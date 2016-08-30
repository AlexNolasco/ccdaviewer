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

#import "SectionDataSourceResults.h"
#import "NSDate+Formatting.h"

@interface SectionDataSourceResults ()
@property (nonatomic, weak) id<HL7SummaryProtocol> sectionSummary;
@property (nonatomic, strong) HL7SummaryEntryArray *entries;
@property (nonatomic, strong) NSDictionary<NSString *, HL7SummaryEntryMutableArray *> *sectionsToEntries;
@property (nonatomic, strong) NSArray<NSString *> *sortedKeys;
@end

@implementation SectionDataSourceResults
- (instancetype)initWithSummaryInfo:(id<HL7SummaryProtocol>)sectionSummary
{
    if ((self = [super init])) {
        _sectionSummary = sectionSummary;
    }
    return self;
}

- (id<HL7SummaryProtocol>)sectionSummary
{
    return _sectionSummary;
}

- (HL7SummaryEntryArray *)entries
{
    if (_entries == nil) {
        _entries = [self.sectionSummary allEntries];
    }
    return _entries;
}

- (NSDictionary<NSString *, HL7SummaryEntryMutableArray *> *)sectionsToEntries
{
    if (_sectionsToEntries == nil) {
        [self filterByText:nil];
    }
    return _sectionsToEntries;
}

- (HL7SummaryEntryMutableArray *)itemsAtKeyByIndex:(NSInteger)sectionIndex
{
    NSString *key = [self.sortedKeys objectAtIndex:sectionIndex];
    return [self.sectionsToEntries objectForKey:key];
}

- (HL7SummaryEntry *)entryAtIndexPath:(NSIndexPath *)indexPath
{
    HL7SummaryEntryMutableArray *array = [self itemsAtKeyByIndex:indexPath.section];
    return [array objectAtIndex:indexPath.row];
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return [[self itemsAtKeyByIndex:section] count];
}

- (NSInteger)numberOfSections
{
    return [self.sectionsToEntries count];
}

- (NSString *)titleForSection:(NSInteger)sectionIndex
{
    if ([self.sortedKeys count] == 1) {
        return nil;
    }
    return self.sortedKeys[sectionIndex];
}

- (BOOL)shouldLoadCustomHeader
{
    return [self numberOfSections] > 1;
}

- (CGFloat)heightForHeaderInSection:(NSInteger)section
{
    if ([self shouldLoadCustomHeader]) {
        return 80.0f;
    }
    return 0.01f;
}

#pragma mark SectionDataSourceSearchProtocol
- (void)filterByText:(NSString *)searchString
{
    const NSInteger itemCount = [self.entries count];

    NSMutableDictionary<NSString *, HL7SummaryEntryMutableArray *> *dictionary = [[NSMutableDictionary alloc] initWithCapacity:itemCount];

    NSMutableArray<NSDate *> *dates = [[NSMutableArray alloc] initWithCapacity:3];

    [self.entries enumerateObjectsUsingBlock:^(__kindof HL7ResultSummaryEntry *entry, NSUInteger idx, BOOL *stop) {
        HL7SummaryEntryMutableArray *arrayOfEntries;
        NSString *key;

        if (entry.date) {
            key = [entry.date toLongDateString];
        } else {
            key = NSLocalizedString(@"SummaryResults.NoDate", nil);
        }

        if (![dictionary objectForKey:key]) {
            [dates addObject:entry.date];
            arrayOfEntries = [HL7SummaryEntryMutableArray new];
            [dictionary setObject:arrayOfEntries forKey:key];
        } else {
            arrayOfEntries = [dictionary objectForKey:key];
        }

        if (![searchString length] || [entry.narrative rangeOfString:searchString options:NSCaseInsensitiveSearch].location != NSNotFound) {
            [arrayOfEntries addObject:entry];
        }
    }];

    NSArray *sortedDates = [dates sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = a;
        NSDate *second = b;
        return [first compare:second];
    }];

    NSMutableArray<NSString *> *sortedStringDates = [[NSMutableArray alloc] initWithCapacity:[sortedDates count]];

    [sortedDates enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [sortedStringDates addObject:[obj toLongDateString]];
    }];

    _sortedKeys = [[sortedStringDates reverseObjectEnumerator] allObjects];
    _sectionsToEntries = [dictionary copy];
}

- (void)resetFilter
{
    [self filterByText:nil];
}

- (BOOL)allowSearch
{
    return [self shouldLoadCustomHeader];
}
@end
