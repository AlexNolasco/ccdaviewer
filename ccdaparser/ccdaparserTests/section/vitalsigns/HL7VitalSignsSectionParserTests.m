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
#import "HL7VitalSignsEntry.h"
#import "HL7VitalSignsObservation.h"
#import "HL7VitalSignsOrganizer_Private.h"
#import "HL7VitalSignsSection.h"
#import "IGXMLReader+Additions.h"
#import "IGXMLReader.h"
#import "ParserContext.h"
#import "ParserPlan.h"
#import <XCTest/XCTest.h>

@interface HL7VitalSignsSectionParserTests : XCTestCase <HL7CCDParserDelegateProtocol>
@end

@implementation HL7VitalSignsSectionParserTests

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

#pragma mark -
- (void)testEmerge
{
    HL7CCDParser *parser = [HL7CCDParser new];
    NSError *error;
    [parser setDelegate:self];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:@"emerge" ofType:@"xml"];

    // execute
    HL7CCD *ccd = [parser parseXMLFilePath:resource error:&error];

    // assert
    HL7VitalSignsSection *vitalSignsSection = (HL7VitalSignsSection *)[ccd getSectionByTemplateId:HL7TemplateVitalSignsEntriesRequired];

    XCTAssertNil(error);
    XCTAssertNotNil(ccd);
    XCTAssertNotNil(vitalSignsSection);
    XCTAssertEqual([[vitalSignsSection entries] count], 3);
}

- (void)testHl7cdar2
{
    HL7CCDParser *parser = [HL7CCDParser new];
    NSError *error;
    [parser setDelegate:self];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:@"hl7cdar2" ofType:@"xml"];
    HL7VitalSignsEntry *entry;

    // execute
    HL7CCD *ccd = [parser parseXMLFilePath:resource error:&error];

    // assert
    HL7VitalSignsSection *vitalSignsSection = (HL7VitalSignsSection *)[ccd getSectionByTemplateId:HL7TemplateVitalSignsEntriesRequired];

    XCTAssertNil(error);
    XCTAssertNotNil(ccd);
    XCTAssertNotNil(vitalSignsSection);
    XCTAssertEqual([[vitalSignsSection entries] count], 2);
    entry = [vitalSignsSection entries][0];
    XCTAssertEqual([[[entry organizer] observations] count], 4);
    XCTAssertTrue([[[entry organizer] classCode] isEqualToString:@"CLUSTER"]);
    XCTAssertTrue([[[entry organizer] moodCode] isEqualToString:@"EVN"]);
    XCTAssertTrue([[[[entry organizer] weight] classCode] isEqualToString:@"OBS"]);
    XCTAssertTrue([[[[entry organizer] weight] moodCode] isEqualToString:@"EVN"]);
    entry = [vitalSignsSection entries][1];
    XCTAssertEqual([[[entry organizer] observations] count], 4);
    XCTAssertTrue([[[entry organizer] classCode] isEqualToString:@"CLUSTER"]);
    XCTAssertTrue([[[entry organizer] moodCode] isEqualToString:@"EVN"]);
    XCTAssertTrue([[[[entry organizer] weight] classCode] isEqualToString:@"OBS"]);
    XCTAssertTrue([[[[entry organizer] weight] moodCode] isEqualToString:@"EVN"]);
}

- (void)testFinal
{
    HL7CCDParser *parser = [HL7CCDParser new];
    NSError *error;
    [parser setDelegate:self];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:@"hl7final" ofType:@"xml"];

    // execute
    HL7CCD *ccd = [parser parseXMLFilePath:resource error:&error];

    // assert
    HL7VitalSignsSection *section = (HL7VitalSignsSection *)[ccd getSectionByTemplateId:HL7TemplateVitalSignsEntriesRequired];

    XCTAssertNil(error);
    XCTAssertNotNil(ccd);
    XCTAssertNotNil(section);
    XCTAssertEqual([[section entries] count], 1);
    HL7VitalSignsEntry *entry = [[section entries] firstObject];
    XCTAssertEqual([[[entry organizer] observations] count], 5);
}
@end
