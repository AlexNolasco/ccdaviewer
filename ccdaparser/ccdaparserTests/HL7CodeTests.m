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
#import "HL7Code.h"
#import "HL7ElementParser+Additions.h"
#import "HL7OriginalText.h"
#import "HL7Translation.h"
#import "IGXMLReader+Additions.h"
#import "IGXMLReader.h"


@interface HL7CodeTests : XCTestCase

@end

@implementation HL7CodeTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testCodeNullFlavor
{
    NSString *xml = @"<code nullFlavor=\"UNK\"/>";
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];

    // execute
    HL7Code *code = [HL7ElementParser codeFromReader:[reader nextObject]];

    // assert
    XCTAssertNotNil(code);
    XCTAssertTrue([[code nullFlavor] isEqualToString:@"UNK"]);
}

- (void)testCodeFromReaderSuccess
{
    NSString *xml = @"<code code=\"34133-9\" displayName=\"Summarization of "
                    @"Episode Note\" codeSystem=\"2.16.840.1.113883.6.1\" "
                    @"codeSystemName=\"LOINC\"/>";
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];

    // execute
    HL7Code *code = [HL7ElementParser codeFromReader:[reader nextObject]];

    // assert
    XCTAssertNotNil(code);
    XCTAssertTrue([[code code] isEqualToString:@"34133-9"]);
    XCTAssertTrue([[code codeSystem] isEqualToString:@"2.16.840.1.113883.6.1"]);
    XCTAssertTrue([[code codeSystemName] isEqualToString:@"LOINC"]);
    XCTAssertTrue([[code displayName] isEqualToString:@"Summarization of Episode Note"]);
}

- (void)testCodeFromReaderWithOriginalText
{
    NSString *xml = @"<code code=\"3\" displayName=\"s\" codeSystem=\"2\" "
                    @"codeSystemName=\"L\">"
                    @"<originalText>"
                    @"<reference value=\"v\"/>"
                    @"</originalText>"
                    @"</code>";
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];

    // execute
    HL7Code *code = [HL7ElementParser codeFromReader:[reader nextObject]];

    // assert
    XCTAssertNotNil(code);
    XCTAssertNotNil([code originalTextElement]);
    XCTAssertNotNil([[code originalTextElement] referenceValue]);
    XCTAssertTrue([[code code] isEqualToString:@"3"]);
    XCTAssertTrue([[code codeSystem] isEqualToString:@"2"]);
    XCTAssertTrue([[code codeSystemName] isEqualToString:@"L"]);
    XCTAssertTrue([[code displayName] isEqualToString:@"s"]);
    XCTAssertTrue([[[code originalTextElement] referenceValue] isEqualToString:@"v"]);
}

- (void)testCodeFromReaderWithTranslation
{
    NSString *xml = @"<code code=\"3\" displayName=\"s\" codeSystem=\"2\" "
                    @"codeSystemName=\"L\">"
                    @"<originalText>"
                    @"<reference value=\"v\"/>"
                    @"</originalText>"
                    @"<translation code=\"4\" displayName=\"dt\" "
                    @"codeSystem=\"3\" codeSystemName=\"M\"/>"
                    @"</code>";
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];

    // execute
    HL7Code *code = [HL7ElementParser codeFromReader:[reader nextObject]];

    // assert
    XCTAssertNotNil(code);
    XCTAssertNotNil([code originalTextElement]);
    XCTAssertNotNil([code translation]);
    XCTAssertNotNil([[code originalTextElement] referenceValue]);
    XCTAssertTrue([[code code] isEqualToString:@"3"]);
    XCTAssertTrue([[code codeSystem] isEqualToString:@"2"]);
    XCTAssertTrue([[code codeSystemName] isEqualToString:@"L"]);
    XCTAssertTrue([[code displayName] isEqualToString:@"s"]);
    XCTAssertTrue([[[code originalTextElement] referenceValue] isEqualToString:@"v"]);
    XCTAssertTrue([[[code translation] code] isEqualToString:@"4"]);
    XCTAssertTrue([[[code translation] displayName] isEqualToString:@"dt"]);
    XCTAssertTrue([[[code translation] codeSystem] isEqualToString:@"3"]);
    XCTAssertTrue([[[code translation] codeSystemName] isEqualToString:@"M"]);
}

- (void)testCodeFromReaderEmpty
{
    NSString *xml = @"<code/>";
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];

    // execute
    HL7Code *code = [HL7ElementParser codeFromReader:[reader nextObject]];

    // assert
    XCTAssertNotNil(code);
    XCTAssertNil([code code]);
    XCTAssertNil([code codeSystem]);
    XCTAssertNil([code codeSystemName]);
}
@end
