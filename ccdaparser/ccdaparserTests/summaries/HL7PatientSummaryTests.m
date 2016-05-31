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
#import <XCTest/XCTest.h>
#import "HL7CCDParser.h"
#import "HL7CodeSummary.h"
#import "HL7Const.h"
#import "HL7GuardianSummary_Private.h"
#import "HL7Telecom_Private.h"
#import "HL7PatientRoleAnalyzer.h"
#import "HL7PatientSummary_Private.h"
#import "HL7Telecom_Private.h"
#import "NSDate+Additions.h"

@interface HL7PatientSummaryTests : XCTestCase <HL7CCDParserDelegateProtocol>

@end

@implementation HL7PatientSummaryTests

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
    [mapper enableParsers:nil];
}

- (void)willParseSection:(NSString *)templateId
{
    NSLog(@"parsing %@", templateId);
}

- (void)didFinishParsing:(NSError **)error
{
    NSLog(@"finished");
}

- (void)testCCDNextGen
{

    NSError *error;
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:@"nextgen" ofType:@"xml"];
    HL7PatientRoleAnalyzer *analyzer = [[HL7PatientRoleAnalyzer alloc] init];
    HL7CCDParser *parser = [HL7CCDParser new];
    [parser setDelegate:self];

    // execute
    HL7CCD *ccd = [parser parseXMLFilePath:resource error:&error];
    HL7PatientSummary *summary = (HL7PatientSummary *)[analyzer analyzeSectionUsingDocument:ccd];

    // assert
    XCTAssertNotNil(summary);
    XCTAssertFalse([summary isEmpty]);
    XCTAssertNotNil([summary name]);
    XCTAssertNotNil([summary names]);
    XCTAssertEqual([[summary names] count], 1);
    XCTAssertTrue([[[summary name] first] isEqualToString:@"Isabella"]);
    XCTAssertTrue([[[summary name] last] isEqualToString:@"Jones"]);
    XCTAssertTrue([[[summary name] use] isEqualToString:@"L"]);
    XCTAssertTrue([[[[[[summary names] objectAtIndex:0] given] objectAtIndex:0] qualifier] isEqualToString:@"CL"]);
    XCTAssertTrue([[[[[[summary names] objectAtIndex:0] family] objectAtIndex:0] qualifier] isEqualToString:@"BR"]);
    XCTAssertEqual([[summary telecoms] count], 1);
    XCTAssertTrue([[[[summary telecoms] objectAtIndex:0] value] isEqualToString:@"tel:+1-5554445555"]);
    XCTAssertTrue([[summary dob] isEqualToDate:[NSDate fromISO8601String:@"19470501"]]);
    XCTAssertEqual([summary genderCode], HL7AdministrativeGenderCodeFemale);
    XCTAssertEqual([[summary guardians] count], 0);
    XCTAssertEqual([summary maritalStatusCode], HL7MaritalStatusCodeUnknown);
}

- (void)testHL7CDAR2
{
    NSError *error;
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:@"hl7cdar2" ofType:@"xml"];
    HL7PatientRoleAnalyzer *analyzer = [[HL7PatientRoleAnalyzer alloc] init];
    HL7CCDParser *parser = [HL7CCDParser new];
    [parser setDelegate:self];

    // execute
    HL7CCD *ccd = [parser parseXMLFilePath:resource error:&error];
    HL7PatientSummary *summary = (HL7PatientSummary *)[analyzer analyzeSectionUsingDocument:ccd];

    // assert
    XCTAssertNotNil(summary);
    XCTAssertFalse([summary isEmpty]);
    XCTAssertNotNil([summary name]);
    XCTAssertNotNil([summary names]);
    XCTAssertEqual([[summary names] count], 1);
    XCTAssertTrue([[[summary name] first] isEqualToString:@"Eve"]);
    XCTAssertTrue([[[summary name] last] isEqualToString:@"Betterhalf"]);
    XCTAssertTrue([[[summary name] use] isEqualToString:@"L"]);
    XCTAssertNil([[[[[summary names] objectAtIndex:0] given] objectAtIndex:0] qualifier]);
    XCTAssertTrue([[[[[[summary names] objectAtIndex:0] family] objectAtIndex:0] qualifier] isEqualToString:@"SP"]);
    XCTAssertEqual([[summary telecoms] count], 1);
    XCTAssertTrue([[[[summary telecoms] objectAtIndex:0] value] isEqualToString:@"tel:+1(555)555-2003"]);
    XCTAssertTrue([[summary dob] isEqualToDate:[NSDate fromISO8601String:@"19750501"]]);
    XCTAssertEqual([summary genderCode], HL7AdministrativeGenderCodeFemale);
    XCTAssertEqual([[summary guardians] count], 1);
    HL7GuardianSummary *guardian = [summary guardians][0];
    XCTAssertTrue([[[guardian name] first] isEqualToString:@"Boris"]);
    XCTAssertTrue([[[guardian name] last] isEqualToString:@"Betterhalf"]);
    XCTAssertEqual([[guardian telecoms] count], 1);
    XCTAssertTrue([[[guardian code] code] isEqualToString:@"POWATT"]);
    XCTAssertTrue([[[[[[summary guardians] objectAtIndex:0] telecoms] objectAtIndex:0] value] isEqualToString:@"tel:+1(555)555-2008"]);
    XCTAssertEqual([summary maritalStatusCode], HL7MaritalStatusCodeMarried);
    XCTAssertTrue([[summary ethnicGroup] isEqualToString:@"Not Hispanic or Latino"]);
    XCTAssertTrue([[summary phoneNumber] isEqualToString:@"+1(555)555-2003"]);
    XCTAssertNil([summary emailAddress]);
}
@end
