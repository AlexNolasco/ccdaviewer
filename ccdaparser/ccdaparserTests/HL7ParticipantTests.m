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
#import "HL7Code.h"
#import "HL7EffectiveTime.h"
#import "HL7ElementParser+Additions.h"
#import "HL7OriginalText.h"
#import "HL7Participant.h"
#import "HL7ParticipantRole.h"
#import "HL7PlayingEntity.h"
#import "IGXMLReader+Additions.h"
#import "IGXMLReader.h"

@interface HL7ParticipantTests : XCTestCase

@end

@implementation HL7ParticipantTests

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
    NSString *xml = @"<participant/>";
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];

    // execute
    HL7Participant *participant = [HL7ElementParser participantFromReader:[reader nextObject]];

    // assert
    XCTAssertNotNil(participant);
}

- (void)testSuccess
{
    NSString *xml = @"<participant typeCode=\"CSM\">"
                    @"<time nullFlavor=\"UNK\" />"
                    @"<participantRole>"
                    @"<addr nullFlavor=\"UNK\" />"
                    @"<telecom use=\"\" nullFlavor=\"UNK\" />"
                    @"<playingEntity classCode=\"MMAT\" determinerCode=\"INSTANCE\">"
                    @"<code code=\"2\" displayName=\"B\" codeSystem=\"2\" "
                    @"codeSystemName=\"R\">"
                    @"<originalText>"
                    @"<reference value=\"#\" />"
                    @"</originalText>"
                    @"<translation code=\"3\" displayName=\"p\" codeSystem=\"2\" "
                    @"codeSystemName=\"F\" />"
                    @"</code>"
                    @"<name>penicillin</name>"
                    @"</playingEntity>"
                    @"</participantRole>"
                    @"</participant>";
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];

    // execute
    HL7Participant *participant = [HL7ElementParser participantFromReader:reader];

    // assert
    XCTAssertNotNil(participant);
    XCTAssertNotNil([participant participantRole]);
    XCTAssertNotNil([[participant participantRole] telecoms]);
    XCTAssertTrue([[[participant participantRole] telecoms] count] == 1);
    XCTAssertNotNil([[participant participantRole] addresses]);
    XCTAssertTrue([[[participant participantRole] addresses] count] == 1);
    XCTAssertNotNil([[participant participantRole] playingEntity]);
    XCTAssertNotNil([[[participant participantRole] playingEntity] code]);
    XCTAssertNotNil([[[participant participantRole] playingEntity] name]);
    XCTAssertNotNil([[[participant participantRole] playingEntity] determinerCode]);
    XCTAssertNotNil([[[participant participantRole] playingEntity] classCode]);
    XCTAssertNotNil([[[participant participantRole] playingEntity] determinerCode]);
    XCTAssertNotNil([[[participant participantRole] playingEntity] code]);
    XCTAssertNotNil([[[[participant participantRole] playingEntity] code] originalTextElement]);
    XCTAssertNotNil([[[[[participant participantRole] playingEntity] code] originalTextElement] referenceValue]);
    XCTAssertNotNil([[[[participant participantRole] playingEntity] code] translation]);
    XCTAssertTrue([[[[[participant participantRole] playingEntity] name] name] isEqualToString:@"penicillin"]);
}

@end
