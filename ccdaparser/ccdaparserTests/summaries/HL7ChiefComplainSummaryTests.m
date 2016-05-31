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


#import <ccdaparser/ccdaparser.h>
#import "HL7CCD.h"
#import "HL7CCDParser.h"
#import "HL7CCDParserDelegateProtocol.h"
#import "HL7ChiefComplainAnalyzer.h"
#import "HL7ChiefComplainSummary.h"
#import "HL7ChiefComplainSummaryEntry.h"
#import "HL7Const.h"
#import <XCTest/XCTest.h>

@interface HL7ChiefComplainSummaryTests : XCTestCase <HL7CCDParserDelegateProtocol>

@end

@implementation HL7ChiefComplainSummaryTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

#pragma mark -

- (void)willParseSectionsWithMapping:(id<HL7SectionMapperProtocol>)mapper
{
    [mapper enableParsers:[[NSSet alloc] initWithArray:@[ HL7TemplateChiefComplainAndReasonForVisit ]]];
}

- (void)testCCDNextGen
{
    HL7CCDParser *parser = [HL7CCDParser new];
    NSError *error;
    [parser setDelegate:self];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:@"hl7procedurenotechiefcomplain" ofType:@"xml"];
    HL7CCD *ccd = [parser parseXMLFilePath:resource error:&error];
    HL7ChiefComplainAnalyzer *analyzer = [[HL7ChiefComplainAnalyzer alloc] init];

    // execute
    HL7ChiefComplainSummary *summary = (HL7ChiefComplainSummary *)[analyzer analyzeSectionUsingDocument:ccd];

    // assert
    XCTAssertNotNil(summary);
    XCTAssertNotNil([summary allEntries]);
    XCTAssertEqual([[summary allEntries] count], 1);
    HL7ChiefComplainSummaryEntry *entry = [[summary allEntries] firstObject];
    XCTAssertTrue([[entry reasonHtml] isEqualToString:@"<p><p xmlns=\"urn:hl7-org:v3\">Dark stools.</p></p>"]);
    XCTAssertTrue([[entry reasonPlainText] isEqualToString:@"Dark stools."]);
}

@end
