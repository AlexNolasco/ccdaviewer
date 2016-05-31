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


#import "HL7InterpretationCode.h"
#import "HL7CodeSystem_Private.h"
#import <XCTest/XCTest.h>

@interface HL7InterpretationCodeTests : XCTestCase

@end

@implementation HL7InterpretationCodeTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testNoCode
{
    HL7InterpretationCode *code = [HL7InterpretationCode new];
    [code setCodeSystem:@"2.16.840.1.113883.5.83"];

    // assert
    XCTAssertNil([code displayName]);
}

- (void)testNormal
{
    HL7InterpretationCode *code = [HL7InterpretationCode new];
    [code setCodeSystem:@"2.16.840.1.113883.5.83"];
    [code setCode:@"N"];

    // assert
    XCTAssertTrue([[code displayName] isEqualToString:@"Normal"]);
}

- (void)testNotFoundInResource
{
    HL7InterpretationCode *code = [HL7InterpretationCode new];
    [code setCodeSystem:@"2.16.840.1.113883.5.83"];
    [code setCode:@"XYZ"];

    // assert
    XCTAssertTrue([[code displayName] isEqualToString:@"2.16.840.1.113883.5.83.XYZ"]);
}

@end
