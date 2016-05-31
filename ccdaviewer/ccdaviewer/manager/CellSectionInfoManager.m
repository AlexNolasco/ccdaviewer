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
#import "CellSectionInfoManager.h"
#import "SectionStorage.h"
#import "SummaryCellSectionInfo.h"

typedef NSMutableDictionary<NSString *, SummaryCellSectionInfo *> HL7CellSectionInfoMutableDictionary;

@implementation CellSectionInfoManager

- (CellSectionInfoDictionary *)getCellInfoForActiveSections
{
    // just the active ones to avoid loading unecessary nibs
    HL7SectionInfoArray *active = [[SectionStorage sharedIntance] getAllActive];
    NSDictionary *summaries = [[HL7Parser new] getSummaries];

    HL7CellSectionInfoMutableDictionary *dictionary = [[HL7CellSectionInfoMutableDictionary alloc] initWithCapacity:[active count]];

    for (HL7SectionInfo *sectionInfo in active) {

        NSString *className = [summaries objectForKey:[sectionInfo templateId]];
        if ([className length]) {

            SummaryCellSectionInfo *cellInfo = [SummaryCellSectionInfo new];

            // e.g.
            // ViewerHL7AllergyAnalyzerCell
            // ViewerHL7AllergyAnalyzerHeaderView
            // ViewerHL7AllergyAnalyzerNoDataCell
            NSString *detailCellName = [NSString stringWithFormat:@"Viewer%@Cell", className];
            NSString *headerCellName = [NSString stringWithFormat:@"Viewer%@HeaderView", className];
            NSString *noDataCellName = [NSString stringWithFormat:@"Viewer%@NoDataCell", className];

            // if there is a nib for it, use it
            if ([[NSBundle mainBundle] pathForResource:detailCellName ofType:@"nib"]) {
                [cellInfo setDetailCell:detailCellName];
            }

            if ([[NSBundle mainBundle] pathForResource:headerCellName ofType:@"nib"]) {
                [cellInfo setHeaderCell:headerCellName];
            }

            if ([[NSBundle mainBundle] pathForResource:noDataCellName ofType:@"nib"]) {
                [cellInfo setNoDataCell:noDataCellName];
            }

            [dictionary setObject:cellInfo forKey:[sectionInfo templateId]];
        } else {
            NSLog(@"template id %@ does not have a corresponding summary.", [sectionInfo templateId]);
        }
    }
    return [dictionary copy];
}

- (void)registerCellsForTableView:(UITableView *)tableView using:(CellSectionInfoDictionary *)dictionary
{
    NSMutableSet<NSString *> *registrations = [[NSMutableSet alloc] initWithCapacity:10];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, SummaryCellSectionInfo *_Nonnull obj, BOOL *_Nonnull stop) {

        if ([[obj detailCell] length] && ![registrations containsObject:[obj detailCell]]) {
            [registrations addObject:[obj detailCell]];
            UINib *nib = [UINib nibWithNibName:[obj detailCell] bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:[obj detailCell]];
        }

        if ([[obj noDataCell] length] && ![registrations containsObject:[obj noDataCell]]) {
            [registrations addObject:[obj noDataCell]];
            UINib *nib = [UINib nibWithNibName:[obj noDataCell] bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:[obj noDataCell]];
        }

        if ([[obj headerCell] length] && ![registrations containsObject:[obj headerCell]]) {
            [registrations addObject:[obj headerCell]];
            UINib *nib = [UINib nibWithNibName:[obj headerCell] bundle:nil];
            [tableView registerNib:nib forHeaderFooterViewReuseIdentifier:[obj headerCell]];
        }
    }];
}

- (NSString *)getHeaderForSummary:(id<HL7SummaryProtocol>)summary defaultHeader:(NSString *)header
{
    if ([summary isKindOfClass:[HL7AllergySummary class]]) {
        HL7AllergySummary *allergySummary = (HL7AllergySummary *)summary;
        if ([allergySummary noKnownAllergiesFound] || [allergySummary noKnownMedicationAllergiesFound]) {
            return header;
        } else {
            return header;
        }
    }
    return header;
}
@end
