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


#import "HL7Const.h"
#import "HL7GuardianParser.h"
#import "HL7Guardian.h"
#import "HL7Patient.h"
#import "HL7CCD.h"
#import "HL7ClinicalDocument.h"
#import "HL7PatientRole.h"
#import "ParserPlan.h"
#import "ParserContext.h"
#import "HL7ElementParser+Additions.h"
#import "IGXMLReader+Additions.h"

@implementation HL7GuardianParser
- (NSString *)designatedElementName
{
    return HL7ElementGuardian;
}

- (ParserPlan *)createParsePlan:(ParserContext *)context HL7Element:(HL7Guardian *)element error:(NSError *__autoreleasing *)error
{

    ParserPlan *plan = [ParserPlan planAtDepth:[[context reader] depth]];

    // code
    [plan when:HL7ElementCode
        parseWithBlock:^(ParserContext *context, IGXMLReader *node, BOOL *stop) {
            [element setCode:[HL7ElementParser codeFromReader:[context reader]]];
        }];

    // address
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

    // guardian person
    [plan when:HL7ElementGuardianPerson
        parseWithBlock:^(ParserContext *context, IGXMLReader *node, BOOL *stop) {
            [self iterate:context
                untilEndOfElementName:HL7ElementGuardianPerson
                           usingBlock:^(ParserContext *context, BOOL *stop) {
                               IGXMLReader *node = [context node];
                               if ([node isStartOfElementWithName:HL7ElementName]) {
                                   [element setName:[HL7ElementParser nameFromReader:[context reader]]];
                               }
                           }];
        }];
    return plan;
}

- (BOOL)parse:(ParserContext *)context error:(NSError *__autoreleasing *)error
{

    HL7Patient *patient = [[[[context hl7ccd] clinicalDocument] patientRole] patient];
    HL7Guardian *guardian = [[HL7Guardian alloc] init];
    ParserPlan *parserPlan = [self createParsePlan:context HL7Element:guardian error:error];

    [self iterate:(ParserContext *)context
        usingBlock:^(ParserContext *context, BOOL *stop) {
            [self parse:context usingPlan:parserPlan stop:stop];
        }];

    [[patient guardians] addObject:guardian];
    return YES;
}
@end
