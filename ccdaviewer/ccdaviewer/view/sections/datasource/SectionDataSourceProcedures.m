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

#import "SectionDataSourceProcedures.h"

@interface SectionDataSourceProcedures()
@property (nonatomic, weak) id<HL7SummaryProtocol> sectionSummary;
@property (nonatomic, strong) HL7SummaryEntryArray *entries;
@end

@implementation SectionDataSourceProcedures
- (instancetype)initWithSummaryInfo:(id<HL7SummaryProtocol>)sectionSummary
{
    if ((self = [super init])) {
        _sectionSummary = sectionSummary;
    }
    return self;
}

- (HL7SummaryEntryArray *)entries
{
    if (_entries == nil) {
        NSMutableArray * entries = [[NSMutableArray alloc] initWithCapacity:5];
        
        [[self.sectionSummary allEntries] enumerateObjectsUsingBlock:^(__kindof HL7ProcedureSummaryEntry
         * _Nonnull procedureSummary, NSUInteger idx, BOOL * _Nonnull stop) {
            [entries addObject:procedureSummary];
        }];
        
        _entries = [[[entries sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            HL7ProcedureSummaryEntry * first = obj1;
            HL7ProcedureSummaryEntry * second = obj2;
            return [first.date compare:second.date];
        }] reverseObjectEnumerator] allObjects];
    }
    return _entries;
}
@end
