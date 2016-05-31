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


#import "HL7Code.h"
#import "HL7OriginalText.h"
#import "HL7Translation.h"
#import "HL7CodeSystem_Private.h"

@implementation HL7Code

- (_Nonnull instancetype)initWithCode:(HL7Code *_Nonnull)code
{
    if ((self = [super init])) {
        [self setCode:[[code code] copy]];
        [self setCodeSystem:[[code codeSystem] copy]];
        [self setCodeSystemName:[[code codeSystemName] copy]];
        [self setDisplayName:[[code displayName] copy]];
        [self setOriginalTextElement:[[code originalTextElement] copy]];
    }
    return self;
}

- (id)copyWithZone:(nullable NSZone *)zone
{
    HL7Code *clone = [super copyWithZone:zone];
    [clone setOriginalTextElement:[[self originalTextElement] copyWithZone:zone]];
    [clone setTranslations:[[NSMutableArray allocWithZone:zone] initWithArray:[self translations] copyItems:YES]];
    return clone;
}

- (NSMutableArray *)translations
{
    if (_translations == nil) {
        _translations = [[NSMutableArray alloc] initWithCapacity:2];
    }
    return _translations;
}

- (HL7Translation *)translation
{
    if (_translations == nil) {
        return nil;
    }
    return [_translations firstObject];
}

#pragma mark -
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder]) {
        [self setOriginalTextElement:[decoder decodeObjectForKey:@"originalText"]];
        [self setTranslations:[decoder decodeObjectForKey:@"translations"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeObject:[self originalTextElement] forKey:@"originalText"];
    [encoder encodeObject:[self translations] forKey:@"translations"];
}
@end
