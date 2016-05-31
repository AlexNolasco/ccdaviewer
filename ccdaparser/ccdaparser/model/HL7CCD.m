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


#import "HL7CCD.h"
#import "HL7ClinicalDocument.h"
#import "HL7Section.h"

@implementation HL7CCD

- (NSMutableArray<__kindof HL7Section *> *)sections
{
    if (_sections == nil) {
        _sections = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return _sections;
}

- (HL7ClinicalDocument *)clinicalDocument
{
    if (_clinicalDocument == nil) {
        _clinicalDocument = [[HL7ClinicalDocument alloc] init];
    }
    return _clinicalDocument;
}

- (HL7Section *_Nullable)getSectionByTemplateId:(NSString *_Nullable)templateId
{
    if (![[self sections] count]) {
        return nil;
    }
    for (HL7Section *section in [self sections]) {
        if ([section hasTemplateId:templateId]) {
            return section;
        }
    }
    return nil;
}
@end
