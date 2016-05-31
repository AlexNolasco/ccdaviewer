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
#import "HL7Entry.h"
#import "HL7Enums.h"
#import "HL7PlanOfCareActivityAct.h"
#import "HL7PlanOfCareActivitySupply.h"
#import "HL7PlanOfCareEncounter.h"
#import "HL7PlanOfCareEntry.h"
#import "HL7PlanOfCareObservation.h"
#import "HL7PlanOfCareProcedure.h"
#import "HL7PlanOfCareSection.h"
#import "HL7PlanOfCareSubstanceAdministration.h"
#import <XCTest/XCTest.h>

@interface HL7PlanOfCareSectionParserTests : XCTestCase <HL7CCDParserDelegateProtocol>

@end

@implementation HL7PlanOfCareSectionParserTests

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

#pragma mark -

- (void)testhl7final
{
    HL7CCDParser *parser = [HL7CCDParser new];
    NSError *error;
    [parser setDelegate:self];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:@"hl7final" ofType:@"xml"];
    HL7PlanOfCareEntry *entry;
    HL7PlanOfCareObservation *observation;
    HL7PlanOfCareEncounter *encounter;

    // execute
    HL7CCD *ccd = [parser parseXMLFilePath:resource error:&error];

    // assert
    HL7PlanOfCareSection *section = (HL7PlanOfCareSection *)[ccd getSectionByTemplateId:HL7TemplatePlanOfCare];

    XCTAssertNil(error);
    XCTAssertNotNil(ccd);
    XCTAssertNotNil(section);
    XCTAssertEqual([[section entries] count], 3);
    entry = [section entries][0];
    XCTAssertNotNil([entry planOfCareActivity]);
    XCTAssertTrue([[entry planOfCareActivity] isKindOfClass:[HL7PlanOfCareObservation class]]);
    observation = (HL7PlanOfCareObservation *)[entry planOfCareActivity];
    XCTAssertTrue([[observation classCode] isEqualToString:@"OBS"]);
    XCTAssertTrue([[observation moodCode] isEqualToString:@"GOL"]);
    XCTAssertTrue([[observation firstTemplateId] isEqualToString:@"2.16.840.1.113883.10.20.22.4.44"]);
    XCTAssertNotNil([observation code]);
    XCTAssertNotNil([observation text]);
    XCTAssertNotNil([observation effectiveTime]);
    entry = [section entries][1];
    XCTAssertNotNil([entry planOfCareActivity]);
    XCTAssertTrue([[entry planOfCareActivity] isKindOfClass:[HL7PlanOfCareObservation class]]);
    entry = [section entries][2];
    XCTAssertNotNil([entry planOfCareActivity]);
    XCTAssertTrue([[entry planOfCareActivity] isKindOfClass:[HL7PlanOfCareEncounter class]]);
    encounter = (HL7PlanOfCareEncounter *)[entry planOfCareActivity];
    XCTAssertTrue([[encounter classCode] isEqualToString:@"ENC"]);
    XCTAssertTrue([[encounter moodCode] isEqualToString:@"INT"]);
}
@end
