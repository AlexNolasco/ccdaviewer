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
#import "HL7Act.h"
#import "HL7CCD.h"
#import "HL7CCDParser.h"
#import "HL7CCDParserDelegateProtocol.h"
#import "HL7Const.h"
#import "HL7EffectiveTime.h"
#import "HL7EffectiveTimeElement.h"
#import "HL7Element+Additions.h"
#import "HL7Entry.h"
#import "HL7Enums.h"
#import "HL7PatientInstructionsEntry.h"
#import "HL7PatientInstructionsSection.h"
#import "HL7Text.h"


@interface HL7PatientInstructionsSectionParserTests : XCTestCase <HL7CCDParserDelegateProtocol>

@end

@implementation HL7PatientInstructionsSectionParserTests

#pragma mark -

- (void)willParseSectionsWithMapping:(id<HL7SectionMapperProtocol>)mapper
{
    [mapper enableParsers:[[NSSet alloc] initWithArray:@[ HL7TemplatePatientInstructions ]]];
}

#pragma mark -

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testBlueButton
{
    HL7CCDParser *parser = [HL7CCDParser new];
    NSError *error;
    [parser setDelegate:self];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:@"bluebutton" ofType:@"xml"];
    HL7PatientInstructionsEntry *entry;

    // execute
    HL7CCD *ccd = [parser parseXMLFilePath:resource error:&error];

    // assert
    HL7PatientInstructionsSection *section = (HL7PatientInstructionsSection *)[ccd getSectionByTemplateId:HL7TemplatePatientInstructions];
    XCTAssertNil(error);
    XCTAssertNotNil(ccd);
    XCTAssertNotNil(section);
    XCTAssertTrue([[section title] isEqualToString:@"Instructions"]);
    XCTAssertEqual([[section entries] count], 2);
    entry = [section entries][0];
    XCTAssertNotNil([entry act]);
    XCTAssertTrue([[[entry act] classCode] isEqualToString:@"ACT"]);
    XCTAssertTrue([[[entry act] moodCode] isEqualToString:@"INT"]);
    XCTAssertTrue([[entry act] hl7MoodCode] == HL7MoodCodeInt);
    XCTAssertTrue([[[[entry act] text] text] isEqualToString:@"diet and exercise counseling provided during visit"]);
    XCTAssertNotNil([[entry act] effectiveTime]);
    XCTAssertNotNil([[[entry act] effectiveTime] low]);
    XCTAssertNotNil([[[entry act] effectiveTime] high]);
    entry = [section entries][1];
    XCTAssertNotNil([entry act]);
    XCTAssertTrue([[[[entry act] text] text] isEqualToString:@"resources and instructions provided during visit"]);
}

- (void)testhl7final
{
    HL7CCDParser *parser = [HL7CCDParser new];
    NSError *error;
    [parser setDelegate:self];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:@"hl7final" ofType:@"xml"];

    // execute
    HL7CCD *ccd = [parser parseXMLFilePath:resource error:&error];

    // assert
    HL7PatientInstructionsSection *section = (HL7PatientInstructionsSection *)[ccd getSectionByTemplateId:HL7TemplatePatientInstructions];
    XCTAssertNil(error);
    XCTAssertNotNil(ccd);
    XCTAssertNil(section);
}
@end
