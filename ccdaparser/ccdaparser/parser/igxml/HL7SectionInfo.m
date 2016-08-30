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


#import "HL7SectionInfo_Private.h"

@implementation HL7SectionInfo

- (instancetype _Nonnull)initWithSectionParser:(id<HL7ElementSectionParserProtocol> _Nonnull)sectionParser
{
    if ((self = [super init])) {
        [self setTemplateId:[sectionParser templateId]];
        [self setName:[sectionParser name]];
        [self setEnabled:[sectionParser enabled]];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"name: %@ templateId: %@ enabled: %d", [self name], [self templateId], [self enabled]];
}


- (NSString *_Nullable)nameAsKey
{
    return [self.name stringByReplacingOccurrencesOfString:@" " withString:@""];
}

#pragma mark NSCopying
- (id)copyWithZone:(nullable NSZone *)zone
{
    HL7SectionInfo *clone = [[HL7SectionInfo allocWithZone:zone] init];
    [clone setTemplateId:[[self templateId] copyWithZone:zone]];
    [clone setName:[[self name] copyWithZone:zone]];
    [clone setEnabled:[self enabled]];
    return clone;
}

#pragma mark NSCoding
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        [self setTemplateId:[decoder decodeObjectForKey:@"templateId"]];
        [self setName:[decoder decodeObjectForKey:@"name"]];
        [self setEnabled:[decoder decodeBoolForKey:@"enabled"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:[self templateId] forKey:@"templateId"];
    [encoder encodeObject:[self name] forKey:@"name"];
    [encoder encodeBool:[self enabled] forKey:@"enabled"];
}
@end
