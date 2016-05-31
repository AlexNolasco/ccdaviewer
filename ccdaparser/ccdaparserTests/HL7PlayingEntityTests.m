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
#import "HL7ElementParser+Additions.h"
#import "HL7PlayingEntity.h"
#import "IGXMLReader+Additions.h"
#import "IGXMLReader.h"


@interface HL7PlayingEntityTests : XCTestCase

@end

@implementation HL7PlayingEntityTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{

    [super tearDown];
}

- (void)testEmpty
{
    NSString *xml = @"<playingEntity/>";
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];

    // execute
    HL7PlayingEntity *playingEntity = [HL7ElementParser playingEntityFromReader:reader];

    // assert
    XCTAssertNotNil(playingEntity);
}

- (void)testSuccess
{
    NSString *xml = @"<playingEntity classCode=\"MMAT\">"
                    @"<code code=\"3\" displayName=\"d\" codeSystem=\"2\" "
                    @"codeSystemName=\"L\"/>"
                    @"<name>medicine</name>"
                     "</playingEntity>";
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];

    // execute
    HL7PlayingEntity *playingEntity = [HL7ElementParser playingEntityFromReader:reader];

    // assert
    XCTAssertNotNil(playingEntity);
    XCTAssertNotNil([playingEntity code]);
    XCTAssertNotNil([playingEntity name]);
    XCTAssertTrue([[playingEntity classCode] isEqualToString:@"MMAT"]);
    XCTAssertTrue([[[playingEntity name] name] isEqualToString:@"medicine"]);
}

@end
