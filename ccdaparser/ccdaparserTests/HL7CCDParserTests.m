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
#import "HL7CCDParser.h"
#import "HL7ClinicalDocument.h"
#import "HL7Identifier.h"
#import "HL7PatientRole.h"
#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>

@interface HL7CCDParserTests : XCTestCase
@end

@implementation HL7CCDParserTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)displayErrors:(NSError *)error
{
    NSLog(@"%@", [error localizedDescription]);
    NSArray *errors = [[error userInfo] objectForKey:@"errors"];
    NSDictionary *parserError = [[errors firstObject] userInfo];

    [parserError enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL *_Nonnull stop) {
        NSLog(@"%@", obj);
    }];
}

- (void)testParseXmlStringWithEmptyString
{
    HL7CCDParser *parser = [HL7CCDParser new];
    NSError *error;
    HL7CCD *ccd = [parser parseXMLString:@"" error:&error];
    XCTAssertNotNil(ccd);
    XCTAssertTrue(error == NULL);
}

- (void)testParseXmlStringWithXmlSignature
{
    HL7CCDParser *parser = [HL7CCDParser new];
    NSError *error = nil;
    HL7CCD *ccd = [parser parseXMLString:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>" error:&error];
    XCTAssertNotNil(ccd);
    XCTAssertTrue(error != NULL);
    [self displayErrors:error];
}

- (void)testParseXmlStringMissingClinicalDocument
{
    NSString *xml = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
                     "<?xml-stylesheet type=\"text/xsl\" href=\"CDA.xsl\"?>";
    HL7CCDParser *parser = [HL7CCDParser new];
    NSError *error;
    HL7CCD *ccd = [parser parseXMLString:xml error:&error];
    XCTAssertNotNil(ccd);
    XCTAssertTrue(error != NULL);
}

- (void)testParseXmlStringWithRandomText
{
    NSString *xml = @"Lorem ipsum dolor sit amet,";
    HL7CCDParser *parser = [HL7CCDParser new];
    NSError *error;
    HL7CCD *ccd = [parser parseXMLString:xml error:&error];
    XCTAssertNotNil(ccd);
    XCTAssertTrue(error != NULL);
}

- (void)testParseXmlStringWithEmptyClinicalDocument
{
    NSString *xml = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
                     "<?xml-stylesheet type=\"text/xsl\" href=\"CDA.xsl\"?>"
                     "<ClinicalDocument xmlns=\"urn:hl7-org:v3\" "
                     "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "
                     "xmlns:voc=\"urn:hl7-org:v3/voc\" xmlns:sdtc=\"urn:hl7-org:sdtc\">"
                     "</ClinicalDocument>";
    HL7CCDParser *parser = [HL7CCDParser new];
    NSError *error;
    HL7CCD *ccd = [parser parseXMLString:xml error:&error];
    XCTAssertNotNil(ccd);
    XCTAssertTrue(error == NULL);
}

- (void)testParseXmlStringWithClinicalDocument
{
    NSString *xml = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
                     "<?xml-stylesheet type=\"text/xsl\" href=\"CDA.xsl\"?>"
                     "<ClinicalDocument xmlns=\"urn:hl7-org:v3\" "
                     "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "
                     "xmlns:voc=\"urn:hl7-org:v3/voc\" xmlns:sdtc=\"urn:hl7-org:sdtc\">"
                     "<id extension=\"TT988\" root=\"2.16.840.1.113883.19.5.99999.1\"/>"
                     "<typeId extension=\"POCD_HD000040\" root=\"2.16.840.1.113883.1.3\"/>"
                     "<templateId root=\"2.16.840.1.113883.10.20.22.1.2\" "
                     "extension=\"2015-08-01\"/>"
                     "<title>Patient Chart Summary</title>"
                     "<code code=\"34133-9\" displayName=\"Summarization of Episode Note\" "
                     "codeSystem=\"2.16.840.1.113883.6.1\" codeSystemName=\"LOINC\"/>"
                     "<recordTarget><patientRole><addr><country>US</country></addr></"
                     "patientRole></recordTarget>"
                     "</ClinicalDocument>";
    HL7CCDParser *parser = [HL7CCDParser new];
    NSError *error;
    HL7CCD *ccd = [parser parseXMLString:xml error:&error];
    XCTAssertNotNil(ccd);
    XCTAssertTrue(error == NULL);
    XCTAssert([[[ccd clinicalDocument] title] isEqualToString:@"Patient Chart Summary"], @"title");
    XCTAssert([[[ccd clinicalDocument] version] isEqualToString:@"urn:hl7-org:v3"], @"version");
    XCTAssert([[[ccd clinicalDocument] firstTemplateId] isEqualToString:@"2.16.840.1.113883.10.20.22.1.2"], @"templateId");
    XCTAssertNotNil([[ccd clinicalDocument] code]);
    XCTAssertNotNil([[ccd clinicalDocument] patientRole]);
    XCTAssertTrue([[[[ccd clinicalDocument] identifier] extension] isEqualToString:@"TT988"]);
    XCTAssert([[[[ccd clinicalDocument] patientRole] addresses] count] == 1);
}

- (void)testParseEmptyClinicalDocument
{
    HL7CCDParser *parser = [HL7CCDParser new];
    NSError *error;
    NSString *fullPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"emptyClinicalDocument.xml" ofType:nil];
    HL7CCD *ccd = [parser parseXMLFilePath:fullPath error:&error];
    XCTAssertNotNil(ccd);
    XCTAssertTrue(error == NULL);
    XCTAssert([[[ccd clinicalDocument] title] isEqualToString:@"Patient Chart Summary"], @"title");
    XCTAssert([[[ccd clinicalDocument] firstTemplateId] isEqualToString:@"2.16.840.1.113883.10.20.22.1.2"], @"templateId");
}

- (void)testFileNotFound
{
    HL7CCDParser *parser = [HL7CCDParser new];
    NSError *error;
    HL7CCD *ccd = [parser parseXMLFile:@"invalidfilename.xml" error:&error];
    XCTAssertNotNil(error);
    XCTAssertNotNil(ccd);
}
@end
