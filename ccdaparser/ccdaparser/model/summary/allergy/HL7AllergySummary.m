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


#import "HL7AllergySummary.h"
#import "HL7AllergySummaryEntry.h"
#import "HL7AllergySummary_Private.h"

@implementation HL7AllergySummary
- (NSMutableArray<HL7AllergySummaryEntry *> *)entries
{
    if (_entries == nil) {
        _entries = [[NSMutableArray alloc] initWithCapacity:2];
    }
    return _entries;
}

- (NSArray<HL7AllergySummaryEntry *> *)allEntries
{
    return [[self entries] copy];
}

- (BOOL)isEmpty
{
    return NO;
}

#pragma mark -
- (id)copyWithZone:(nullable NSZone *)zone
{
    HL7AllergySummary *clone = [super copyWithZone:zone];
    [clone setNoKnownAllergiesFound:[self noKnownAllergiesFound]];
    [clone setNoKnownMedicationAllergiesFound:[self noKnownMedicationAllergiesFound]];
    [clone setEntries:[[NSMutableArray allocWithZone:zone] initWithArray:[self entries] copyItems:YES]];
    return clone;
}

#pragma mark -
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder]) {
        self.noKnownAllergiesFound = [decoder decodeBoolForKey:@"noKnownAllergiesFound"];
        self.noKnownMedicationAllergiesFound = [decoder decodeBoolForKey:@"noKnownMedicationAllergiesFound"];
        self.entries = [decoder decodeObjectForKey:@"entries"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeBool:[self noKnownAllergiesFound] forKey:@"noKnownAllergiesFound"];
    [encoder encodeBool:[self noKnownMedicationAllergiesFound] forKey:@"noKnownMedicationAllergiesFound"];
    [encoder encodeObject:[self entries] forKey:@"entries"];
}

@end
