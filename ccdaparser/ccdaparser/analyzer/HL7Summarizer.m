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


#import "HL7Summarizer.h"
#import "NSArray+Subclasses.h"
#import "HL7SectionSummaryProtocol.h"
#import "HL7Analyzer.h"
#import "HL7CCDSummary_Private.h"
#import "HL7PatientRoleAnalyzer.h"
#import "HL7SummaryInfo.h"
#import "HL7CCDSummary_Private.h"

@implementation HL7Summarizer

- (nonnull NSMutableDictionary *)getAllAnalyzers
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithCapacity:10];

    for (Class classInfo in [NSArray classGetSubclasses:[HL7Analyzer class]]) {
        id<HL7SectionSummaryProtocol> summaryClass = [classInfo new];
        if ([[summaryClass templateId] length] > 0) {
            [result setObject:summaryClass forKey:[summaryClass templateId]];
        }
    }
    return result;
}

/** templateId => HL7Summary */
- (NSDictionary<NSString *, NSString *> *_Nonnull)getDictionaryOfSummaryImplementations;
{
    NSMutableDictionary *analyzers = [self getAllAnalyzers];
    NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithCapacity:[analyzers count]];

    [analyzers enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL *_Nonnull stop) {
        [result setObject:[((id<HL7SectionSummaryProtocol>)obj)name] forKey:key];
    }];

    return [result copy];
}

- (HL7CCDSummary *)summarizeCcda:(HL7CCD *)ccda templates:(NSSet<NSString *> *)templates
{
    if (!ccda) {
        return nil;
    }

    NSMutableDictionary *analyzers = [self getAllAnalyzers]; // => HL7Analyzer*
    if (![analyzers count]) {
        return nil;
    }

    NSMutableArray *remove = [[NSMutableArray alloc] initWithCapacity:[analyzers count]];
    [analyzers enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL *_Nonnull stop) {
        if (![obj isKindOfClass:[HL7PatientRoleAnalyzer class]]) { // patient role analyzer stays
            if (![templates containsObject:key]) {
                [remove addObject:key];
            }
        }
    }];
    [analyzers removeObjectsForKeys:remove];

    HL7CCDSummary *summary = [HL7CCDSummary new];

    [analyzers enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL *_Nonnull stop) {
        id<HL7SummaryProtocol> analysis = [obj analyzeSectionUsingDocument:ccda];

        if ([analysis isKindOfClass:[HL7PatientSummary class]]) {
            [summary setPatient:(HL7PatientSummary *)analysis];
        } else {
            [[summary mutableSummaries] setObject:analysis forKey:key];
        }
    }];
    return summary;
}
@end
