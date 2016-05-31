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
#import "HL7ElementParser+Additions.h"
#import "HL7Text+Additions.h"
#import "HL7Text.h"
#import "IGXMLReader+Additions.h"
#import "IGXMLReader.h"


@interface HL7TextFromReaderTests : XCTestCase
@end

@implementation HL7TextFromReaderTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testHtml
{
    NSString *xml = @"<text>"
                    @"<table border=\"1\" width=\"100%\">"
                    @"<thead>"
                    @"<tr>"
                    @"<td>"
                    @"<th align=\"left\">Weight</th>"
                    @"<td ID=\"vit3\">86 kg</td>"
                    @"<td ID=\"vit4\">88 kg</td>"
                    @"</td>"
                    @"</tr>"
                    @"</thead>"
                    @"</table>"
                     "</text>";

    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];
    HL7Text *text;

    // execute
    text = [HL7ElementParser textFromReader:reader];

    // assert
    XCTAssertNotNil(text);
    XCTAssertTrue([[text text] length] > 0);
    XCTAssertTrue([[text identifiers] count] == 2);
    XCTAssertTrue([text isHtml]);
    XCTAssertTrue([[[text identifiers] objectForKey:@"vit3"] isEqualToString:@"86 kg"]);
    XCTAssertTrue([[[text identifiers] objectForKey:@"vit4"] isEqualToString:@"88 kg"]);
}

- (void)testHtmlEmpty
{
    NSString *xml = @"<text>"
                    @"<ul/>"
                     "</text>";

    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];
    HL7Text *text;

    // execute
    text = [HL7ElementParser textFromReader:reader];

    // assert
    XCTAssertNotNil(text);
    XCTAssertTrue([[text innerXML] length] > 0);
    XCTAssertTrue([[text text] length] == 0);
    XCTAssertTrue([text isHtml]);
}

- (void)testEmpty
{
    NSString *xml = @"<text/>";
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];
    HL7Text *text;

    // execute
    text = [HL7ElementParser textFromReader:reader];

    // assert
    XCTAssertNotNil(text);
    XCTAssertFalse([text isHtml]);
    XCTAssertTrue([[text text] length] == 0);
    XCTAssertTrue([[text identifiers] count] == 0);
    XCTAssertTrue([[text references] count] == 0);
}

- (void)testParagraph
{
    NSString *xml = @"<text><paragraph>Dark stools.</paragraph></text>";
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];
    HL7Text *text;

    // execute
    text = [HL7ElementParser textFromReader:reader];

    // assert
    XCTAssertNotNil(text);
    XCTAssertTrue([text isHtml]);
    XCTAssertTrue([[text innerXML] isEqualToString:@"<paragraph>Dark stools.</paragraph>"]);
    XCTAssertTrue([[text text] isEqualToString:@"Dark stools."]);
    XCTAssertTrue([[text identifiers] count] == 0);
    XCTAssertTrue([[text references] count] == 0);
}

- (void)testCustomHtml
{
    NSString *xml = @"<text>"
                    @"<content styleCode=\"Bold\">This is rendered bold,"
                    @"<content styleCode=\"Italics\">"
                    @"This is rendered bold and italicized"
                    @"</content>"
                    @"this is again rendered bold"
                    @"</content>"
                    @"<content styleCode=\"Bold Italics\">"
                    @"This is also bold and italicized"
                    @"</content>"
                    @"</text>";
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];
    HL7Text *text;

    // execute
    text = [HL7ElementParser textFromReader:reader];

    // assert
    XCTAssertNotNil(text);
    XCTAssertTrue([text isHtml]);
    XCTAssertTrue([[text text] isEqualToString:@"This is rendered bold,This is rendered bold and "
                                               @"italicizedthis is again rendered boldThis is also "
                                               @"bold and italicized"]);
}

- (void)testToHtmlWithStyle
{
    NSString *xml = @"<text>"
                    @"<content styleCode=\"Bold\">This is rendered bold,"
                    @"<content styleCode=\"Italics\">"
                    @"This is rendered bold and italicized"
                    @"</content>"
                    @"this is again rendered bold"
                    @"</content>"
                    @"<content styleCode=\"Bold Italics\">"
                    @"This is also bold and italicized"
                    @"</content>"
                    @"</text>";
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];
    HL7Text *text;

    // execute
    text = [HL7ElementParser textFromReader:reader];
    NSString *html = [text toHtml];

    // assert
    XCTAssertNotNil(html);
    XCTAssertTrue([html isEqualToString:@"<p><span style=\"font-weight:bold\">This is rendered "
                                        @"bold,<span style=\"font-style:italic\">This is "
                                        @"rendered bold and italicized</span>this is again "
                                        @"rendered bold</span><span "
                                        @"style=\"font-weight:bold;font-style:italic\">This is "
                                        @"also bold and italicized</span></p>"]);
}

- (void)testPlainText
{
    NSString *xml = @"<text>Ipsum lipsum</text>";
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];
    HL7Text *text;

    // execute
    text = [HL7ElementParser textFromReader:reader];

    // assert
    XCTAssertNotNil(text);
    XCTAssertFalse([text isHtml]);
    XCTAssertTrue([[text text] isEqualToString:@"Ipsum lipsum"]);
    XCTAssertTrue([[text identifiers] count] == 0);
    XCTAssertTrue([[text references] count] == 0);
}

- (void)testReference
{
    NSString *xml = @"<text><reference value=\"#result3\"/></text>";
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];
    HL7Text *text;

    // execute
    text = [HL7ElementParser textFromReader:reader];

    // assert
    XCTAssertNotNil(text);
    XCTAssertFalse([text isHtml]);
    XCTAssertTrue([[text text] length] == 0);
    XCTAssertTrue([[text innerXML] isEqualToString:@"<reference value=\"#result3\"/>"]);
    XCTAssertTrue([[text identifiers] count] == 0);
    XCTAssertTrue([[text references] count] == 1);
}
@end
