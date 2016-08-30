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


#import "HL7Parser.h"
#import "HL7CCDParser.h"
#import "HL7SectionMapper.h"
#import "HL7CCDParserProtocol.h"
#import "HL7Summarizer.h"

@interface HL7Parser ()
@property (nonnull, nonatomic, strong) NSMutableSet<NSString *> *templateIds;
@end

@implementation HL7Parser
- (NSSet<NSString *> *)templateIds
{
    if (_templateIds == nil) {
        _templateIds = [[NSMutableSet alloc] initWithCapacity:5];
    }
    return _templateIds;
}

- (id<HL7CCDParserProtocol>)getParser
{
    return [HL7CCDParser new];
}

- (HL7CCDSummary *_Nonnull)parseXMLNSData:(NSData *_Nonnull)data templates:(NSSet<NSString *> *_Nullable)templateIds withEncoding:(NSString *_Nonnull)encoding error:(NSError *_Nonnull *_Nonnull)error
{
    // parse
    HL7CCD *ccda = [[self getParser] parseXMLNSData:data encoding:encoding error:error];

    // summarize
    HL7CCDSummary *summary = [[HL7Summarizer new] summarizeCcda:ccda templates:templateIds];

    // visualize
    return summary;
}

- (void)enableSectionsWithTemplateIds:(NSSet<NSString *> *_Nonnull)templateIds
{
    for (NSString *item in templateIds) {
        [[self templateIds] addObject:item];
    }
}

- (NSArraySectionInfo *_Nonnull)sections
{
    HL7SectionMapper *mapper = [HL7SectionMapper new];
    return [mapper availableParsers];
}

- (NSDictionaryTemplateIdToSummaryClassName *_Nonnull)summaries
{
    return [[HL7Summarizer new] getDictionaryOfSummaryImplementations];
}
@end
