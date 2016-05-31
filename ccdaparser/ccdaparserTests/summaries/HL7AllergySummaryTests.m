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
#import "HL7AllergyAnalyzer.h"
#import "HL7AllergyConcernAct.h"
#import "HL7AllergyReactionSummary.h"
#import "HL7AllergySection.h"
#import "HL7AllergySummary.h"
#import "HL7AllergySummaryEntry.h"
#import "HL7CCD.h"
#import "HL7CCDParser.h"
#import "HL7CCDParserDelegateProtocol.h"
#import "HL7CodeSummary_Private.h"
#import "HL7Const.h"
#import "HL7Observation.h"
#import "HL7Enums.h"
#import "NSDate+Additions.h"
#import <XCTest/XCTest.h>

@interface HL7AllergySummaryTests : XCTestCase <HL7CCDParserDelegateProtocol>
@end

@implementation HL7AllergySummaryTests

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
    [mapper enableParsers:[[NSSet alloc] initWithArray:@[ HL7TemplateAllergySectionEntriesRequired ]]];
}

#pragma mark -
- (NSString *)summaryToXml:(HL7AllergySummary *)summary
{
    NSMutableData *archiveData = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:archiveData];
    archiver.outputFormat = NSPropertyListXMLFormat_v1_0;
    [archiver encodeRootObject:summary];
    [archiver finishEncoding];
    return [[NSString alloc] initWithData:archiveData encoding:NSASCIIStringEncoding];
}

- (void)testCCDNextGen
{
    HL7CCDParser *parser = [HL7CCDParser new];
    NSError *error;
    [parser setDelegate:self];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:@"nextgen" ofType:@"xml"];
    HL7CCD *ccd = [parser parseXMLFilePath:resource error:&error];
    HL7AllergyAnalyzer *analyzer = [[HL7AllergyAnalyzer alloc] init];

    // execute
    HL7AllergySummary *summary = (HL7AllergySummary *)[analyzer analyzeSectionUsingDocument:ccd];

    // assert
    XCTAssertNotNil(summary);
    XCTAssertFalse([summary noKnownMedicationAllergiesFound]);
    XCTAssertFalse([summary noKnownAllergiesFound]);
    XCTAssertEqual([[summary allEntries] count], 3);
    XCTAssertTrue([[[[summary allEntries] objectAtIndex:1] allergen] isEqualToString:@"Aspirin"]);
    XCTAssertTrue([[[[summary allEntries] objectAtIndex:2] allergen] isEqualToString:@"penicillin G benzathine"]);
    XCTAssertTrue([[[[summary allEntries] objectAtIndex:0] firstReaction] isEqualToString:@"Shortness of Breath"]);
    XCTAssertTrue([[[[summary allEntries] objectAtIndex:1] firstReaction] isEqualToString:@"Hives"]);
    XCTAssertTrue([[[[summary allEntries] objectAtIndex:2] firstReaction] isEqualToString:@"Hives"]);
    XCTAssertTrue([[[[summary allEntries] objectAtIndex:0] dateOfOnset] isEqualToDate:[NSDate fromISO8601String:@"20100806"]]);
    XCTAssertTrue([[[[summary allEntries] objectAtIndex:1] dateOfOnset] isEqualToDate:[NSDate fromISO8601String:@"20110806"]]);
    XCTAssertTrue([[[[summary allEntries] objectAtIndex:2] dateOfOnset] isEqualToDate:[NSDate fromISO8601String:@"20130806"]]);
    XCTAssertTrue([[[[summary allEntries] objectAtIndex:0] status] isEqualToString:@"active"]);
    XCTAssertTrue([[[[summary allEntries] objectAtIndex:1] status] isEqualToString:@"active"]);
    XCTAssertTrue([[[[summary allEntries] objectAtIndex:2] status] isEqualToString:@"active"]);
    XCTAssertNil([[[summary allEntries] objectAtIndex:0] severity]);
    XCTAssertNil([[[summary allEntries] objectAtIndex:1] severity]);
    XCTAssertNil([[[summary allEntries] objectAtIndex:2] severity]);
}

- (void)testHL7Final
{
    HL7CCDParser *parser = [HL7CCDParser new];
    NSError *error;
    [parser setDelegate:self];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:@"hl7final" ofType:@"xml"];
    HL7CCD *ccd = [parser parseXMLFilePath:resource error:&error];
    HL7AllergyAnalyzer *analyzer = [[HL7AllergyAnalyzer alloc] init];

    // execute
    HL7AllergySummary *summary = (HL7AllergySummary *)[analyzer analyzeSectionUsingDocument:ccd];

    // assert
    XCTAssertNotNil(summary);
    XCTAssertFalse([summary noKnownMedicationAllergiesFound]);
    XCTAssertFalse([summary noKnownAllergiesFound]);
    XCTAssertEqual([[summary allEntries] count], 2);
    XCTAssertTrue([[[[summary allEntries] objectAtIndex:0] allergen] isEqualToString:@"Penicillin G benzathine"]);
    XCTAssertTrue([[[[summary allEntries] objectAtIndex:1] allergen] isEqualToString:@"Codeine"]);
    XCTAssertTrue([[[[summary allEntries] objectAtIndex:0] firstReaction] isEqualToString:@"Hives"]);
    XCTAssertTrue([[[[summary allEntries] objectAtIndex:1] firstReaction] isEqualToString:@"Nausea"]);
    XCTAssertNil([[[summary allEntries] objectAtIndex:0] status]);
    XCTAssertNil([[[summary allEntries] objectAtIndex:1] status]);
    XCTAssertNil([[[summary allEntries] objectAtIndex:0] severity]);
    XCTAssertNil([[[summary allEntries] objectAtIndex:1] severity]);
}

- (void)testCarePlan
{
    HL7CCDParser *parser = [HL7CCDParser new];
    NSError *error;
    [parser setDelegate:self];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:@"hl7careplan" ofType:@"xml"];
    HL7CCD *ccd = [parser parseXMLFilePath:resource error:&error];
    HL7AllergyAnalyzer *analyzer = [[HL7AllergyAnalyzer alloc] init];

    // execute
    HL7AllergySummary *summary = (HL7AllergySummary *)[analyzer analyzeSectionUsingDocument:ccd];

    // assert
    XCTAssertNotNil(summary);
    XCTAssertFalse([summary noKnownMedicationAllergiesFound]);
    XCTAssertFalse([summary noKnownAllergiesFound]);
    XCTAssertEqual([[summary allEntries] count], 0);
}

- (void)testNoAllergies
{
    HL7CCDParser *parser = [HL7CCDParser new];
    NSError *error;
    [parser setDelegate:self];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:@"noallergies" ofType:@"xml"];
    HL7CCD *ccd = [parser parseXMLFilePath:resource error:&error];
    HL7AllergyAnalyzer *analyzer = [[HL7AllergyAnalyzer alloc] init];

    // execute
    HL7AllergySummary *summary = (HL7AllergySummary *)[analyzer analyzeSectionUsingDocument:ccd];

    // assert
    XCTAssertNotNil(summary);
    XCTAssertFalse([summary noKnownMedicationAllergiesFound]);
    XCTAssertTrue([summary noKnownAllergiesFound]);
    XCTAssertEqual([[summary allEntries] count], 0);
}

- (void)testHL7CDAR2
{
    HL7CCDParser *parser = [HL7CCDParser new];
    NSError *error;
    [parser setDelegate:self];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:@"hl7cdar2" ofType:@"xml"];
    HL7CCD *ccd = [parser parseXMLFilePath:resource error:&error];
    HL7AllergyAnalyzer *analyzer = [[HL7AllergyAnalyzer alloc] init];

    // execute
    HL7AllergySummary *summary = (HL7AllergySummary *)[analyzer analyzeSectionUsingDocument:ccd];

    // assert
    XCTAssertNotNil(summary);
    XCTAssertFalse([summary noKnownMedicationAllergiesFound]);
    XCTAssertFalse([summary noKnownAllergiesFound]);
    XCTAssertEqual([[summary allEntries] count], 2);
    XCTAssertTrue([[[[summary allEntries] objectAtIndex:0] allergen] isEqualToString:@"Penicillin"]);
    XCTAssertTrue([[[[[summary allEntries] objectAtIndex:0] allergenCode] code] isEqualToString:@"70618"]);
    XCTAssertTrue([[[[summary allEntries] objectAtIndex:0] firstReaction] isEqualToString:@"Nausea"]);
    XCTAssertTrue([[[[[summary allEntries] objectAtIndex:0] reactionCode] code] isEqualToString:@"422587007"]);
    XCTAssertNil([[[summary allEntries] objectAtIndex:0] status]);
    XCTAssertTrue([[[[summary allEntries] objectAtIndex:0] severity] isEqualToString:@"Moderate to severe"]);
    XCTAssertTrue([[[[summary allEntries] objectAtIndex:0] allReactions] count] == 1);
    XCTAssertEqual([[[summary allEntries] objectAtIndex:0] problemSeverityCode], HL7ProblemSeverityCodeModerateToSevere);

    XCTAssertNotNil([[[summary allEntries] objectAtIndex:0] allergenCode]);
    XCTAssertNotNil([[[summary allEntries] objectAtIndex:0] allergenValue]);
    XCTAssertTrue([[[[[summary allEntries] objectAtIndex:0] allergenValue] code] isEqualToString:@"419199007"]);
    XCTAssertNotNil([[[summary allEntries] objectAtIndex:0] reactionCode]);
    XCTAssertNotNil([[[summary allEntries] objectAtIndex:0] statusCode]);
    XCTAssertNotNil([[[summary allEntries] objectAtIndex:0] severityCode]);
    XCTAssertTrue([[[[[summary allEntries] objectAtIndex:0] severityCode] code] isEqualToString:@"371924009"]);
    XCTAssertNotNil([[[[[summary allEntries] objectAtIndex:0] allReactions] objectAtIndex:0] reactionCode]);
    XCTAssertNil([[[[[summary allEntries] objectAtIndex:0] allReactions] objectAtIndex:0] statusCode]);
    XCTAssertNotNil([[[[[summary allEntries] objectAtIndex:0] allReactions] objectAtIndex:0] severityCode]);

    XCTAssertTrue([[[[summary allEntries] objectAtIndex:1] allergen] isEqualToString:@"Codeine"]);
    XCTAssertTrue([[[[[summary allEntries] objectAtIndex:1] allergenCode] code] isEqualToString:@"2670"]);
    XCTAssertTrue([[[[summary allEntries] objectAtIndex:1] firstReaction] isEqualToString:@"Wheezing"]);
    XCTAssertTrue([[[[[summary allEntries] objectAtIndex:1] reactionCode] code] isEqualToString:@"56018004"]);
    XCTAssertNil([[[summary allEntries] objectAtIndex:1] status]);
    XCTAssertTrue([[[[summary allEntries] objectAtIndex:1] severity] isEqualToString:@"Mild"]);
    XCTAssertNotNil([[[summary allEntries] objectAtIndex:1] allergenCode]);
    XCTAssertNotNil([[[summary allEntries] objectAtIndex:1] allergenValue]);
    XCTAssertTrue([[[[[summary allEntries] objectAtIndex:1] allergenValue] code] isEqualToString:@"419199007"]);
    XCTAssertNotNil([[[summary allEntries] objectAtIndex:1] reactionCode]);
    XCTAssertNotNil([[[summary allEntries] objectAtIndex:1] statusCode]);
    XCTAssertNotNil([[[summary allEntries] objectAtIndex:1] severityCode]);
    XCTAssertTrue([[[[summary allEntries] objectAtIndex:1] allReactions] count] == 1);
    XCTAssertNotNil([[[[[summary allEntries] objectAtIndex:1] allReactions] objectAtIndex:0] reactionCode]);
    XCTAssertNil([[[[[summary allEntries] objectAtIndex:1] allReactions] objectAtIndex:0] statusCode]);
    XCTAssertNotNil([[[[[summary allEntries] objectAtIndex:1] allReactions] objectAtIndex:0] severityCode]);
}

@end
