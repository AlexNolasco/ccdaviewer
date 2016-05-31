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
@class HL7SectionInfo;
@class HL7CCDSummary;
@class HL7CCDSummary;

typedef NSMutableArray<HL7SectionInfo *> HL7SectionInfoMutableArray;
typedef NSArray<HL7SectionInfo *> HL7SectionInfoArray;

@interface SectionStorage : NSObject
+ (instancetype)sharedIntance;
- (HL7SectionInfoArray *)getAll;
- (void)save:(HL7SectionInfoMutableArray *)array;
- (HL7SectionInfoArray *)getAllActive;
+ (NSSet<NSString *> *)activeTemplateIds;
+ (HL7SectionInfoArray *)activeSections;
+ (HL7SectionInfoArray *)activeSectionsFilteredBySummary:(HL7CCDSummary *)ccdSummary;
@end
