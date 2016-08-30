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


#import "HL7Author.h"
#import "HL7AssignedAuthor.h"
#import "HL7TemplateId.h"
#import "HL7Time.h"

@implementation HL7Author
- (HL7AssignedAuthor *)assignedAuthor
{
    if (_assignedAuthor == nil) {
        _assignedAuthor = [[HL7AssignedAuthor alloc] init];
    }
    return _assignedAuthor;
}

#pragma mark NSCopying
- (id)copyWithZone:(nullable NSZone *)zone
{
    HL7Author *clone = [[HL7Author allocWithZone:zone] init];
    [clone setTypeCode:[[self typeCode] copyWithZone:zone]];
    [clone setTemplateId:[[self templateId] copyWithZone:zone]];
    [clone setTime:[[self time] copyWithZone:zone]];
    [clone setAuthor:[[self author] copyWithZone:zone]];
    return clone;
}

#pragma mark NSCoding
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        [self setTypeCode:[decoder decodeObjectForKey:@"typeCode"]];
        [self setTemplateId:[decoder decodeObjectForKey:@"templateId"]];
        [self setTime:[decoder decodeObjectForKey:@"time"]];
        [self setAuthor:[decoder decodeObjectForKey:@"author"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:[self typeCode] forKey:@"typeCode"];
    [encoder encodeObject:[self templateId] forKey:@"templateId"];
    [encoder encodeObject:[self time] forKey:@"time"];
    [encoder encodeObject:[self author] forKey:@"author"];
}
@end
