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


#import "HL7VitalSignsSummary_Private.h"
#import "HL7VitalSignsEntry.h"

@implementation HL7VitalSignsSummary

- (NSArray<HL7VitalSignsEntry *> *)allEntries
{
    return [self allEntriesSortedDescending];
}

- (NSArray<HL7VitalSignsEntry *> *)allEntriesSortedDescending
{
    NSArray *sortdesc = @[ [NSSortDescriptor sortDescriptorWithKey:@"organizerEffectiveTime" ascending:NO] ];
    return (NSArray<HL7VitalSignsEntry *> *)[_entries sortedArrayUsingDescriptors:sortdesc];
}

- (NSMutableArray<HL7VitalSignsSummaryEntry *> *)entries
{
    if (_entries == nil) {
        _entries = [[NSMutableArray alloc] initWithCapacity:6];
    }
    return _entries;
}

- (HL7VitalSignsSummaryEntry *)mostRecentEntry
{
    return [[self allEntries] firstObject];
}

#pragma mark -
- (id)copyWithZone:(nullable NSZone *)zone
{
    HL7VitalSignsSummary *clone = [super copyWithZone:zone];
    [clone setEntries:[[NSMutableArray allocWithZone:zone] initWithArray:[self entries] copyItems:YES]];
    return clone;
}

#pragma mark -
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder]) {
        [self setEntries:[decoder decodeObjectForKey:@"entries"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeObject:[self entries] forKey:@"entries"];
}
@end
