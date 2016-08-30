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

#import <Foundation/Foundation.h>
#import <ccdaparser/ccdaparser.h>

@class HL7CCDSummary;
@class HL7SectionInfo;

@interface PatientController : NSObject
- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithHL7CCDSummary:(HL7CCDSummary *)ccdSummary;
- (void)entriesMessageForSummaryForSummary:(id<HL7SummaryProtocol>)summary withBlock:(void (^)(BOOL hasEntries, NSString *message))block;
- (UIImage *)imageForSection:(HL7SectionInfo *)sectionInfo;

- (void)filterSectionsByString:(NSString *)searchString;
- (void)clearSectionFilter;
- (NSInteger)countOfActiveSectionsFilteredSections;
- (HL7SectionInfo *)sectionInfoAtIndex:(NSInteger)index;
- (id<HL7SummaryProtocol>)summaryByTemplateId:(NSString *)templateId;
@end
