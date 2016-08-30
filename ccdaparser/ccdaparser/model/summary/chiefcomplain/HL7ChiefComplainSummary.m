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


#import "HL7ChiefComplainSummary.h"
#import "HL7ChiefComplainSummary_Private.h"
#import "HL7ChiefComplainSummaryEntry_Private.h"
#import "HL7Summary_Private.h"
#import "HL7CodeSummary.h"
#import "HL7CodeSystem_Private.h"
#import "HL7ChiefComplainSection.h"
#import "HL7Text.h"
#import "HL7Text+Additions.h"

@implementation HL7ChiefComplainSummary

- (instancetype)initWithChiefComplainSection:(HL7ChiefComplainSection *)section
{
    if ((self = [super initWithElement:section])) {
        if (section != nil) {
            [[self entries] addObject:[[HL7ChiefComplainSummaryEntry alloc] initWithChiefComplainSection:section]];
        }
    }
    return self;
}

- (NSArray<HL7ChiefComplainSummaryEntry *> *_Nonnull)allEntries
{
    return [[self entries] copy];
}

- (NSMutableArray<HL7ChiefComplainSummaryEntry *> *)entries
{
    if (_entries == nil) {
        _entries = [[NSMutableArray alloc] initWithCapacity:2];
    }
    return _entries;
}

#pragma mark NSCopying
- (id)copyWithZone:(nullable NSZone *)zone
{
    HL7ChiefComplainSummary *clone = [super copyWithZone:zone];
    [clone setEntries:[[self entries] copy]];

    return clone;
}

#pragma mark NSCoding
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
