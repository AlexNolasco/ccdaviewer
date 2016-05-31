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
#import "HL7CCD.h"
#import "HL7CCDParser.h"
#import "HL7CodeSummary.h"
#import "HL7Const.h"
#import "HL7DateRange.h"
#import "HL7Enums.h"
#import "HL7ProcedureSummary.h"
#import "HL7ProcedureAnalyzer.h"
#import "HL7ProcedureSummaryEntry.h"
#import "NSDate+Additions.h"

@interface HL7ProceduresSummaryTests : XCTestCase <HL7CCDParserDelegateProtocol>

@end

@implementation HL7ProceduresSummaryTests

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
    [mapper enableParsers:[[NSSet alloc] initWithArray:@[ HL7TemplateProcedures ]]];
}

- (void)testBlueButton
{
    HL7CCDParser *parser = [HL7CCDParser new];
    NSError *error;
    [parser setDelegate:self];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:@"bluebutton" ofType:@"xml"];
    HL7CCD *ccd = [parser parseXMLFilePath:resource error:&error];

    HL7ProcedureAnalyzer *analyzer = [[HL7ProcedureAnalyzer alloc] init];
    HL7ProcedureSummaryEntry *entry;

    // execute
    HL7ProcedureSummary *summary = (HL7ProcedureSummary *)[analyzer analyzeSectionUsingDocument:ccd];

    // assert
    XCTAssertNotNil(summary);
    XCTAssertEqual([[summary allEntries] count], 1);
    entry = [summary allEntries][0];
    XCTAssertTrue([[entry narrative] isEqualToString:@"Chest X-Ray"]);
    XCTAssertTrue([[entry date] isEqualToISO8601String:@"20120807"]);
}

@end
