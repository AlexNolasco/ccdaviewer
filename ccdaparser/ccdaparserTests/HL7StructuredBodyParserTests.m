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
#import "HL7ElementParser+Additions.h"
#import "HL7Name_Private.h"
#import "HL7Section.h"
#import "HL7SectionMapper.h"
#import "HL7StructuredBodyParser.h"
#import "HL7Text.h"
#import "IGXMLReader+Additions.h"
#import "IGXMLReader.h"
#import "ParserContext.h"

@interface HL7StructuredBodyParserTests : XCTestCase
@end

@implementation HL7StructuredBodyParserTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testUnmatchedSingleSection
{
    NSString *xml = @"<structuredBody>"
                    @"<component>"
                    @"<section>"
                    @"<templateId root=\"1\"/>"
                    @"<templateId root=\"2\"/>"
                    @"<title>1</title>"
                    @"<text>"
                    @"<li>"
                    @"</li>"
                    @"</text>"
                    @"</section>"
                    @"</component>"
                    @"</structuredBody>";
    NSError *error;
    HL7CCD *hl7ccd = [[HL7CCD alloc] init];
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];
    ParserContext *context = [[ParserContext alloc] initWithReader:reader hl7ccd:hl7ccd];
    HL7SectionMapper *mapper = [[HL7SectionMapper alloc] init];
    HL7StructuredBodyParser *parser = [[HL7StructuredBodyParser alloc] initWithMapper:mapper];

    // execute
    [parser parse:context error:&error];

    // assert
    XCTAssertTrue([[hl7ccd sections] count] == 1);
    HL7Section *section = [[hl7ccd sections] firstObject];
    XCTAssertTrue([[section firstTemplateId] isEqualToString:@"1"]);
    XCTAssertTrue([[section title] isEqualToString:@"1"]);
    XCTAssertTrue([[[section text] text] length] == 0);
    XCTAssertTrue([[section text] isHtml]);
}

- (void)testUnmatchedMultipleSection
{
    NSString *xml = @"<structuredBody>"
                    @"<component>"
                    @"<section>"
                    @"<templateId root=\"1\"/>"
                    @"<templateId root=\"1\"/>"
                    @"<title>1</title>"
                    @"<text>"
                    @"<li>"
                    @"</li>"
                    @"</text>"
                    @"</section>"
                    @"<section>"
                    @"<templateId root=\"2\"/>"
                    @"<templateId root=\"2\"/>"
                    @"<title>2</title>"
                    @"<text>"
                    @"<li>"
                    @"</li>"
                    @"</text>"
                    @"</section>"

                    @"</component>"
                    @"</structuredBody>";
    NSError *error;
    HL7CCD *hl7ccd = [[HL7CCD alloc] init];
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];
    ParserContext *context = [[ParserContext alloc] initWithReader:reader hl7ccd:hl7ccd];
    HL7SectionMapper *mapper = [[HL7SectionMapper alloc] init];
    HL7StructuredBodyParser *parser = [[HL7StructuredBodyParser alloc] initWithMapper:mapper];

    // execute
    [parser parse:context error:&error];

    // assert
    HL7Section *section;
    XCTAssertTrue([[hl7ccd sections] count] == 2);
    section = [[hl7ccd sections] objectAtIndex:0];
    XCTAssertTrue([[section firstTemplateId] isEqualToString:@"1"]);
    XCTAssertTrue([[section title] isEqualToString:@"1"]);
    section = [[hl7ccd sections] objectAtIndex:1];
    XCTAssertTrue([[section firstTemplateId] isEqualToString:@"2"]);
    XCTAssertTrue([[section title] isEqualToString:@"2"]);
}
@end
