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
#import "HL7Code.h"
#import "HL7Const.h"
#import "HL7Entry.h"
#import "HL7Enums.h"
#import "HL7ProblemConcernAct.h"
#import "HL7ProblemEntry.h"
#import "HL7ProblemEntryRelationship.h"
#import "HL7ProblemObservation.h"
#import "HL7ProblemSection.h"
#import "HL7ProblemSectionParser.h"
#import "HL7StatusCode.h"
#import <XCTest/XCTest.h>

@interface HL7ProblemsSectionParserTests : XCTestCase <HL7CCDParserDelegateProtocol>

@end

@implementation HL7ProblemsSectionParserTests

- (void)willParseSectionsWithMapping:(id<HL7SectionMapperProtocol>)mapper
{
    [mapper enableParsers:[[NSSet alloc] initWithArray:@[ HL7TemplateProblems ]]];
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

- (void)testblueButton
{
    HL7CCDParser *parser = [HL7CCDParser new];
    NSError *error;
    [parser setDelegate:self];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:@"bluebutton" ofType:@"xml"];
    HL7ProblemEntry *entry;

    // execute
    HL7CCD *ccd = [parser parseXMLFilePath:resource error:&error];

    // assert
    HL7ProblemSection *section = (HL7ProblemSection *)[ccd getSectionByTemplateId:HL7TemplateProblems];
    XCTAssertNil(error);
    XCTAssertNotNil(ccd);
    XCTAssertNotNil(section);
    XCTAssertTrue([[section title] isEqualToString:@"PROBLEMS"]);
    XCTAssertEqual([[section entries] count], 2);
    entry = [section entries][0];
    XCTAssertNotNil([entry problemConcernAct]);
    XCTAssertEqual([[[entry problemConcernAct] descendants] count], 1);
    XCTAssertNotNil([[entry problemConcernAct] ageObservation]);
    XCTAssertNotNil([[entry problemConcernAct] problemStatus]);
    XCTAssertNotNil([[entry problemConcernAct] healthStatusObservation]);
    XCTAssertNotNil([[entry problemConcernAct] statusObservation]);
    XCTAssertTrue([[[[[entry problemConcernAct] statusObservation] code] code] isEqualToString:@"33999-4"]);
    entry = [section entries][1];
    XCTAssertNotNil([entry problemConcernAct]);
    XCTAssertEqual([[[entry problemConcernAct] descendants] count], 1);
    XCTAssertNotNil([[entry problemConcernAct] ageObservation]);
    XCTAssertNotNil([[entry problemConcernAct] problemStatus]);
    XCTAssertNotNil([[entry problemConcernAct] healthStatusObservation]);
    XCTAssertNotNil([[entry problemConcernAct] statusObservation]);
    XCTAssertTrue([[[[[entry problemConcernAct] statusObservation] code] code] isEqualToString:@"33999-4"]);
}

- (void)testhl7final
{
    HL7CCDParser *parser = [HL7CCDParser new];
    NSError *error;
    [parser setDelegate:self];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:@"hl7final" ofType:@"xml"];
    HL7ProblemEntry *entry;

    // execute
    HL7CCD *ccd = [parser parseXMLFilePath:resource error:&error];

    // assert
    HL7ProblemSection *section = (HL7ProblemSection *)[ccd getSectionByTemplateId:HL7TemplateProblems];
    XCTAssertNil(error);
    XCTAssertNotNil(ccd);
    XCTAssertNotNil(section);
    XCTAssertTrue([[section title] isEqualToString:@"Problem List"]);
    XCTAssertEqual([[section entries] count], 2);
    entry = [section entries][0];
    XCTAssertNotNil([entry problemConcernAct]);
    XCTAssertTrue([[[entry problemConcernAct] statusCode] isActive]);
    XCTAssertNotNil([[entry problemConcernAct] problemObservation]);
    XCTAssertNil([[entry problemConcernAct] ageObservation]);
    XCTAssertNil([[entry problemConcernAct] problemStatus]);
    XCTAssertNil([[entry problemConcernAct] healthStatusObservation]);
    XCTAssertNil([[entry problemConcernAct] statusObservation]);
}
@end
