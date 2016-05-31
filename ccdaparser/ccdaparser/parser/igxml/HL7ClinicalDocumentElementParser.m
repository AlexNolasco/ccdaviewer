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


#import "HL7ClinicalDocumentElementParser.h"
#import "HL7Const.h"
#import "HL7CCD.h"
#import "HL7ElementParser+Additions.h"
#import "HL7ClinicalDocument.h"
#import "HL7RecordTargetParser.h"
#import "HL7PatientRole.h"
#import "HL7StructuredBodyParser.h"
#import "IGXMLReader.h"
#import "IGXMLReader+Additions.h"
#import "ParserContext.h"
#import "ParserPlan.h"

@implementation HL7ClinicalDocumentElementParser {
    id<HL7SectionMapperProtocol> __weak _sectionMapper;
}

- (NSString *)designatedElementName
{
    return HL7ElementClinicalDocument;
}

- (ParserPlan *)createParsePlan:(ParserContext *)context HL7Element:(HL7ClinicalDocument *)element error:(NSError *__autoreleasing *)error
{

    ParserPlan *plan = [ParserPlan plan];

    [plan when:HL7ElementClinicalDocument
        parseWithBlock:^(ParserContext *context, IGXMLReader *node, BOOL *stop) {
            if ([node hasAttributes]) {
                [element setVersion:[node attributeWithName:HL7AttributeXmlns]];
            }
        }];

    [plan when:HL7ElementId
        parseWithBlock:^(ParserContext *context, IGXMLReader *node, BOOL *stop) {
            [element setIdentifier:[HL7ElementParser identifierFromReader:node]];
        }];

    [plan when:HL7ElementTitle
        parseWithBlock:^(ParserContext *context, IGXMLReader *node, BOOL *stop) {
            [element setTitle:[[node text] copy]];
        }];

    [plan when:HL7ElementTemplateId
        parseWithBlock:^(ParserContext *context, IGXMLReader *node, BOOL *stop) {
            [[element templateIds] addObject:[HL7ElementParser templateIdFromReader:node]];
        }];

    [plan when:HL7ElementEffectiveTime
        parseWithBlock:^(ParserContext *context, IGXMLReader *node, BOOL *stop) {
            [element setEffectiveTime:[HL7ElementParser effectiveTimeFromReader:node]];
        }];

    [plan when:HL7ElementCode
        parseWithBlock:^(ParserContext *context, IGXMLReader *node, BOOL *stop) {
            [element setCode:[HL7ElementParser codeFromReader:node]];
        }];

    // recordTarget
    [plan when:HL7ElementRecordTarget
        parseWithBlock:^(ParserContext *context, IGXMLReader *node, BOOL *stop) {
            [[[HL7RecordTargetParser alloc] init] parse:context error:error];
        }];

    // structureBody
    [plan when:HL7ElementStructuredBody
        parseWithBlock:^(ParserContext *context, IGXMLReader *node, BOOL *stop) {
            [[[HL7StructuredBodyParser alloc] initWithMapper:_sectionMapper] parse:context error:error];
        }];
    return plan;
}

- (instancetype)initWithMapper:(id<HL7SectionMapperProtocol>)mapper
{
    if ((self = [super init])) {
        _sectionMapper = mapper;
    }
    return self;
}

- (BOOL)parse:(ParserContext *)context error:(NSError *__autoreleasing *)error
{
    ParserPlan *parserPlan = [self createParsePlan:context HL7Element:[[context hl7ccd] clinicalDocument] error:error];

    // iterate until end of clinical document
    [self iterate:context
        usingBlock:^(ParserContext *context, BOOL *stop) {
            [self parse:context usingPlan:parserPlan stop:stop];
        }];
    return YES;
}
@end
