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


#import "SectionDataSourceGeneric.h"

@interface SectionDataSourceGeneric ()
@property (nonatomic, weak) id<HL7SummaryProtocol> sectionSummary;
@property (nonatomic, strong) HL7SummaryEntryArray *entries;
@end

@implementation SectionDataSourceGeneric
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

- (HL7SummaryEntry *_Nonnull)entryAtIndexPath:(NSIndexPath *_Nonnull)indexPath
{
    return [self.entries objectAtIndex:indexPath.row];
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return [self.entries count];
}

- (NSInteger)numberOfSections
{
    return 1;
}

- (NSString *)titleForSection:(NSInteger)section
{
    return nil;
}

- (BOOL)shouldLoadCustomHeader
{
    return NO;
}

- (CGFloat)heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}
@end
