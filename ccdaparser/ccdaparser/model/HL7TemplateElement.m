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


#import "HL7TemplateElement.h"
#import "HL7TemplateId.h"
#import "HL7Code.h"
#import "HL7Identifier.h"

@implementation HL7TemplateElement

- (NSMutableArray<HL7TemplateId *> *)templateIds
{
    if (_templateIds == nil) {
        _templateIds = [[NSMutableArray alloc] initWithCapacity:2];
    }
    return _templateIds;
}

- (BOOL)hasTemplateId:(NSString *)templateIdentifier
{
    for (HL7TemplateId *templateId in [self templateIds]) {
        if ([[templateId root] isEqualToString:templateIdentifier]) {
            return YES;
        }
    }
    return NO;
}

- (NSString *)firstTemplateId
{
    if (![[self templateIds] count]) {
        return nil;
    }

    HL7Identifier *identifier = [[self templateIds] firstObject];
    return [[identifier root] copy];
}


#pragma mark NSCopying
- (id)copyWithZone:(nullable NSZone *)zone
{
    HL7TemplateElement *clone = [[self class] allocWithZone:zone];
    [clone setTitle:[[self title] copy]];
    [clone setCode:[[self code] copyWithZone:zone]];
    [clone setIdentifier:[[self identifier] copyWithZone:zone]];
    [clone setTemplateIds:[[NSMutableArray allocWithZone:zone] initWithArray:[self templateIds] copyItems:YES]];
    [clone setMoodCode:[[self moodCode] copy]];
    [clone setClassCode:[[self classCode] copy]];
    return clone;
}

#pragma mark NSCoding
- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init])) {
        [self setTitle:[decoder decodeObjectForKey:@"title"]];
        [self setCode:[decoder decodeObjectForKey:@"code"]];
        [self setIdentifier:[decoder decodeObjectForKey:@"identifier"]];
        [self setStatusCode:[decoder decodeObjectForKey:@"statusCode"]];
        [self setEffectiveTime:[decoder decodeObjectForKey:@"effectiveTime"]];
        [self setTemplateIds:[decoder decodeObjectForKey:@"templateIds"]];
        [self setMoodCode:[decoder decodeObjectForKey:@"moodCode"]];
        [self setClassCode:[decoder decodeObjectForKey:@"classCode"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:[self title] forKey:@"title"];
    [encoder encodeObject:[self code] forKey:@"code"];
    [encoder encodeObject:[self identifier] forKey:@"identifier"];
    [encoder encodeObject:[self statusCode] forKey:@"statusCode"];
    [encoder encodeObject:[self effectiveTime] forKey:@"effectiveTime"];
    [encoder encodeObject:[self templateIds] forKey:@"templateIds"];
    [encoder encodeObject:[self classCode] forKey:@"classCode"];
    [encoder encodeObject:[self moodCode] forKey:@"moodCode"];
}
@end
