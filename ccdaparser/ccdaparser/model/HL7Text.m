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


#import "HL7Text.h"

@implementation HL7Text
- (NSMutableString *)text
{
    if (_text == nil) {
        _text = [[NSMutableString alloc] initWithCapacity:512];
    }
    return _text;
}

- (NSMutableString *)innerXML
{
    if (_innerXML == nil) {
        _innerXML = [[NSMutableString alloc] initWithCapacity:512];
    }
    return _innerXML;
}

- (NSMutableDictionary *)identifiers
{
    if (_identifiers == nil) {
        _identifiers = [[NSMutableDictionary alloc] initWithCapacity:32];
    }
    return _identifiers;
}

- (NSMutableArray<NSString *> *)references
{
    if (_references == nil) {
        _references = [[NSMutableArray alloc] initWithCapacity:2];
    }
    return _references;
}

/** E.g. <td ID="Goal2_desc">Asthma management</td> */
- (void)addValue:(nonnull NSString *)value forIdentifier:(nonnull NSString *)key
{
    if ([key length] && [value length]) {
        [[self identifiers] setObject:value forKey:key];
    }
}

- (void)addReferenceWithValue:(NSString *_Nullable)value
{
    if (![value length]) {
        return;
    }
    [[self references] addObject:value];
}

- (NSString *_Nullable)getIdentifierValueById:(NSString *_Nonnull)identifier
{

    NSString *key;
    if ([identifier hasPrefix:@"#"]) {
        key = [identifier substringFromIndex:1];
    } else {
        key = identifier;
    }
    return [[[self identifiers] objectForKey:key] copy];
}

- (NSString *_Nullable)firstReference
{
    if (![[self references] count]) {
        return nil;
    }
    return [[[self references] firstObject] copy];
}

#pragma mark -
- (id)copyWithZone:(nullable NSZone *)zone
{
    HL7Text *clone = [[self class] allocWithZone:zone];
    [clone setText:[[self text] copy]];
    [clone setIdentifiers:[[NSMutableDictionary allocWithZone:zone] initWithDictionary:[self identifiers] copyItems:YES]];
    [clone setReferences:[[NSMutableArray allocWithZone:zone] initWithArray:[self references] copyItems:YES]];
    [clone setMediaType:[[self mediaType] copyWithZone:zone]];
    [clone setIsHtml:[self isHtml]];
    [clone setInnerXML:[[self innerXML] copyWithZone:zone]];
    return clone;
}

#pragma mark -
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        [self setText:[decoder decodeObjectForKey:@"text"]];
        [self setIdentifiers:[decoder decodeObjectForKey:@"identifiers"]];
        [self setReferences:[decoder decodeObjectForKey:@"references"]];
        [self setMediaType:[decoder decodeObjectForKey:@"mediaType"]];
        [self setInnerXML:[decoder decodeObjectForKey:@"innerXML"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:[self text] forKey:@"text"];
    [encoder encodeObject:[self identifiers] forKey:@"identifiers"];
    [encoder encodeObject:[self references] forKey:@"references"];
    [encoder encodeObject:[self mediaType] forKey:@"mediaType"];
    [encoder encodeObject:[self innerXML] forKey:@"innerXML"];
}
@end
