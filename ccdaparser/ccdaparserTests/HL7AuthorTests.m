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
#import "HL7AssignedAuthor.h"
#import "HL7Author.h"
#import "HL7ElementParser+Additions.h"
#import "HL7Identifier.h"
#import "HL7TemplateId.h"
#import "HL7Time.h"
#import "HL7identifier.h"
#import "HL7Code.h"
#import "IGXMLReader+Additions.h"
#import "IGXMLReader.h"


@interface HL7AuthorTests : XCTestCase

@end

@implementation HL7AuthorTests

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
    NSString *xml = @"<author typeCode=\"AUT\">"
                     "<templateId root=\"2.16.840.1.113883.10.20.22.4.119\"/>"
                     "<time value=\"199805011145-0800\"/>"
                     "<assignedAuthor>"
                     "<id extension=\"555555555\" root=\"2.16.840.1.113883.4.6\"/>"
                     "<code code=\"207QA0505X\" displayName=\"Adult Medicine\" "
                     "codeSystem=\"2.16.840.1.113883.6.101\" codeSystemName=\"Healthcare "
                     "Provider Taxonomy (HIPAA)\"/>"
                     "</assignedAuthor>"
                     "</author>";
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];

    // execute
    HL7Author *author = [HL7ElementParser authorFromReader:reader];

    // assert
    XCTAssertNotNil(author);
    XCTAssertTrue([[author typeCode] isEqualToString:@"AUT"]);
    XCTAssertNotNil([author templateId]);
    XCTAssertTrue([[[author templateId] root] isEqualToString:@"2.16.840.1.113883.10.20.22.4.119"]);
    XCTAssertNotNil([author time]);
    XCTAssertTrue([[[author time] value] isEqualToString:@"199805011145-0800"]);
    XCTAssertNotNil([author assignedAuthor]);
    XCTAssertNotNil([[author assignedAuthor] identifier]);
    XCTAssertTrue([[[[author assignedAuthor] identifier] root] isEqualToString:@"2.16.840.1.113883.4.6"]);
    XCTAssertTrue([[[[author assignedAuthor] identifier] extension] isEqualToString:@"555555555"]);
    XCTAssertNotNil([[author assignedAuthor] code]);
    XCTAssertTrue([[[[author assignedAuthor] code] displayName] isEqualToString:@"Adult Medicine"]);
}

- (void)testEmpy
{
    NSString *xml = @"<author/>";
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];

    // execute
    HL7Author *author = [HL7ElementParser authorFromReader:reader];

    // assert
    XCTAssertNotNil(author);
    XCTAssertNil([author typeCode]);
    XCTAssertNil([author templateId]);
    XCTAssertNil([author time]);
    XCTAssertNotNil([author assignedAuthor]);
    XCTAssertNil([[author assignedAuthor] identifier]);
    XCTAssertNil([[author assignedAuthor] code]);
}
@end
