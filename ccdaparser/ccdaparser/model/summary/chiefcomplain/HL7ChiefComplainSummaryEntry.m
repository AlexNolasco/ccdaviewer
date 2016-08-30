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


#import "HL7ChiefComplainSummaryEntry_Private.h"
#import "HL7Text.h"
#import "HL7Text+Additions.h"
#import "HL7ChiefComplainSection.h"
#import "HL7CodeSummary_Private.h"
#import "HL7CodeSystem_Private.h"

@implementation HL7ChiefComplainSummaryEntry
- (instancetype _Nonnull)initWithChiefComplainSection:(HL7ChiefComplainSection *_Nonnull)section
{
    if ((self = [super init])) {
        [self setCode:[[HL7CodeSummary alloc] initWithCodeSystem:(HL7CodeSystem *)[section code]]];

        [self setReasonPlainText:section.text.text];
        [self setReasonHtml:[section.text toHtml]];
    }
    return self;
}

- (HL7CodeSummary *_Nullable)code
{
    return _code;
}
- (NSString *)reasonPlainText
{
    return _reasonPlainText;
}

- (NSString *)reasonHtml
{
    return _reasonHtml;
}

- (NSString *)narrative
{
    return [self reasonPlainText];
}

#pragma mark -
- (id)copyWithZone:(nullable NSZone *)zone
{
    HL7ChiefComplainSummaryEntry *clone = [[HL7ChiefComplainSummaryEntry allocWithZone:zone] init];
    [clone setReasonHtml:[[self reasonHtml] copy]];
    [clone setReasonPlainText:[[self reasonPlainText] copy]];
    [clone setCode:[[self code] copy]];
    return clone;
}

#pragma mark -
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder]) {
        [self setReasonPlainText:[decoder decodeObjectForKey:@"reasonPlainText"]];
        [self setReasonHtml:[decoder decodeObjectForKey:@"reasonHtml"]];
        [self setCode:[decoder decodeObjectForKey:@"code"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeObject:[self reasonPlainText] forKey:@"reasonPlainText"];
    [encoder encodeObject:[self reasonHtml] forKey:@"reasonHtml"];
    [encoder encodeObject:[self code] forKey:@"code"];
}

@end
