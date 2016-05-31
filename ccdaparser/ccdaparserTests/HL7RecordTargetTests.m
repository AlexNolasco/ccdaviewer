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
#import "HL7Name_Private.h"
#import "HL7Patient.h"
#import "HL7PatientRole.h"
#import "HL7RecordTargetParser.h"
#import "IGXMLReader+Additions.h"
#import "IGXMLReader.h"
#import "ParserContext.h"


@interface HL7RecordTargetTests : XCTestCase
@end

@implementation HL7RecordTargetTests

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
    NSString *xml = @"<recordTarget>"
                     "<patientRole>"
                     "<addr>"
                     "<streetAddressLine>2222 Home Street</streetAddressLine>"
                     "<city>2222 Home Street</city>"
                     "<state/>"
                     "<country/>"
                     "</addr>"
                     "<telecom value=\"tel:+1(555)555-2003\" use=\"HP\"/>"
                     "<patient>"
                     "<name use=\"L\"><given>alex</given><family>nolasco</family></name>"
                     "<birthTime value=\"19750501\"/>"
                     "</patient>"
                     "</patientRole>"
                     "</recordTarget>";

    NSError *error;
    HL7CCD *hl7ccd = [[HL7CCD alloc] init];
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];
    ParserContext *context = [[ParserContext alloc] initWithReader:reader hl7ccd:hl7ccd];
    HL7RecordTargetParser *parser = [[HL7RecordTargetParser alloc] init];

    // execute
    [parser parse:context error:&error];

    // assert
    HL7PatientRole *patientRole = [[[context hl7ccd] clinicalDocument] patientRole];
    XCTAssertNil(error);
    XCTAssertNotNil(patientRole);
    XCTAssertTrue([[patientRole addresses] count] == 1);
    XCTAssertTrue([[patientRole telecoms] count] == 1);
    XCTAssertTrue([[[[patientRole patient] name] first] isEqualToString:@"alex"]);
    XCTAssertTrue([[[[patientRole patient] name] last] isEqualToString:@"nolasco"]);
    XCTAssertTrue([[[patientRole patient] birthTime] isEqualToString:@"19750501"]);
    XCTAssertTrue([[patientRole patient] gender] == HL7AdministrativeGenderCodeUnknown);
    XCTAssertTrue([[patientRole patient] maritalStatus] == HL7MaritalStatusCodeUnknown);
}

- (void)testMultipleSuccess
{
    NSString *xml = @"<recordTarget>"
                     "<patientRole>"
                     "<addr>"
                     "<streetAddressLine>2222 Home Street</streetAddressLine>"
                     "<city>2222 Home Street</city>"
                     "<state/>"
                     "<country/>"
                     "</addr>"
                     "<addr>"
                     "<streetAddressLine>2222 Home Street</streetAddressLine>"
                     "<city>2222 Home Street</city>"
                     "<state/>"
                     "<country/>"
                     "</addr>"
                     "<telecom value=\"tel:+1(555)555-2003\" use=\"HP\"/>"
                     "<telecom value=\"tel:+1(555)555-2003\" use=\"HP\"/>"
                     "<patient>"
                     "<name use=\"L\"><given>alex</given><family>nolasco</family></name>"
                     "<birthTime value=\"19750501\"/>"
                     "<maritalStatusCode code=\"M\" codeSystem=\"2.16.840.1.113883.5.2\" "
                     "codeSystemName=\"MaritalStatusCode\"/>"
                     "<administrativeGenderCode code=\"M\" "
                     "codeSystem=\"2.16.840.1.113883.5.1\"/>"
                     "</patient>"
                     "</patientRole>"
                     "</recordTarget>";

    NSError *error;
    HL7CCD *hl7ccd = [[HL7CCD alloc] init];
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];
    ParserContext *context = [[ParserContext alloc] initWithReader:reader hl7ccd:hl7ccd];
    HL7RecordTargetParser *parser = [[HL7RecordTargetParser alloc] init];

    // execute
    [parser parse:context error:&error];

    // assert
    HL7PatientRole *patientRole = [[[context hl7ccd] clinicalDocument] patientRole];
    XCTAssertNil(error);
    XCTAssertNotNil(patientRole);
    XCTAssertTrue([[patientRole addresses] count] == 2);
    XCTAssertTrue([[patientRole telecoms] count] == 2);
    XCTAssertTrue([[[[patientRole patient] name] first] isEqualToString:@"alex"]);
    XCTAssertTrue([[[[patientRole patient] name] last] isEqualToString:@"nolasco"]);
    XCTAssertTrue([[[patientRole patient] birthTime] isEqualToString:@"19750501"]);
    XCTAssertTrue([[patientRole patient] gender] == HL7AdministrativeGenderCodeMale);
    XCTAssertTrue([[patientRole patient] maritalStatus] == HL7MaritalStatusCodeMarried);
}

- (void)testMultipleGuardians
{
    NSString *xml = @"<recordTarget>"
                     "<patientRole>"
                     "<addr>"
                     "<streetAddressLine>2222 Home Street</streetAddressLine>"
                     "<city>2222 Home Street</city>"
                     "<state/>"
                     "<country/>"
                     "</addr>"
                     "<addr>"
                     "<streetAddressLine>2222 Home Street</streetAddressLine>"
                     "<city>2222 Home Street</city>"
                     "<state/>"
                     "<country/>"
                     "</addr>"
                     "<telecom value=\"tel:+1(555)555-2003\" use=\"HP\"/>"
                     "<telecom value=\"tel:+1(555)555-2003\" use=\"HP\"/>"
                     "<patient>"
                     "<name use=\"L\"><given>alex</given><family>nolasco</family></name>"
                     "<birthTime value=\"19750501\"/>"
                     "<maritalStatusCode code=\"M\" codeSystem=\"2.16.840.1.113883.5.2\" "
                     "codeSystemName=\"MaritalStatusCode\"/>"
                     "<administrativeGenderCode code=\"M\" "
                     "codeSystem=\"2.16.840.1.113883.5.1\"/>"
                     "<guardian>"
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
                     "</guardian>"
                     "<guardian>"
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
                     "</guardian>"
                     "</patient>"
                     "</patientRole>"
                     "</recordTarget>";

    NSError *error;
    HL7CCD *hl7ccd = [[HL7CCD alloc] init];
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];
    ParserContext *context = [[ParserContext alloc] initWithReader:reader hl7ccd:hl7ccd];
    HL7RecordTargetParser *parser = [[HL7RecordTargetParser alloc] init];

    // execute
    [parser parse:context error:&error];

    // assert
    HL7PatientRole *patientRole = [[[context hl7ccd] clinicalDocument] patientRole];
    HL7Patient *patient = [patientRole patient];

    XCTAssertNil(error);
    XCTAssertNotNil(patient);
    XCTAssertTrue([[patient guardians] count] == 2);
}
@end
