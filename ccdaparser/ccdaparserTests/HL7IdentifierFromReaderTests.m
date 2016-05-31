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
#import "HL7Identifier.h"
#import "IGXMLReader+Additions.h"
#import "IGXMLReader.h"


@interface HL7IdentifierFromReaderTests : XCTestCase

@end

@implementation HL7IdentifierFromReaderTests

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
    NSString *xml = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?><id "
                    @"extension=\"444222222\" root=\"2.16.840.1.113883.4.1\"/>";
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];

    // execute
    HL7Identifier *identifier;
    identifier = [HL7ElementParser identifierFromReader:[reader nextObject]];

    // assert
    XCTAssertNotNil(identifier);
    XCTAssertTrue([[identifier extension] isEqualToString:@"444222222"]);
    XCTAssertTrue([[identifier root] isEqualToString:@"2.16.840.1.113883.4.1"]);
}
@end
