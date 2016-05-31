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
#import "HL7CodeSystem.h"
#import "HL7SocialHistoryObservation.h"
#import "HL7SocialHistorySummary.h"
#import "HL7SocialHistorySummary_Private.h"
#import "HL7SocialHistorySummaryEntry.h"
#import "HL7Const.h"

@implementation HL7SocialHistorySummary

- (HL7CodeSummary *_Nullable)code
{
    return [[self codeSummary] copy];
}

- (HL7CodeSummary *_Nullable)smokingStatusCode
{
    for (HL7SocialHistorySummaryEntry *summaryEntry in [self entries]) {
        if ([[summaryEntry templateId] isEqualToString:HL7TemplateSocialHistoryObservationSmokingStatus]) {
            return [summaryEntry codeSummary];
        }
    }
    return nil;
}

- (NSArray<HL7SocialHistorySummaryEntry *> *_Nonnull)allEntries
{
    return [[self entries] copy];
}

- (NSMutableArray<HL7SocialHistorySummaryEntry *> *)entries
{
    if (_entries == nil) {
        _entries = [[NSMutableArray alloc] initWithCapacity:2];
    }
    return _entries;
}

#pragma mark -
- (id)copyWithZone:(nullable NSZone *)zone
{
    HL7SocialHistorySummary *clone = [super copyWithZone:zone];
    [clone setCodeSummary:[[self codeSummary] copy]];
    [clone setEntries:[[self entries] copy]];
    return clone;
}

#pragma mark -
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder]) {
        [self setCodeSummary:[decoder decodeObjectForKey:@"codeSummary"]];
        [self setEntries:[decoder decodeObjectForKey:@"entries"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeObject:[self codeSummary] forKey:@"codeSummary"];
    [encoder encodeObject:[self entries] forKey:@"entries"];
}
@end
