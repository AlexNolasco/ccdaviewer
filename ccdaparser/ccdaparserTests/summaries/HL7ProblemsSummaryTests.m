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
#import "HL7Const.h"
#import "HL7ProblemAnalyzer.h"
#import "HL7ProblemSummary.h"
#import "HL7ProblemSummaryEntry.h"
#import "NSDate+Additions.h"

@interface HL7ProblemsSummaryTests : XCTestCase <HL7CCDParserDelegateProtocol>

@end

@implementation HL7ProblemsSummaryTests

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
    [mapper enableParsers:[[NSSet alloc] initWithArray:@[ HL7TemplateProblems ]]];
}

- (void)testBlueButton
{
    HL7CCDParser *parser = [HL7CCDParser new];
    NSError *error;
    [parser setDelegate:self];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:@"bluebutton" ofType:@"xml"];
    HL7CCD *ccd = [parser parseXMLFilePath:resource error:&error];
    HL7ProblemAnalyzer *analyzer = [[HL7ProblemAnalyzer alloc] init];
    HL7ProblemSummaryEntry *entry;

    // execute
    HL7ProblemSummary *summary = (HL7ProblemSummary *)[analyzer analyzeSectionUsingDocument:ccd];

    // assert
    XCTAssertNotNil(summary);
    XCTAssertEqual([[summary allEntries] count], 2);
    entry = [summary allEntries][0];
    XCTAssertNotNil(entry);
    XCTAssertTrue([[entry status] isEqualToString:@"Completed"]);
    XCTAssertTrue([[entry narrative] isEqualToString:@"Pneumonia"]);
    XCTAssertTrue([[[entry concernAuthored] start] isEqualToISO8601String:@"20120806"]);
    entry = [summary allEntries][1];
    XCTAssertNotNil(entry);
    XCTAssertTrue([[entry status] isEqualToString:@"Completed"]);
    XCTAssertTrue([[entry narrative] isEqualToString:@"Asthma"]);
}

- (void)testhl7Final
{
    HL7CCDParser *parser = [HL7CCDParser new];
    NSError *error;
    [parser setDelegate:self];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:@"hl7final" ofType:@"xml"];
    HL7CCD *ccd = [parser parseXMLFilePath:resource error:&error];
    HL7ProblemAnalyzer *analyzer = [[HL7ProblemAnalyzer alloc] init];
    HL7ProblemSummaryEntry *entry;

    // execute
    HL7ProblemSummary *summary = (HL7ProblemSummary *)[analyzer analyzeSectionUsingDocument:ccd];

    // assert
    XCTAssertNotNil(summary);
    XCTAssertEqual([[summary allEntries] count], 2);
    entry = [summary allEntries][0];
    XCTAssertNotNil(entry);
    XCTAssertTrue([[entry status] isEqualToString:@"Active"]);
    XCTAssertTrue([[entry narrative] isEqualToString:@"Costal Chondritis"]);
    XCTAssertTrue([[[entry biologicalOnSet] start] isEqualToISO8601String:@"20120815"]);
    entry = [summary allEntries][1];
    XCTAssertNotNil(entry);
    XCTAssertTrue([[entry status] isEqualToString:@"Active"]);
    XCTAssertTrue([[entry narrative] isEqualToString:@"Asthma"]);
    XCTAssertTrue([[[entry biologicalOnSet] start] isEqualToISO8601String:@"20110925"]);
}
@end
