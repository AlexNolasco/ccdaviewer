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


#import "SectionStorage.h"
#import <ccdaparser/ccdaparser.h>

NSString *const SectionsKey = @"sections";

@implementation SectionStorage
- (HL7SectionInfoArray *)getAll
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:SectionsKey];
    HL7SectionInfoArray *arrayOfSections;

    if (data != nil) {
        arrayOfSections = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    } else {
        arrayOfSections = [[[HL7Parser alloc] init] getSections];
    }
    return arrayOfSections;
}

- (HL7SectionInfoArray *)getAllActive
{
    HL7SectionInfoMutableArray *all = [[HL7SectionInfoMutableArray alloc] initWithArray:[self getAll]];
    HL7SectionInfoMutableArray *result = [[HL7SectionInfoMutableArray alloc] initWithCapacity:[all count]];

    for (HL7SectionInfo *section in all) {
        if ([section enabled]) {
            [result addObject:section];
        }
    }
    return [result copy];
}

+ (HL7SectionInfoArray *)activeSections
{
    return [[SectionStorage sharedIntance] getAllActive];
}

+ (HL7SectionInfoArray *)activeSectionsFilteredBySummary:(HL7CCDSummary *)ccdSummary
{
    HL7SectionInfoArray *allActive = [[SectionStorage sharedIntance] getAllActive];
    HL7SectionInfoMutableArray *result = [[HL7SectionInfoMutableArray alloc] initWithCapacity:[allActive count]];

    [allActive enumerateObjectsUsingBlock:^(HL7SectionInfo *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        id<HL7SummaryProtocol> summary = [[ccdSummary summaries] objectForKey:[obj templateId]];
        if (summary && ![summary isEmpty]) {
            [result addObject:obj];
        } else {
            NSLog(@"Removed section %@ - %@", [obj templateId], [obj name]);
        }
    }];

    return [result copy];
}

- (void)save:(HL7SectionInfoMutableArray *)array
{
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];

    [currentDefaults setObject:data forKey:SectionsKey];
}

+ (NSSet<NSString *> *)activeTemplateIds
{
    HL7SectionInfoArray *activeSections = [SectionStorage activeSections];
    NSMutableSet *templates = [[NSMutableSet alloc] initWithCapacity:[activeSections count]];

    for (HL7SectionInfo *info in [SectionStorage activeSections]) {
        [templates addObject:[info templateId]];
    }
    return [templates copy];
}

+ (instancetype)sharedIntance
{
    static SectionStorage *shared = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}
@end
