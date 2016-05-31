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
#import "HL7Enums.h"
#import "HL7PlanOfCareAnalyzer.h"
#import "HL7PlanOfCareSummary.h"
#import "HL7PlanOfCareSummaryEntry.h"
#import "NSDate+Additions.h"


@interface HL7PlanOfCareSummaryTests : XCTestCase <HL7CCDParserDelegateProtocol>
@end

@implementation HL7PlanOfCareSummaryTests

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
    [mapper enableParsers:[[NSSet alloc] initWithArray:@[ HL7TemplatePlanOfCare ]]];
}

- (void)testhl7Final
{
    HL7CCDParser *parser = [HL7CCDParser new];
    NSError *error;
    [parser setDelegate:self];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:@"hl7final" ofType:@"xml"];
    HL7CCD *ccd = [parser parseXMLFilePath:resource error:&error];
    HL7PlanOfCareAnalyzer *analyzer = [[HL7PlanOfCareAnalyzer alloc] init];
    HL7PlanOfCareSummaryEntry *summaryEntry;

    // execute
    HL7PlanOfCareSummary *summary = (HL7PlanOfCareSummary *)[analyzer analyzeSectionUsingDocument:ccd];

    // assert
    XCTAssertNotNil(summary);
    XCTAssertTrue([[summary sectionTitle] isEqualToString:@"Plan of Care"]);
    XCTAssertEqual([[summary allEntries] count], 3);
    summaryEntry = [summary allEntries][0];
    XCTAssertEqual([summaryEntry moodCode], HL7MoodCodeGol);
    XCTAssertTrue([[summaryEntry narrative] isEqualToString:@"Weight Loss"]);
    XCTAssertTrue([[summaryEntry date] isEqualToISO8601String:@"201208151000-0800"]);
    summaryEntry = [summary allEntries][1];
    XCTAssertEqual([summaryEntry moodCode], HL7MoodCodeInt);
    XCTAssertTrue([[summaryEntry narrative] isEqualToString:@"Asthma management"]);
    XCTAssertTrue([[summaryEntry date] isEqualToISO8601String:@"201208151000-0800"]);
    summaryEntry = [summary allEntries][2];
    XCTAssertEqual([summaryEntry moodCode], HL7MoodCodeInt);
    XCTAssertTrue([[summaryEntry narrative] isEqualToString:@"Pulmonary Function Tests; Dr. Penny Puffer, Tel: "
                                                            @"555-555-1049, 1047 Healthcare Drive, Portland OR "
                                                            @"97005"]);
    XCTAssertTrue([[summaryEntry date] isEqualToISO8601String:@"20120817"]);
}

- (void)testBlueButton
{
    HL7CCDParser *parser = [HL7CCDParser new];
    NSError *error;
    [parser setDelegate:self];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:@"bluebutton" ofType:@"xml"];
    HL7CCD *ccd = [parser parseXMLFilePath:resource error:&error];
    HL7PlanOfCareAnalyzer *analyzer = [[HL7PlanOfCareAnalyzer alloc] init];

    // execute
    HL7PlanOfCareSummary *summary = (HL7PlanOfCareSummary *)[analyzer analyzeSectionUsingDocument:ccd];

    // assert
    XCTAssertNotNil(summary);
    XCTAssertTrue([[summary sectionTitle] isEqualToString:@"CARE PLAN"]);
    XCTAssertEqual([[summary allEntries] count], 3);
}

@end
