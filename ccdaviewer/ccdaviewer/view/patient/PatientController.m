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

#import <ccdaparser/ccdaparser.h>
#import "PatientController.h"
#import "SectionStorage.h"

@interface PatientController ()
@property (nonatomic, strong) NSDictionaryTemplateIdToSummary *summaries;
@property (nonatomic, strong) NSDictionaryTemplateIdToSummary *filteredSummaries;
@property (nonatomic, strong) HL7SectionInfoArray *allActiveSections;
@property (nonatomic, strong) HL7SectionInfoMutableArray *filteredActiveSections;
@property (nonatomic, copy) NSString *lastFilter;
@property (nonatomic, weak) HL7CCDSummary *ccdSummary;
@end

@implementation PatientController

- (instancetype)initWithHL7CCDSummary:(HL7CCDSummary *)ccdSummary
{
    if ((self = [super init])) {
        _ccdSummary = ccdSummary;
    }
    return self;
}

- (void)entriesMessageForSummaryForSummary:(id<HL7SummaryProtocol>)summary withBlock:(void (^)(BOOL hasEntries, NSString *message))block
{
    NSString *entriesMessage = nil;
    if (!block) {
        return;
    }
    const NSInteger allEntriesCount = [[summary allEntries] count];

    // Allergy
    if ([summary isKindOfClass:[HL7AllergySummary class]]) {
        HL7AllergySummary *allergySummary = (HL7AllergySummary *)summary;
        if (![allergySummary countOfActualEntries] && allEntriesCount > 0) {

            if ([allergySummary noKnownAllergiesFound] && [allergySummary noKnownMedicationAllergiesFound]) {
                entriesMessage = NSLocalizedString(@"SummaryAllergy.NoAllergies", nil);
            } else if ([allergySummary noKnownAllergiesFound]) {
                entriesMessage = NSLocalizedString(@"SummaryAllergy.NoKnownAllergies", nil);
            } else if ([allergySummary noKnownAllergiesFound]) {
                entriesMessage = NSLocalizedString(@"SummaryAllergy.NoMedicalAllergies", nil);
            }
            block(NO, entriesMessage);
            return;
        }
    }

    // Others
    if (!allEntriesCount) {
        entriesMessage = NSLocalizedString(@"PatientViewController.NoEntries", nil);
    } else if (allEntriesCount > 1) {
        entriesMessage = [NSString stringWithFormat:NSLocalizedString(@"PatientViewController.Entries", @"Entries"), [[summary allEntries] count]];
    } else {
        entriesMessage = [NSString stringWithFormat:NSLocalizedString(@"PatientViewController.Entry", @"Entry"), [[summary allEntries] count]];
    }
    block(allEntriesCount > 0, entriesMessage);
}

- (UIImage *)imageForSection:(HL7SectionInfo *)sectionInfo
{
    UIImage *image = [[UIImage imageNamed:sectionInfo.name] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    if (!image) {
        NSLog(@"\"%@\" asset image was not found", sectionInfo.name);
        image = [[UIImage imageNamed:@"HealthBook"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    return image;
}

- (NSDictionaryTemplateIdToSummary *)summaries
{
    if (_summaries == nil) {
        _summaries = [[self ccdSummary] summaries];
    }
    return _summaries;
}

- (HL7SectionInfoArray *)allActiveSections
{
    if (_allActiveSections == nil) {
        _allActiveSections = [SectionStorage activeSectionsFilteredBySummary:[self ccdSummary]];
    }
    return _allActiveSections;
}

- (void)filterSectionsByString:(NSString *)searchString
{
    const NSInteger searchStringLength = [searchString length];
    if (!searchStringLength) {
        _filteredActiveSections = [self.allActiveSections copy];
    } else {
        _filteredActiveSections = [[HL7SectionInfoMutableArray alloc] initWithCapacity:[self.allActiveSections count]];
        [self.summaries enumerateKeysAndObjectsUsingBlock:^(NSString *key, id<HL7SummaryProtocol> obj, BOOL *stop) {
            if ([obj conformsToProtocol:@protocol(HL7SummarySearchProtocol)]) {
                HL7SummaryEntryArray *entries = [(id<HL7SummarySearchProtocol>)obj searchByString:searchString];
                if ([entries count]) {
                    [self.allActiveSections enumerateObjectsUsingBlock:^(HL7SectionInfo *section, NSUInteger idx, BOOL *stop) {
                        if ([section.templateId isEqualToString:obj.templateId]) {
                            [_filteredActiveSections addObject:section];
                            *stop = YES;
                        }
                    }];
                }
            }
        }];
    }

    self.lastFilter = searchString;
}

- (void)clearSectionFilter
{
    self.lastFilter = nil;
    _filteredActiveSections = [self.allActiveSections copy];
}

- (NSInteger)countOfActiveSectionsFilteredSections
{
    return [_filteredActiveSections count];
}

- (HL7SectionInfo *)sectionInfoAtIndex:(NSInteger)index
{
    return self.filteredActiveSections[index];
}

- (id<HL7SummaryProtocol>)summaryByTemplateId:(NSString *)templateId
{
    return self.summaries[templateId];
}

@end
