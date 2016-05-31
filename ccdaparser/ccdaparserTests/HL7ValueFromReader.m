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
#import "HL7PhysicalQuantityInterval.h"
#import "HL7Value.h"
#import "IGXMLReader+Additions.h"
#import "IGXMLReader.h"


@interface HL7ValueFromReader : XCTestCase

@end

@implementation HL7ValueFromReader

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testHasReferenceId
{
    NSString *xml = @"<value xsi:type=\"CD\" code=\"4\" displayName=\"a\" "
                    @"codeSystem=\"2\" codeSystemName=\"S\">"
                    @"<originalText>"
                    @"<reference value=\"#ID\"/>"
                    @"</originalText>"
                    @"</value>";

    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];
    HL7Value *code = [HL7ElementParser valueFromReader:[reader nextObject]];

    XCTAssertTrue([[code originalTextElement] hasReferenceId]);
}

- (void)testHasNoReferenceId
{
    NSString *xml = @"<value xsi:type=\"CD\" code=\"4\" displayName=\"a\" "
                    @"codeSystem=\"2\" codeSystemName=\"S\">"
                    @"<originalText>"
                    @"<reference value=\"#\"/>"
                    @"</originalText>"
                    @"</value>";

    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];
    HL7Value *code = [HL7ElementParser valueFromReader:[reader nextObject]];

    XCTAssertFalse([[code originalTextElement] hasReferenceId]);
}

- (void)testCodeFromReaderSuccess
{
    NSString *xml = @"<value xsi:type=\"CD\" code=\"419199007\" displayName=\"allergy\" "
                    @"codeSystem=\"2.16.840.1.113883.6.96\" codeSystemName=\"SNOMED CT\"/>";
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];

    HL7Value *code = [HL7ElementParser valueFromReader:[reader nextObject]];

    XCTAssertNotNil(code);
    XCTAssert([[code type] isEqualToString:@"CD"]);
    XCTAssert([[code code] isEqualToString:@"419199007"]);
    XCTAssert([[code codeSystem] isEqualToString:@"2.16.840.1.113883.6.96"]);
    XCTAssert([[code codeSystemName] isEqualToString:@"SNOMED CT"]);
    XCTAssert([[code displayName] isEqualToString:@"allergy"]);
    XCTAssertEqual([code xsiType], HL7XSITypeCodedConcept);
}

- (void)testValueValueUnit
{
    NSString *xml = @"<value xsi:type=\"PQ\" value=\"12\" unit=\"cm\"/>";
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];

    HL7Value *code = [HL7ElementParser valueFromReader:[reader nextObject]];

    XCTAssertNotNil(code);
    XCTAssert([[code type] isEqualToString:@"PQ"]);
    XCTAssert([[code value] isEqualToString:@"12"]);
    XCTAssert([[code unit] isEqualToString:@"cm"]);
    XCTAssertEqual([code xsiType], HL7XSITypePhysicalQuality);
}

- (void)testStructuredText
{
    NSString *xml = @"<value xsi:type=\"ST\">1 pack per day</value>";
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];

    HL7Value *code = [HL7ElementParser valueFromReader:[reader nextObject]];

    XCTAssertNotNil(code);
    XCTAssertEqual([code xsiType], HL7XSITypeStructuredText);
    XCTAssert([[code text] isEqualToString:@"1 pack per day"]);
}

- (void)testValueRange
{
    NSString *xml = @"<value xsi:type=\"IVL_PQ\">"
                    @"<low value=\"34.9\" unit=\"%\"/>"
                    @"<high value=\"44.5\" unit=\"cm\"/>"
                    @"</value>";
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];
    HL7Value *code = [HL7ElementParser valueFromReader:[reader nextObject]];

    XCTAssertNotNil(code);
    XCTAssert([[code type] isEqualToString:@"IVL_PQ"]);
    XCTAssert([[[code low] value] isEqualToString:@"34.9"]);
    XCTAssert([[[code low] unit] isEqualToString:@"%"]);
    XCTAssert([[[code high] value] isEqualToString:@"44.5"]);
    XCTAssert([[[code high] unit] isEqualToString:@"cm"]);
    XCTAssertEqual([code xsiType], HL7XSITypeQuantityRange);
}

- (void)testCodeFromReaderEmpty
{
    NSString *xml = @"<value/>";
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];
    HL7Value *code = [HL7ElementParser valueFromReader:[reader nextObject]];

    XCTAssertNotNil(code);
    XCTAssertNil([code code]);
    XCTAssertNil([code codeSystem]);
    XCTAssertNil([code codeSystemName]);
    XCTAssertEqual([code xsiType], HL7XSITypeUnknown);
}
@end
