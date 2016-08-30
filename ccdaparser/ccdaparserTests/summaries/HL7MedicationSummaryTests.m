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


#import "HL7CCD.h"
#import "HL7CCDParser.h"
#import "HL7CCDParserDelegateProtocol.h"
#import "HL7Const.h"
#import "HL7MedicationAnalyzer.h"
#import "HL7MedicationSummary.h"
#import "HL7MedicationSummaryEntry.h"
#import "NSDate+Additions.h"
#import <XCTest/XCTest.h>
#import <ccdaparser/ccdaparser.h>


@interface HL7MedicationSummaryTests : XCTestCase <HL7CCDParserDelegateProtocol>

@end

@implementation HL7MedicationSummaryTests

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
    [mapper enableParsers:[[NSSet alloc] initWithArray:@[ HL7TemplateMedications ]]];
}

- (void)testNoMedication
{
    HL7CCDParser *parser = [HL7CCDParser new];
    NSError *error;
    [parser setDelegate:self];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:@"patient124" ofType:@"xml"];
    HL7CCD *ccd = [parser parseXMLFilePath:resource error:&error];
    HL7MedicationAnalyzer *analyzer = [[HL7MedicationAnalyzer alloc] init];

    // execute
    HL7MedicationSummary *summary = (HL7MedicationSummary *)[analyzer analyzeSectionUsingDocument:ccd];

    // assert
    XCTAssertNotNil(summary);
    XCTAssertTrue([[summary title] isEqualToString:@"Medications"]);
    XCTAssertEqual([[summary allEntries] count], 0);
}

- (void)testSuccess
{
    HL7CCDParser *parser = [HL7CCDParser new];
    NSError *error;
    [parser setDelegate:self];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:@"hl7cdar2" ofType:@"xml"];
    HL7CCD *ccd = [parser parseXMLFilePath:resource error:&error];
    HL7MedicationAnalyzer *analyzer = [[HL7MedicationAnalyzer alloc] init];
    HL7MedicationSummaryEntry *summaryEntry;

    // execute
    HL7MedicationSummary *summary = (HL7MedicationSummary *)[analyzer analyzeSectionUsingDocument:ccd];

    // assert
    XCTAssertNotNil(summary);
    XCTAssertTrue([[summary title] isEqualToString:@"MEDICATIONS"]);
    XCTAssertEqual([[summary allEntries] count], 2);
    summaryEntry = [summary allEntries][0];
    XCTAssertTrue([[summaryEntry narrative] isEqualToString:@"Proventil 0.09 MG/ACTUAT inhalant solution"]);
    XCTAssertTrue([[[summaryEntry effectiveTime] start] isEqualToISO8601String:@"20110103"]);
    XCTAssertTrue([summaryEntry active]);
    XCTAssertFalse([summaryEntry statusIsUnknown]);
    XCTAssertTrue([[summaryEntry periodValue] isEqualToString:@"6"]);
    XCTAssertTrue([[summaryEntry periodUnit] isEqualToString:@"h"]);
    summaryEntry = [summary allEntries][1];
    XCTAssertTrue([[summaryEntry narrative] isEqualToString:@"Atenolol 25 MG Oral Tablet"]);
    XCTAssertTrue([[[summaryEntry effectiveTime] start] isEqualToISO8601String:@"20120318"]);
    XCTAssertTrue([summaryEntry active]);
    XCTAssertTrue([[summaryEntry periodValue] isEqualToString:@"12"]);
    XCTAssertTrue([[summaryEntry periodUnit] isEqualToString:@"h"]);
}
@end
