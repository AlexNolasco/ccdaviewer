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


#import "HL7PatientParser.h"
#import "ParserPlan.h"
#import "ParserContext.h"
#import "IGXMLReader.h"
#import "HL7GuardianParser.h"
#import "HL7Const.h"
#import "HL7CCD.h"
#import "HL7ClinicalDocument.h"
#import "HL7PatientRole.h"
#import "HL7Patient.h"
#import "HL7Name.h"
#import "HL7ElementParser+Additions.h"

@implementation HL7PatientParser
- (NSString *)designatedElementName
{
    return HL7ElementPatient;
}

- (ParserPlan *)createParsePlan:(ParserContext *)context HL7Element:(HL7Patient *)element error:(NSError *__autoreleasing *)error
{

    ParserPlan *plan = [ParserPlan planAtDepth:[[context reader] depth]];

    // name
    [plan when:HL7ElementName
        parseWithBlock:^(ParserContext *context, IGXMLReader *node, BOOL *stop) {
            [[element names] addObject:[HL7ElementParser nameFromReader:[context reader]]];
        }];

    // birthtime
    [plan when:HL7ElementBirthTime
        parseWithBlock:^(ParserContext *context, IGXMLReader *node, BOOL *stop) {
            [element setBirthTime:[node attributeWithName:HL7AttributeValue]];
        }];

    // gender
    [plan when:HL7ElementAdministrativeGenderCode
        parseWithBlock:^(ParserContext *context, IGXMLReader *node, BOOL *stop) {
            [element setAdministrativeGenderCode:[HL7ElementParser codeFromReader:node withElementName:HL7ElementAdministrativeGenderCode]];
        }];

    // marital status
    [plan when:HL7ElementMaritalStatusCode
        parseWithBlock:^(ParserContext *context, IGXMLReader *node, BOOL *stop) {
            [element setMaritalStatusCode:[HL7ElementParser codeFromReader:node withElementName:HL7ElementMaritalStatusCode]];
        }];

    // guardian
    [plan when:HL7ElementGuardian
        parseWithBlock:^(ParserContext *context, IGXMLReader *node, BOOL *stop) {
            [[[HL7GuardianParser alloc] init] parse:context error:error];
        }];

    // ethnic group
    [plan when:HL7ElementEthnicGroupCode
        parseWithBlock:^(ParserContext *context, IGXMLReader *node, BOOL *stop) {
            [element setEthnicGroupCode:[HL7ElementParser codeFromReader:node withElementName:HL7ElementEthnicGroupCode]];
        }];

    return plan;
}

- (BOOL)parse:(ParserContext *)context error:(NSError *__autoreleasing *)error
{

    HL7Patient *patient = [[[[context hl7ccd] clinicalDocument] patientRole] patient];
    ParserPlan *parserPlan = [self createParsePlan:context HL7Element:patient error:error];

    [self iterate:(ParserContext *)context
        usingBlock:^(ParserContext *context, BOOL *stop) {
            [self parse:context usingPlan:parserPlan stop:stop];
        }];
    return YES;
}
@end
