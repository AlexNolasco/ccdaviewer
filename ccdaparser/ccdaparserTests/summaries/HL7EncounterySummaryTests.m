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
#import "HL7CodeSummary.h"
#import "HL7Const.h"
#import "HL7Enums.h"
#import "HL7EncounterAnalyzer.h"
#import "HL7EncounterSummary.h"
#import "HL7EncounterSummaryEntry.h"
#import "NSDate+Additions.h"

@interface HL7EncounterySummaryTests : XCTestCase <HL7CCDParserDelegateProtocol>

@end

@implementation HL7EncounterySummaryTests

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
    [mapper enableParsers:[[NSSet alloc] initWithArray:@[ HL7TemplateEncounters ]]];
}


- (void)testBlueButton
{
    HL7CCDParser *parser = [HL7CCDParser new];
    NSError *error;
    [parser setDelegate:self];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:@"bluebutton" ofType:@"xml"];
    HL7CCD *ccd = [parser parseXMLFilePath:resource error:&error];
    HL7EncounterAnalyzer *analyzer = [[HL7EncounterAnalyzer alloc] init];
    HL7EncounterSummaryEntry *entry;

    // execute
    HL7EncounterSummary *summary = (HL7EncounterSummary *)[analyzer analyzeSectionUsingDocument:ccd];

    // assert
    XCTAssertNotNil(summary);
    XCTAssertEqual([[summary allEntries] count], 1);
    XCTAssertTrue([[summary title] isEqualToString:@"ENCOUNTERS"]);
    entry = [summary allEntries][0];
    XCTAssertTrue([[entry date] isEqualToISO8601String:@"20120806"]);
    XCTAssertTrue([[entry narrative] isEqualToString:@"Pnuemonia"]);
}

- (void)testHl7Final
{
    HL7CCDParser *parser = [HL7CCDParser new];
    NSError *error;
    [parser setDelegate:self];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:@"hl7final" ofType:@"xml"];
    HL7CCD *ccd = [parser parseXMLFilePath:resource error:&error];
    HL7EncounterAnalyzer *analyzer = [[HL7EncounterAnalyzer alloc] init];
    HL7EncounterSummaryEntry *entry;

    // execute
    HL7EncounterSummary *summary = (HL7EncounterSummary *)[analyzer analyzeSectionUsingDocument:ccd];

    // assert
    XCTAssertNotNil(summary);
    XCTAssertEqual([[summary allEntries] count], 1);
    entry = [summary allEntries][0];
    XCTAssertTrue([[entry date] isEqualToISO8601String:@"201208151000-0800"]);
    XCTAssertTrue([[entry narrative] isEqualToString:@"Costal Chondritis"]);
}

- (void)testHl7cdar2
{
    HL7CCDParser *parser = [HL7CCDParser new];
    NSError *error;
    [parser setDelegate:self];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:@"hl7cdar2" ofType:@"xml"];
    HL7CCD *ccd = [parser parseXMLFilePath:resource error:&error];
    HL7EncounterAnalyzer *analyzer = [[HL7EncounterAnalyzer alloc] init];
    HL7EncounterSummaryEntry *entry;

    // execute
    HL7EncounterSummary *summary = (HL7EncounterSummary *)[analyzer analyzeSectionUsingDocument:ccd];

    // assert
    XCTAssertNotNil(summary);
    XCTAssertEqual([[summary allEntries] count], 1);
    entry = [summary allEntries][0];
    XCTAssertTrue([[entry date] isEqualToISO8601String:@"201209271300+0500"]);
    XCTAssertTrue([[entry narrative] isEqualToString:@"Pneumonia"]);
}
@end
