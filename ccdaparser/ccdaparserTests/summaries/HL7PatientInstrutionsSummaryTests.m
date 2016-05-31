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
#import "HL7CodeSummary.h"
#import "HL7Const.h"
#import "HL7DateRange.h"
#import "HL7Enums.h"
#import "HL7PatientInstructionsSummary.h"
#import "HL7PatientInstructionsSummaryEntry.h"
#import "HL7PatientInstrutionsAnalyzer.h"
#import "NSDate+Additions.h"
#import <XCTest/XCTest.h>

@interface HL7PatientInstrutionsAnalyzerTests : XCTestCase <HL7CCDParserDelegateProtocol>

@end

@implementation HL7PatientInstrutionsAnalyzerTests

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
    [mapper enableParsers:[[NSSet alloc] initWithArray:@[ HL7TemplatePatientInstructions ]]];
}

- (void)testBlueButton
{
    HL7CCDParser *parser = [HL7CCDParser new];
    NSError *error;
    [parser setDelegate:self];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:@"bluebutton" ofType:@"xml"];
    HL7CCD *ccd = [parser parseXMLFilePath:resource error:&error];
    HL7PatientInstrutionsAnalyzer *analyzer = [[HL7PatientInstrutionsAnalyzer alloc] init];
    HL7PatientInstructionsSummaryEntry *entry;

    // execute
    HL7PatientInstructionsSummary *summary = (HL7PatientInstructionsSummary *)[analyzer analyzeSectionUsingDocument:ccd];

    // assert
    XCTAssertNotNil(summary);
    XCTAssertTrue([[summary sectionTitle] isEqualToString:@"Instructions"]);
    XCTAssertEqual([[summary allEntries] count], 2);
    entry = [summary allEntries][0];
    XCTAssertTrue([[entry narrative] isEqualToString:@"diet and exercise counseling provided during visit"]);
    XCTAssertTrue([[[entry effectiveTime] start] isEqualToISO8601String:@"20120813"]);
    XCTAssertTrue([[[entry effectiveTime] end] isEqualToISO8601String:@"20120813"]);
}
@end
