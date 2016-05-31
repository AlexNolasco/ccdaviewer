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
#import "HL7Addr.h"
#import "HL7ElementParser+Additions.h"
#import "IGXMLReader+Additions.h"
#import "IGXMLReader.h"

@interface HL7AddrTests : XCTestCase

@end

@implementation HL7AddrTests

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
    NSString *xml = @"<addr use=\"HP\">"
                     "<streetAddressLine>2222 Home Street</streetAddressLine>"
                     "<city>Hialeah</city>"
                     "<state>FL</state>"
                     "<postalCode>33018</postalCode>"
                     "<country>US</country>"
                     "</addr>";
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];

    // execute
    HL7Addr *addr = [HL7ElementParser addrFromReader:reader];

    // assert
    XCTAssertNotNil(addr);
    XCTAssert([[addr addressLine] isEqualToString:@"2222 Home Street"]);
    XCTAssert([[addr state] isEqualToString:@"FL"]);
    XCTAssert([[addr city] isEqualToString:@"Hialeah"]);
    XCTAssert([[addr country] isEqualToString:@"US"]);
    XCTAssertTrue([[addr uses] isEqualToString:@"HP"]);
}

- (void)testEmpty
{
    NSString *xml = @"<addr/>";
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];

    // execute
    HL7Addr *addr = [HL7ElementParser addrFromReader:reader];

    // assert
    XCTAssertNotNil(addr);
    XCTAssertNil([addr state]);
    XCTAssertNil([addr addressLine]);
    XCTAssertNil([addr country]);
    XCTAssertNil([addr city]);
    XCTAssertNil([addr uses]);
}

- (void)testNullFlavor
{
    NSString *xml = @"<addr nullFlavor=\"UNK\"/>";
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];

    // execute
    HL7Addr *addr = [HL7ElementParser addrFromReader:reader];

    // assert
    XCTAssertNotNil(addr);
    XCTAssertTrue([[addr nullFlavor] isEqualToString:@"UNK"]);
    XCTAssertNil([addr uses]);
}

- (void)testMultipleLines
{
    NSString *xml = @"<addr use=\"HP\">"
                     "<streetAddressLine>2222 Home Street</streetAddressLine>"
                     "<streetAddressLine>2222 Home Street</streetAddressLine>"
                     "<city>Hialeah</city>"
                     "<state>FL</state>"
                     "<postalCode>33018</postalCode>"
                     "<country>US</country>"
                     "</addr>";
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];

    // execute
    HL7Addr *addr = [HL7ElementParser addrFromReader:reader];

    // assert
    XCTAssertNotNil(addr);
    XCTAssert([[addr streetAddressLines] count] == 2);
}
@end
