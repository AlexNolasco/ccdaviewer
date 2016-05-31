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
#import "HL7CCDParserDelegateProtocol.h"
#import "HL7Code.h"
#import "HL7Const.h"
#import "HL7Entry.h"
#import "HL7Enums.h"
#import "HL7EncounterSection.h"
#import "HL7EncounterEntry.h"
#import "HL7EncounterActivity.h"
#import "HL7EncounterDiagnosis.h"
#import "HL7IndicationObservation.h"
#import "HL7Value.h"
#import "HL7Code.h"

@interface HL7EncountersSectionParserTests : XCTestCase <HL7CCDParserDelegateProtocol>

@end

@implementation HL7EncountersSectionParserTests

- (void)willParseSectionsWithMapping:(id<HL7SectionMapperProtocol>)mapper
{
    [mapper enableParsers:[[NSSet alloc] initWithArray:@[ HL7TemplateEncounters ]]];
}

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testBluebutton
{
    HL7CCDParser *parser = [HL7CCDParser new];
    NSError *error;
    [parser setDelegate:self];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:@"bluebutton" ofType:@"xml"];
    HL7EncounterEntry *entry;
    HL7EncounterActivity *encounterActivity;

    // execute
    HL7CCD *ccd = [parser parseXMLFilePath:resource error:&error];

    // assert
    HL7EncounterSection *section = (HL7EncounterSection *)[ccd getSectionByTemplateId:HL7TemplateEncounters];
    XCTAssertNil(error);
    XCTAssertNotNil(ccd);
    XCTAssertNotNil(section);
    XCTAssertTrue([[section title] isEqualToString:@"ENCOUNTERS"]);
    XCTAssertEqual([[section entries] count], 1);
    entry = [section entries][0];
    XCTAssertNotNil([entry encounterActivity]);
    XCTAssertEqual([[[entry encounterActivity] descendants] count], 2);
    encounterActivity = [entry encounterActivity];
    XCTAssertNotNil([encounterActivity indicationObservation]);
    XCTAssertNotNil([encounterActivity encounterDiagnosis]);
    XCTAssertTrue([[[[encounterActivity indicationObservation] value] displayName] isEqualToString:@"Pnuemonia"]);
    XCTAssertTrue([[[[encounterActivity encounterDiagnosis] code] displayName] isEqualToString:@"ENCOUNTER DIAGNOSIS"]);
}
@end
