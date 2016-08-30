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
#import "HL7SectionMapper.h"
#import "HL7SectionInfo.h"

@interface HL7SectionMapperTests : XCTestCase

@end

@implementation HL7SectionMapperTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testParserCount
{
    HL7SectionMapper *mapper = [[HL7SectionMapper alloc] init];

    // execute
    NSArray<HL7SectionInfo *> *parsers = [mapper availableParsers];

    // assert
    XCTAssertNotNil(parsers);
    XCTAssertEqual([parsers count], 11);
    for (HL7SectionInfo *info in parsers) {
        XCTAssertTrue([[info name] length] > 0);
        XCTAssertTrue([[info templateId] length] > 0);
    }
}

- (void)testMapper
{
    HL7SectionMapper *mapper = [[HL7SectionMapper alloc] init];

    // execute
    NSMutableDictionary *parsers = [mapper parsers];

    // assert
    XCTAssertNotNil(parsers);
    XCTAssertEqual([parsers count], 11);
}
@end
