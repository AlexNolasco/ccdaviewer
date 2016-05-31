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


#import "HL7SocialHistorySummaryEntry.h"
#import "HL7SocialHistorySummaryEntry_Private.h"
#import "HL7SocialHistoryObservation.h"
#import "HL7Value.h"
#import "HL7Text.h"
#import "HL7DateRange_Private.h"
#import "HL7CodeSummary.h"

@implementation HL7SocialHistorySummaryEntry

- (HL7DateRange *)dateRange
{
    return _dateRange;
}

- (HL7CodeSummary *)codeSummary
{
    return _codeSummary;
}

- (HL7XSIType)dataType
{
    return _dataType;
}

- (NSString *)templateId
{
    return _templateId;
}

//- (NSString *) narrative
//{
//    return [[self codeSummary] displayName];
//}

#pragma mark -
- (id)copyWithZone:(nullable NSZone *)zone
{
    HL7SocialHistorySummaryEntry *clone = [[HL7SocialHistorySummaryEntry allocWithZone:zone] init];
    [clone setDateRange:[[self dateRange] copy]];
    [clone setCodeSummary:[[self codeSummary] copy]];
    [clone setQuantityNarrative:[[self quantityNarrative] copy]];
    [clone setDataType:[self dataType]];
    [clone setTemplateId:[self templateId]];
    return clone;
}

#pragma mark -
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder]) {
        [self setDateRange:[decoder decodeObjectForKey:@"dateRange"]];
        [self setCodeSummary:[decoder decodeObjectForKey:@"codeSummary"]];
        [self setDataType:[decoder decodeIntegerForKey:@"dataType"]];
        [self setQuantityNarrative:[decoder decodeObjectForKey:@"quantityNarrative"]];
        [self setTemplateId:[decoder decodeObjectForKey:@"templateId"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeObject:[self dateRange] forKey:@"dateRange"];
    [encoder encodeObject:[self codeSummary] forKey:@"codeSummary"];
    [encoder encodeInteger:[self dataType] forKey:@"dataType"];
    [encoder encodeObject:[self quantityNarrative] forKey:@"quantityNarrative"];
    [encoder encodeObject:[self templateId] forKey:@"templateId"];
}

@end
