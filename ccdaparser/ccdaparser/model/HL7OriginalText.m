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


#import "HL7OriginalText.h"
#import "HL7Text.h"

@implementation HL7OriginalText
- (instancetype _Nonnull)initWithReferenceValue:(NSString *)referenceValue
{
    if ((self = [super init])) {
        [self setReferenceValue:[referenceValue copy]];
    }
    return self;
}

- (id)copyWithZone:(nullable NSZone *)zone
{
    HL7OriginalText *clone = [[HL7OriginalText allocWithZone:zone] initWithReferenceValue:[self referenceValue]];
    [clone setText:[[self text] copy]];
    [clone setReferenceValue:[[self referenceValue] copy]];
    return clone;
}

- (BOOL)hasReferenceId
{
    if (![[self referenceValue] length]) {
        return NO;
    }
    if ([[self referenceValue] hasPrefix:@"#"] && [[self referenceValue] length] > 1) {
        return YES;
    }
    return NO;
}

- (nullable NSString *)referenceValueWithoutHash
{
    if (![self hasReferenceId]) {
        return nil;
    }
    return [[self referenceValue] substringFromIndex:1];
}

- (nullable NSString *)getActualValueFromTextElement:(nullable HL7Text *)textElement
{
    if (!textElement || ![self hasReferenceId]) {
        return nil;
    }
    return [textElement getIdentifierValueById:[self referenceValueWithoutHash]];
}

#pragma mark -
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        [self setReferenceValue:[decoder decodeObjectForKey:@"referenceValue"]];
        [self setText:[decoder decodeObjectForKey:@"text"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:[self referenceValue] forKey:@"referenceValue"];
    [encoder encodeObject:[self text] forKey:@"text"];
}
@end
