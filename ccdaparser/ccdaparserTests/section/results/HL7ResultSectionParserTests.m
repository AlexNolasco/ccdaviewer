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
#import "HL7Const.h"
#import "HL7Entry.h"
#import "HL7Enums.h"
#import "HL7PhysicalQuantityInterval.h"
#import "HL7ResultEntry.h"
#import "HL7ResultObservation.h"
#import "HL7ResultObservationRange.h"
#import "HL7ResultOrganizer.h"
#import "HL7ResultReferenceRange.h"
#import "HL7ResultSection.h"
#import "HL7Value.h"

@interface HL7ResultSectionParserTests : XCTestCase <HL7CCDParserDelegateProtocol>
@end

@implementation HL7ResultSectionParserTests

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
    [mapper enableParsers:[[NSSet alloc] initWithArray:@[ HL7TemplateResultsEntriesRequired ]]];
}

#pragma mark -
- (void)testHl7cdar2
{
    HL7CCDParser *parser = [HL7CCDParser new];
    NSError *error;
    [parser setDelegate:self];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:@"hl7cdar2" ofType:@"xml"];
    HL7ResultEntry *entry;
    HL7ResultObservation *observation;
    HL7ResultReferenceRange *referenceRange;

    // execute
    HL7CCD *ccd = [parser parseXMLFilePath:resource error:&error];

    // assert
    HL7ResultSection *section = (HL7ResultSection *)[ccd getSectionByTemplateId:HL7TemplateResultsEntriesRequired];
    XCTAssertNil(error);
    XCTAssertNotNil(ccd);
    XCTAssertNotNil(section);
    XCTAssertTrue([[section title] isEqualToString:@"RESULTS"]);
    XCTAssertEqual([[section entries] count], 2);
    entry = [section entries][0];
    XCTAssertNotNil([entry organizer]);
    XCTAssertEqual([[[entry organizer] observations] count], 5);
    observation = [[entry organizer] observations][0];
    XCTAssertTrue([[observation classCode] isEqualToString:@"OBS"]);
    XCTAssertTrue([[observation moodCode] isEqualToString:@"EVN"]);
    XCTAssertTrue([[observation referenceRanges] count] == 1);
    XCTAssertTrue([[[observation value] value] isEqualToString:@"13.2"]);
    XCTAssertTrue([[[observation value] unit] isEqualToString:@"g/dL"]);
    referenceRange = [observation referenceRanges][0];
    XCTAssertNotNil(referenceRange);
    XCTAssertNotNil([referenceRange observationRange]);
    XCTAssertTrue([[[[[referenceRange observationRange] value] low] value] isEqualToString:@"12.0"]);
    XCTAssertTrue([[[[[referenceRange observationRange] value] low] unit] isEqualToString:@"g/dL"]);
    XCTAssertTrue([[[[[referenceRange observationRange] value] high] value] isEqualToString:@"15.5"]);
    XCTAssertTrue([[[[[referenceRange observationRange] value] high] unit] isEqualToString:@"g/dL"]);
    XCTAssertTrue([[observation interpretationCodes] count] == 1);
}
@end
