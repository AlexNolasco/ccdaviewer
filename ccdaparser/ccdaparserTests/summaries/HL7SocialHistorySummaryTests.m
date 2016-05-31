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
#import "HL7SocialHistoryAnalyzer.h"
#import "HL7SocialHistorySummary.h"
#import "HL7SocialHistorySummaryEntry.h"
#import "NSDate+Additions.h"


@interface HL7SocialHistorySummaryTests : XCTestCase <HL7CCDParserDelegateProtocol>

@end

@implementation HL7SocialHistorySummaryTests

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
    [mapper enableParsers:[[NSSet alloc] initWithArray:@[ HL7TemplateSocialHistory ]]];
}

- (void)testPatient124
{
    HL7CCDParser *parser = [HL7CCDParser new];
    NSError *error;
    [parser setDelegate:self];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:@"patient124" ofType:@"xml"];
    HL7CCD *ccd = [parser parseXMLFilePath:resource error:&error];
    HL7SocialHistoryAnalyzer *analyzer = [[HL7SocialHistoryAnalyzer alloc] init];

    // execute
    HL7SocialHistorySummary *summary = (HL7SocialHistorySummary *)[analyzer analyzeSectionUsingDocument:ccd];

    // assert
    XCTAssertNotNil(summary);
    XCTAssertEqual([[summary allEntries] count], 2);
    XCTAssertNotNil([summary smokingStatusCode]);
}

- (void)testHl7cdar2
{
    HL7CCDParser *parser = [HL7CCDParser new];
    NSError *error;
    [parser setDelegate:self];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:@"hl7cdar2" ofType:@"xml"];
    HL7CCD *ccd = [parser parseXMLFilePath:resource error:&error];
    HL7SocialHistoryAnalyzer *analyzer = [[HL7SocialHistoryAnalyzer alloc] init];
    HL7SocialHistorySummaryEntry *entry;

    // execute
    HL7SocialHistorySummary *summary = (HL7SocialHistorySummary *)[analyzer analyzeSectionUsingDocument:ccd];

    // assert
    XCTAssertNotNil(summary);
    XCTAssertEqual([[summary allEntries] count], 3);
    entry = [[summary allEntries] objectAtIndex:0];
    XCTAssertNotNil([entry codeSummary]);
    XCTAssertNotNil([entry dateRange]);
    XCTAssertNil([entry quantityNarrative]);
    XCTAssertEqual([entry dataType], HL7XSITypeCodedConcept);
    XCTAssertEqual([[[entry dateRange] start] timeIntervalSinceReferenceDate], [[NSDate fromISO8601String:@"20120910"] timeIntervalSinceReferenceDate]);
    XCTAssertNil([[entry dateRange] end]);
    XCTAssertTrue([[[entry codeSummary] displayName] isEqualToString:@"Tobacco smoking status NHIS"]);
    XCTAssertTrue([[entry narrative] isEqualToString:@"Former smoker"]);
    XCTAssertNotNil([summary smokingStatusCode]);
}

- (void)testHl7ProcedureNote
{
    HL7CCDParser *parser = [HL7CCDParser new];
    NSError *error;
    [parser setDelegate:self];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:@"hl7procedurenote" ofType:@"xml"];
    HL7CCD *ccd = [parser parseXMLFilePath:resource error:&error];
    HL7SocialHistoryAnalyzer *analyzer = [[HL7SocialHistoryAnalyzer alloc] init];
    HL7SocialHistorySummaryEntry *entry;

    // execute
    HL7SocialHistorySummary *summary = (HL7SocialHistorySummary *)[analyzer analyzeSectionUsingDocument:ccd];

    // assert
    XCTAssertNotNil(summary);
    XCTAssertEqual([[summary allEntries] count], 3);
    entry = [[summary allEntries] objectAtIndex:0];
    XCTAssertNotNil([entry codeSummary]);
    XCTAssertNotNil([entry dateRange]);
    XCTAssertNotNil([entry quantityNarrative]);
    XCTAssertEqual([entry dataType], HL7XSITypeStructuredText);
    XCTAssertEqual([[[entry dateRange] start] timeIntervalSinceReferenceDate], [[NSDate fromISO8601String:@"1947"] timeIntervalSinceReferenceDate]);
    XCTAssertEqual([[[entry dateRange] end] timeIntervalSinceReferenceDate], [[NSDate fromISO8601String:@"1972"] timeIntervalSinceReferenceDate]);
    XCTAssertTrue([[[entry codeSummary] displayName] isEqualToString:@"Cigarette smoking"]);
    XCTAssertTrue([[entry quantityNarrative] isEqualToString:@"1 pack per day"]);

    entry = [[summary allEntries] objectAtIndex:1];
    XCTAssertNotNil([entry codeSummary]);
    XCTAssertNotNil([entry dateRange]);
    XCTAssertNotNil([entry quantityNarrative]);
    XCTAssertEqual([entry dataType], HL7XSITypeStructuredText);
    XCTAssertEqual([[[entry dateRange] start] timeIntervalSinceReferenceDate], [[NSDate fromISO8601String:@"1973"] timeIntervalSinceReferenceDate]);
    XCTAssertNil([[entry dateRange] end]);
    XCTAssertTrue([[[entry codeSummary] displayName] isEqualToString:@"Cigarette smoking"]);
    XCTAssertTrue([[entry quantityNarrative] isEqualToString:@"None"]);

    entry = [[summary allEntries] objectAtIndex:2];
    XCTAssertNotNil([entry codeSummary]);
    XCTAssertNotNil([entry dateRange]);
    XCTAssertNotNil([entry quantityNarrative]);
    XCTAssertEqual([entry dataType], HL7XSITypeStructuredText);
    XCTAssertEqual([[[entry dateRange] start] timeIntervalSinceReferenceDate], [[NSDate fromISO8601String:@"1973"] timeIntervalSinceReferenceDate]);
    XCTAssertNil([[entry dateRange] end]);
    XCTAssertTrue([[[entry codeSummary] displayName] isEqualToString:@"Alcohol consumption"]);
    XCTAssertTrue([[entry quantityNarrative] isEqualToString:@"None"]);
    XCTAssertNil([summary smokingStatusCode]);
}
@end
