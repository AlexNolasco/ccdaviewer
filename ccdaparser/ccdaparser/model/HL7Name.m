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


#import "HL7Name_Private.h"
#import "HL7NamePart_Private.h"


@implementation HL7Name
- (nonnull instancetype)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName
{
    if ((self = [super init])) {
        HL7NamePart *family = [[HL7NamePart alloc] initWithText:lastName];
        HL7NamePart *given = [[HL7NamePart alloc] initWithText:firstName];

        [[self given] addObject:given];
        [[self family] addObject:family];
    }
    return self;
}

- (NSString *)first
{
    if (![[self given] count]) {
        return nil;
    }
    return [[[self given] firstObject] text];
}

- (NSString *)last
{
    if (![[self family] count]) {
        return nil;
    }
    HL7NamePart *namePart = [[self family] firstObject];

    if ([[namePart text] length]) {
        return [[namePart text] copy];
    } else {
        return nil;
    }
}

- (NSMutableArray<HL7NamePart *> *)family
{
    if (_family == nil) {
        _family = [[NSMutableArray alloc] init];
    }
    return _family;
}

- (NSMutableArray<HL7NamePart *> *)given
{
    if (_given == nil) {
        _given = [[NSMutableArray alloc] init];
    }
    return _given;
}

- (NSString *)description
{
    NSMutableString *result = [[NSMutableString alloc] initWithCapacity:20];
    if ([[self prefix] length]) {
        [result appendString:[self prefix]];
    }

    if ([result length]) {
        [result appendString:@" "];
    }

    if ([[self first] length]) {
        [result appendString:[self first]];
    }

    if ([result length]) {
        [result appendString:@" "];
    }

    if ([[self last] length]) {
        [result appendString:[self last]];
    }

    return [result copy];
}

#pragma mark -

- (id)copyWithZone:(nullable NSZone *)zone
{
    HL7Name *clone = [[HL7Name allocWithZone:zone] init];
    [clone setTitle:[[self title] copyWithZone:zone]];
    [clone setPrefix:[[self prefix] copyWithZone:zone]];
    [clone setSuffix:[[self suffix] copyWithZone:zone]];
    [clone setName:[[self name] copyWithZone:zone]];
    [clone setUse:[[self use] copyWithZone:zone]];
    [clone setGiven:[[NSMutableArray allocWithZone:zone] initWithArray:[self given] copyItems:YES]];
    [clone setFamily:[[NSMutableArray allocWithZone:zone] initWithArray:[self family] copyItems:YES]];
    return clone;
}

#pragma mark -
- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init])) {
        [self setTitle:[decoder decodeObjectForKey:@"title"]];
        [self setPrefix:[decoder decodeObjectForKey:@"prefix"]];
        [self setSuffix:[decoder decodeObjectForKey:@"suffix"]];
        [self setName:[decoder decodeObjectForKey:@"name"]];
        [self setUse:[decoder decodeObjectForKey:@"use"]];
        [self setGiven:[decoder decodeObjectForKey:@"given"]];
        [self setFamily:[decoder decodeObjectForKey:@"family"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:[self title] forKey:@"title"];
    [encoder encodeObject:[self prefix] forKey:@"prefix"];
    [encoder encodeObject:[self suffix] forKey:@"suffix"];
    [encoder encodeObject:[self name] forKey:@"name"];
    [encoder encodeObject:[self use] forKey:@"use"];
    [encoder encodeObject:[self given] forKey:@"given"];
    [encoder encodeObject:[self family] forKey:@"family"];
}
@end
