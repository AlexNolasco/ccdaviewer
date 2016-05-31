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

@implementation HL7Summary

- (instancetype _Nonnull)initWithElement:(HL7TemplateElement *_Nullable)element
{
    if ((self = [super init])) {
        if (element != nil) {
            [self setSectionTitle:[[element title] copy]];
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

#pragma mark -
- (id)copyWithZone:(nullable NSZone *)zone
{
    HL7Summary *clone = [[HL7Summary allocWithZone:zone] init];
    [clone setSectionTitle:[[self sectionTitle] copy]];
    return clone;
}

#pragma mark -
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        [self setSectionTitle:[decoder decodeObjectForKey:@"sectionTitle"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    if ([self sectionTitle] != nil) {
        [encoder encodeObject:[self sectionTitle] forKey:@"sectionTitle"];
    }
}
@end
