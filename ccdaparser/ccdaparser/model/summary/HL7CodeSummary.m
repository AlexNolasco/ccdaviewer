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


#import "HL7CodeSummary.h"
#import "HL7CodeSummary_Private.h"
#import "HL7CodeSystem_Private.h"

@implementation HL7CodeSummary

- (instancetype _Nonnull)initWithValue:(HL7Value *_Nonnull)value
{
    return [super initWithCodeSystem:(HL7CodeSystem *)value];
}

- (instancetype _Nonnull)initWithCode:(HL7Code *_Nullable)code
{
    return [super initWithCodeSystem:(HL7CodeSystem *)code];
}

+ (instancetype _Nonnull)codeFromCode:(HL7Code *_Nullable)code
{
    HL7CodeSummary *result = [[HL7CodeSummary alloc] initWithCode:code];
    return result;
}

#pragma mark -
- (id)copyWithZone:(nullable NSZone *)zone
{
    HL7CodeSummary *clone = [super copyWithZone:zone];
    [clone setResolvedName:[[self resolvedName] copy]];
    return clone;
}

#pragma mark -
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder]) {
        [self setResolvedName:[decoder decodeObjectForKey:@"resolvedName"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    if ([self resolvedName] != nil) {
        [encoder encodeObject:[self resolvedName] forKey:@"resolvedName"];
    }
}
@end
