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


#import <XCTest/XCTest.h>
#import <ccdaparser/ccdaparser.h>
#import "HL7CCD.h"
#import "HL7ClinicalDocument.h"
#import "HL7ElementParser+Additions.h"
#import "HL7Guardian.h"
#import "HL7GuardianParser.h"
#import "HL7Name_Private.h"
#import "HL7Patient.h"
#import "HL7PatientRole.h"
#import "HL7RecordTargetParser.h"
#import "IGXMLReader+Additions.h"
#import "IGXMLReader.h"
#import "ParserContext.h"

@interface HL7GuardianParserTests : XCTestCase
@end

@implementation HL7GuardianParserTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}


- (void)testSuccess
{
    NSString *xml = @"<guardian>"
                     "<code code=\"POWATT\" displayName=\"Power of Attorney\" "
                     "codeSystem=\"2.16.840.1.113883.1.11.19830\" "
                     "codeSystemName=\"ResponsibleParty\"/>"
                     "<addr use=\"HP\">"
                     "<streetAddressLine>2222 Home Street</streetAddressLine>"
                     "</addr>"
                     "<telecom value=\"tel:+1(555)555-2008\" use=\"MC\"/>"
                     "<guardianPerson>"
                     "<name>"
                     "<given>Boris</given>"
                     "<family>Betterhalf</family>"
                     "</name>"
                     "</guardianPerson>"
                     "</guardian>";
    NSError *error;
    HL7CCD *hl7ccd = [[HL7CCD alloc] init];
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];
    ParserContext *context = [[ParserContext alloc] initWithReader:reader hl7ccd:hl7ccd];
    HL7GuardianParser *parser = [[HL7GuardianParser alloc] init];

    // execute
    [parser parse:context error:&error];

    // assert
    HL7PatientRole *patientRole = [[[context hl7ccd] clinicalDocument] patientRole];
    XCTAssertNil(error);
    XCTAssertNotNil(patientRole);
    XCTAssertNotNil([[patientRole patient] guardians]);
    XCTAssertEqual([[[patientRole patient] guardians] count], 1);
    HL7Guardian *guardian = [[[patientRole patient] guardians] firstObject];
    XCTAssertEqual([[guardian addresses] count], 1);
    XCTAssertEqual([[guardian telecoms] count], 1);
    XCTAssertNotNil([guardian name]);
}
@end
