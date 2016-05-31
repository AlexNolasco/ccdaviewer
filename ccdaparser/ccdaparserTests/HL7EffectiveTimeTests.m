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
#import "HL7EffectiveTime.h"
#import "HL7EffectiveTimeElement.h"
#import "HL7ElementParser+Additions.h"
#import "HL7Period.h"
#import "HL7Time.h"
#import "IGXMLReader+Additions.h"
#import "IGXMLReader.h"


@interface HL7EffectiveTimeTests : XCTestCase

@end

@implementation HL7EffectiveTimeTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testTimeSuccess
{
    NSString *xml = @"<time value=\"20110203\"/>";
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];

    // execute
    HL7Time *time = [HL7ElementParser timeFromReader:[reader nextObject]];

    // assert
    XCTAssertNotNil(time);
    XCTAssertTrue([[time value] isEqualToString:@"20110203"]);
}

- (void)testTimeNullFlavor
{
    NSString *xml = @"<time nullFlavor=\"UNK\"/>";
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];

    // execute
    HL7Time *time = [HL7ElementParser timeFromReader:[reader nextObject]];

    // assert
    XCTAssertNotNil(time);
    XCTAssertTrue([[time nullFlavor] isEqualToString:@"UNK"]);
}

- (void)testEffectiveTimeSuccess
{
    NSString *xml = @"<effectiveTime value=\"20110203\">"
                     "<low value=\"19690102\" nullFlavor=\"1\"/>"
                     "<high value=\"19730102\" nullFlavor=\"2\"/>"
                     "</effectiveTime>";
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];
    HL7EffectiveTime *effectiveTime;

    // execute
    effectiveTime = [HL7ElementParser effectiveTimeFromReader:reader];

    // assert
    XCTAssertNotNil(effectiveTime);
    XCTAssertTrue([[[effectiveTime low] value] isEqualToString:@"19690102"]);
    XCTAssertTrue([[[effectiveTime high] value] isEqualToString:@"19730102"]);
    XCTAssertTrue([[[effectiveTime low] nullFlavor] isEqualToString:@"1"]);
    XCTAssertTrue([[[effectiveTime high] nullFlavor] isEqualToString:@"2"]);
    XCTAssertTrue([[effectiveTime value] isEqualToString:@"20110203"]);
    XCTAssertEqual([effectiveTime xsiTimeInterval], HL7XSITimeIntervalsUnknown);
}

- (void)testPeriod
{
    NSString *xml = @"<effectiveTime xsi:type=\"PIVL_TS\" "
                    @"institutionSpecified=\"true\" operator=\"A\">"
                     "<period value=\"12\" unit=\"h\"/>"
                     "</effectiveTime>";

    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];
    HL7EffectiveTime *effectiveTime;

    // execute
    effectiveTime = [HL7ElementParser effectiveTimeFromReader:reader];

    // assert
    XCTAssertNotNil(effectiveTime);
    XCTAssertTrue([[[effectiveTime period] value] isEqualToString:@"12"]);
    XCTAssertTrue([[[effectiveTime period] unit] isEqualToString:@"h"]);
    XCTAssertEqual([effectiveTime xsiTimeInterval], HL7XSITimeIntervalsPeriodicTimeInterval);
}

- (void)testEmpty
{
    NSString *xml = @"<effectiveTime/>";
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];
    HL7EffectiveTime *effectiveTime;

    // execute
    effectiveTime = [HL7ElementParser effectiveTimeFromReader:reader];

    // assert
    XCTAssertNotNil(effectiveTime);
    XCTAssertNotNil([effectiveTime low]);
    XCTAssertNotNil([effectiveTime high]);
    XCTAssertNil([[effectiveTime low] value]);
    XCTAssertNil([[effectiveTime high] value]);
    XCTAssertNil([effectiveTime value]);
}

@end
