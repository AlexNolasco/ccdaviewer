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


#import "HL7Section.h"
#import "HL7SectionMapper.h"
#import "HL7SectionParser.h"
#import "HL7TemplateId.h"
#import "HL7SectionInfo_Private.h"
#import "NSArray+Subclasses.h"

@implementation HL7SectionMapper

- (nonnull NSMutableDictionary *)dictionaryOfParsers
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithCapacity:10];

    for (Class classInfo in [NSArray classGetSubclasses:[HL7SectionParser class]]) {
        id<HL7ElementSectionParserProtocol> parser = [classInfo new];
        if ([[parser templateId] length] > 0) {
            [parser setEnabled:YES];
            [result setObject:parser forKey:[parser templateId]];
        }
    }
    return result;
}

- (NSMutableDictionary *)parsers
{
    if (_parsers == nil) {
        _parsers = [self dictionaryOfParsers];
    }
    return _parsers;
}

- (NSArraySectionInfo *_Nonnull)availableParsers
{
    NSMutableArray<HL7SectionInfo *> *arrayOfSections = [[NSMutableArray alloc] initWithCapacity:10];

    [[self parsers] enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL *_Nonnull stop) {
        [arrayOfSections addObject:[[HL7SectionInfo alloc] initWithSectionParser:(id<HL7ElementSectionParserProtocol>)obj]];
    }];

    return [arrayOfSections sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
        NSString *first = [(HL7SectionInfo *)obj1 name];
        NSString *second = [(HL7SectionInfo *)obj2 name];
        return [first compare:second];
    }];
}

- (void)enableParsers:(NSSet<NSString *> *)templateIds
{
    [[self parsers] enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL *_Nonnull stop) {
        if (templateIds == nil || ![templateIds containsObject:key]) { // disable all when nil
            [((id<HL7ElementSectionParserProtocol>)obj) setEnabled:NO];
        }
    }];
}

- (id<HL7ElementSectionParserProtocol>)getParserForSection:(HL7Section *)section
{
    for (HL7TemplateId *templateId in [section templateIds]) {
        id<HL7ElementSectionParserProtocol> parser = [[self parsers] objectForKey:[templateId root]];
        if (parser != nil) {
            return parser;
        }
    }
    return nil;
}
@end
