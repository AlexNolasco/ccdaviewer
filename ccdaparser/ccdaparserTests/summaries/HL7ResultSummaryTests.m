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
#import "HL7CCDParser.h"
#import "HL7CCDParserDelegateProtocol.h"
#import "HL7CodeSummary.h"
#import "HL7Const.h"
#import "HL7ResultAnalyzer.h"
#import "HL7ResultSummary.h"
#import "HL7ResultSummaryEntry.h"
#import "NSDate+Additions.h"


@interface HL7ResultSummaryTests : XCTestCase <HL7CCDParserDelegateProtocol>

@end

@implementation HL7ResultSummaryTests

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
    [mapper enableParsers:[[NSSet alloc] initWithArray:@[ HL7TemplateResultsEntriesRequired ]]];
}

- (void)testSuccess
{
    HL7CCDParser *parser = [HL7CCDParser new];
    NSError *error;
    [parser setDelegate:self];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:@"hl7cdar2" ofType:@"xml"];
    HL7CCD *ccd = [parser parseXMLFilePath:resource error:&error];
    HL7ResultAnalyzer *analyzer = [[HL7ResultAnalyzer alloc] init];
    HL7ResultSummaryEntry *summaryEntry;

    // execute
    HL7ResultSummary *summary = (HL7ResultSummary *)[analyzer analyzeSectionUsingDocument:ccd];

    // assert
    XCTAssertNotNil(summary);
    XCTAssertTrue([[summary title] isEqualToString:@"RESULTS"]);
    XCTAssertEqual([[summary allEntries] count], 6);
    summaryEntry = [summary allEntries][0];
    XCTAssertTrue([[summaryEntry narrative] isEqualToString:@"Hemoglobin"]);
    XCTAssertTrue([[summaryEntry value] isEqualToString:@"13.2"]);
    XCTAssertTrue([[summaryEntry units] isEqualToString:@"g/dL"]);
    XCTAssertTrue([[summaryEntry range] isEqualToString:@"12.0 - 15.5 (g/dL)"]);
    XCTAssertTrue([[summaryEntry interpretation] isEqualToString:@"Normal"]);
    XCTAssertTrue([[summaryEntry date] isEqualToISO8601String:@"200803190830-0800"]);
}

@end
