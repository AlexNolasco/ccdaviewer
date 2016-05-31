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

#import <objc/runtime.h>
#import "HL7Const.h"
#import "HL7CCd.h"
#import "HL7StructuredBodyParser.h"
#import "HL7ElementSectionParserProtocol.h"
#import "HL7SectionParser.h"
#import "HL7SectionGenericParser.h"
#import "HL7Section.h"
#import "HL7ElementParser+Additions.h"
#import "HL7SectionMapper.h"
#import "IGXMLReader.h"
#import "IGXMLReader+Additions.h"
#import "ParserContext.h"
#import "ParserPlan.h"

@implementation HL7StructuredBodyParser {
    id<HL7SectionMapperProtocol> __weak _sectionMapper;
}

- (NSString *)designatedElementName
{
    return HL7ElementStructuredBody;
}

- (instancetype)initWithMapper:(id<HL7SectionMapperProtocol>)mapper
{
    if ((self = [super init])) {
        _sectionMapper = mapper;
    }
    return self;
}

- (void)parseComponent:(ParserContext *)context error:(NSError *__autoreleasing *)error
{
    __block id<HL7ElementSectionParserProtocol> sectionParser;

    [self iterate:context
        untilEndOfElementName:HL7ElementComponent
                   usingBlock:^(ParserContext *context, BOOL *stop) {

                       // section
                       if ([[context node] isStartOfElementWithName:HL7ElementSection]) {
                           sectionParser = nil;

                           HL7SectionGenericParser *sectionGenericParser = [[HL7SectionGenericParser alloc] init];
                           HL7Section *temporaryHL7Section = [sectionGenericParser createSectionFromSection:nil];

                           sectionGenericParser = [[HL7SectionGenericParser alloc] init];
                           [context setSection:temporaryHL7Section];
                           [self iterate:context
                               untilEndOfElementName:HL7ElementSection
                                          usingBlock:^(ParserContext *context, BOOL *stop) {

                                              if (sectionParser == nil) {
                                                  // parse generic information
                                                  [sectionGenericParser parse:context error:error];

                                                  // determine if a section parser can be used
                                                  sectionParser = [_sectionMapper getParserForSection:temporaryHL7Section];
                                                  if (sectionParser != nil && [sectionParser enabled]) {

                                                      if ([[context delegate] respondsToSelector:@selector(willParseSection:)]) {
                                                          [[context delegate] willParseSection:[temporaryHL7Section firstTemplateId]];
                                                      }
                                                      // context has a weak reference
                                                      HL7Section *section = [sectionParser createSectionFromSection:temporaryHL7Section];
                                                      // parser for section identified, use that parser
                                                      [context setSection:section];
                                                      [((HL7ElementParser *)sectionParser) parse:context error:error];
                                                      *stop = YES;
                                                  }
                                              }
                                          }];
                           if (sectionParser == nil && _sectionMapper != nil) {
                               [[[context hl7ccd] sections] addObject:temporaryHL7Section];
                           }
                       }
                   }];
}

- (BOOL)parse:(ParserContext *)context error:(NSError *__autoreleasing *)error
{
    [self iterate:context
        usingBlock:^(ParserContext *context, BOOL *stop) {
            if ([[context node] isStartOfElementWithName:HL7ElementComponent]) {
                [self parseComponent:context error:error];
            }
        }];
    return YES;
}
@end
