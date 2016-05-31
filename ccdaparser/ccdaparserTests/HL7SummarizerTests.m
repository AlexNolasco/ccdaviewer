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
#import "HL7summarizer.h"
#import "HL7CCD.h"
#import "HL7CCDSummary.h"

@interface HL7SummarizerTests : XCTestCase

@end

@implementation HL7SummarizerTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testNil
{
    HL7Summarizer *summarizer = [HL7Summarizer new];

    // execute
    HL7CCDSummary *result = [summarizer summarizeCcda:nil templates:nil];

    // assert
    XCTAssertNil(result);
}

- (void)testSuccess
{
    HL7Summarizer *summarizer = [HL7Summarizer new];
    HL7CCD *ccda = [HL7CCD new];

    // execute
    HL7CCDSummary *result = [summarizer summarizeCcda:ccda templates:nil];

    // assert
    XCTAssertNotNil(result);
    XCTAssertEqual([[result summaries] count], 0);
    XCTAssertNotNil([result patient]);
}

- (void)testgetDictionaryOfSummaryImplementations
{
    HL7Summarizer *summarizer = [HL7Summarizer new];

    // execute
    id result = [summarizer getDictionaryOfSummaryImplementations];

    // assert
    XCTAssertNotNil(result);
}
@end
