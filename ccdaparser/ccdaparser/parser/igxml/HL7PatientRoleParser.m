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


#import "HL7PatientRoleParser.h"
#import "HL7Const.h"
#import "HL7CCD.h"
#import "HL7ClinicalDocument.h"
#import "HL7PatientRole.h"
#import "HL7Patient.h"
#import "HL7Name.h"
#import "HL7ElementParser+Additions.h"
#import "ParserPlan.h"
#import "ParserContext.h"
#import "IGXMLReader.h"
#import "HL7PatientParser.h"

@implementation HL7PatientRoleParser
- (NSString *)designatedElementName
{
    return HL7ElementPatientRole;
}

- (ParserPlan *)createParsePlan:(ParserContext *)context HL7Element:(HL7PatientRole *)element error:(NSError *__autoreleasing *)error
{
    ParserPlan *plan = [ParserPlan planAtDepth:[[context reader] depth]];

    // addr
    [plan when:HL7ElementAddr
        parseWithBlock:^(ParserContext *context, IGXMLReader *node, BOOL *stop) {
            [[element addresses] addObject:[HL7ElementParser addrFromReader:[context reader]]];
        }];

    // phone
    [plan when:HL7ElementTelecom
        parseWithBlock:^(ParserContext *context, IGXMLReader *node, BOOL *stop) {
            HL7Telecom *telecom = [HL7ElementParser telecomFromReader:[context reader]];
            [[element telecoms] addObject:telecom];
        }];

    [plan when:HL7ElementPatient
        parseWithBlock:^(ParserContext *context, IGXMLReader *node, BOOL *stop) {
            [[[HL7PatientParser alloc] init] parse:context error:error];
        }];
    return plan;
}

- (BOOL)parse:(ParserContext *)context error:(NSError *__autoreleasing *)error
{

    HL7PatientRole *patientRole = [[[context hl7ccd] clinicalDocument] patientRole];
    ParserPlan *parserPlan = [self createParsePlan:context HL7Element:patientRole error:error];

    [self iterate:(ParserContext *)context
        usingBlock:^(ParserContext *context, BOOL *stop) {
            [self parse:context usingPlan:parserPlan stop:stop];
        }];
    return YES;
}
@end
