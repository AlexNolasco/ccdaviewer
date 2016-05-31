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
#import "HL7VitalSignsAnalyzer.h"
#import "HL7VitalSignsSummary.h"
#import "HL7VitalSignsSummaryEntry.h"
#import "HL7VitalsignsSummaryItem.h"
#import "NSDate+Additions.h"

@interface HL7VitalSignsSummaryTests : XCTestCase <HL7CCDParserDelegateProtocol>
@end

@implementation HL7VitalSignsSummaryTests

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
    [mapper enableParsers:[[NSSet alloc] initWithArray:@[ HL7TemplateVitalSignsEntriesRequired ]]];
}

- (void)testPatient124
{
    HL7CCDParser *parser = [HL7CCDParser new];
    NSError *error;
    [parser setDelegate:self];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:@"patient124" ofType:@"xml"];
    HL7CCD *ccd = [parser parseXMLFilePath:resource error:&error];
    HL7VitalSignsAnalyzer *analyzer = [[HL7VitalSignsAnalyzer alloc] init];

    // execute
    HL7VitalSignsSummary *summary = (HL7VitalSignsSummary *)[analyzer analyzeSectionUsingDocument:ccd];

    // assert
    XCTAssertNotNil(summary);
    XCTAssertTrue([[summary sectionTitle] isEqualToString:@"Vital Signs"]);
    XCTAssertEqual([[summary allEntries] count], 1);
    HL7VitalSignsSummaryEntry *entry = [summary allEntries][0];
    XCTAssertNotNil([entry bmi]);
    XCTAssertNil([entry heartRate]);
    XCTAssertNil([entry weight]);
    XCTAssertNil([entry height]);
    XCTAssertNil([entry bpDiastolic]);
    XCTAssertNil([entry bpSystolic]);
    XCTAssertNotNil([summary mostRecentEntry]);
}

- (void)testHl7cdar2
{
    HL7CCDParser *parser = [HL7CCDParser new];
    NSError *error;
    [parser setDelegate:self];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:@"vitera" ofType:@"xml"];
    HL7CCD *ccd = [parser parseXMLFilePath:resource error:&error];
    HL7VitalSignsAnalyzer *analyzer = [[HL7VitalSignsAnalyzer alloc] init];

    // execute
    HL7VitalSignsSummary *summary = (HL7VitalSignsSummary *)[analyzer analyzeSectionUsingDocument:ccd];

    // assert
    XCTAssertNotNil(summary);
    XCTAssertTrue([[summary sectionTitle] isEqualToString:@"Vital Signs"]);
    XCTAssertEqual([[summary allEntries] count], 3);
    HL7VitalSignsSummaryEntry *recent = [summary mostRecentEntry];
    XCTAssertNotNil(recent);
    XCTAssertTrue([[recent organizerEffectiveTime] isEqualToISO8601String:@"20071102100700-0400"]);
}


@end
