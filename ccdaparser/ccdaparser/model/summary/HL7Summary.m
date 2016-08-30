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


#import "HL7Summary_Private.h"
#import "HL7TemplateElement.h"
#import "HL7SummaryEntry.h"

@implementation HL7Summary

- (instancetype _Nonnull)initWithElement:(HL7TemplateElement *_Nullable)element
{
    if ((self = [super init])) {
        if ([[element title] length]) {
            [self setTitle:[element title]];
        }

        if ([[element firstTemplateId] length]) {
            [self setTemplateId:[element firstTemplateId]];
        }
    }
    return self;
}

- (NSArray<__kindof HL7SummaryEntry *> *_Nonnull)allEntries
{
    return [NSArray new];
}

- (BOOL)isEmpty
{
    return [[self allEntries] count] == 0;
}

#pragma mark HL7SummaryProtocol
- (HL7SummaryEntryArray *_Nullable)searchByString:(NSString *_Nullable)text
{
    // default implementation
    HL7SummaryEntryMutableArray *result = [[HL7SummaryEntryMutableArray alloc] initWithCapacity:2];
    [[self allEntries] enumerateObjectsUsingBlock:^(__kindof HL7SummaryEntry *entry, NSUInteger idx, BOOL *stop) {
        NSRange range = [[entry narrative] rangeOfString:text options:NSCaseInsensitiveSearch];
        if ([[entry narrative] length] && range.location != NSNotFound) {
            [result addObject:entry];
        }
    }];
    return [result copy];
}

#pragma mark NSCopying
- (id)copyWithZone:(nullable NSZone *)zone
{
    HL7Summary *clone = [[HL7Summary allocWithZone:zone] init];
    [clone setTitle:[self title]];
    return clone;
}

#pragma mark NSCoding
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        [self setTitle:[decoder decodeObjectForKey:@"sectionTitle"]];
        [self setTemplateId:[decoder decodeObjectForKey:@"templateId"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    if ([[self title] length]) {
        [encoder encodeObject:[self title] forKey:@"sectionTitle"];
        [encoder encodeObject:[self title] forKey:@"templateId"];
    }
}
@end
