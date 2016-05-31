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


#import "HL7Observation.h"
#import "HL7Const.h"
#import "HL7Text.h"
#import "HL7Value.h"
#import "HL7StatusCode.h"
#import "HL7EffectiveTime.h"
#import "ObjectiveSugar.h"

@implementation HL7Observation

- (BOOL)hasNegationInd
{
    return [[self negationInd] length];
}

- (BOOL)isNegationIndTrue
{
    if (![self hasNegationInd]) {
        return NO;
    }
    return [[self negationInd] isEqualToString:HL7ValueTrue];
}

- (NSString *_Nullable)getTextFromDisplayName:(NSString *_Nullable)displayName orSectionText:(HL7Text *_Nullable)sectionText
{
    NSString *result;
    if ([displayName length]) {
        result = [displayName copy];
    } else if (result == nil && [[[self text] firstReference] length]) {
        result = [[[sectionText getIdentifierValueById:[[self text] firstReference]] copy] strip];
    }
    return result;
}

#pragma mark -
- (id)copyWithZone:(nullable NSZone *)zone
{
    HL7Observation *clone = [super copyWithZone:zone];
    [clone setNullFlavor:[[self nullFlavor] copy]];
    [clone setNegationInd:[[self negationInd] copy]];
    [clone setValue:[[self value] copy]];
    [clone setText:[[self text] copy]];
    [clone setStatusCode:[[self statusCode] copy]];
    [clone setEffectiveTime:[[self effectiveTime] copy]];
    return clone;
}

#pragma mark -
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder]) {
        [self setNullFlavor:[[self nullFlavor] copy]];
        [self setNegationInd:[[self negationInd] copy]];
        [self setValue:[[self value] copy]];
        [self setText:[[self text] copy]];
        [self setStatusCode:[[self statusCode] copy]];
        [self setEffectiveTime:[[self effectiveTime] copy]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeObject:[self nullFlavor] forKey:@"nullFlavor"];
    [encoder encodeObject:[self negationInd] forKey:@"negationInd"];
    [encoder encodeObject:[self value] forKey:@"value"];
    [encoder encodeObject:[self text] forKey:@"text"];
    [encoder encodeObject:[self statusCode] forKey:@"statusCode"];
    [encoder encodeObject:[self effectiveTime] forKey:@"effectiveTime"];
}
@end
