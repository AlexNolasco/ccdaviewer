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


#import "HL7Enums_Private.h"
#import <XCTest/XCTest.h>

@interface HL7NullFlavorElementTests : XCTestCase

@end

@implementation HL7NullFlavorElementTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testEnum
{

    XCTAssertTrue([HL7Enumerations hl7NullFlavorFromString:@"UNK"] == HL7NullFlavorUnknown);
    XCTAssertTrue([HL7Enumerations hl7NullFlavorFromString:@"ASKU"] == HL7NullFlavorAskedButUnknown);
    XCTAssertTrue([HL7Enumerations hl7NullFlavorFromString:@"NASK"] == HL7NullFlavorNotAsked);
    XCTAssertTrue([HL7Enumerations hl7NullFlavorFromString:@"NI"] == HL7NullFlavorNoInformation);
    XCTAssertTrue([HL7Enumerations hl7NullFlavorFromString:@"NA"] == HL7NullFlavorNotApplicable);
    XCTAssertTrue([HL7Enumerations hl7NullFlavorFromString:nil] == HL7NullFlavorNull);
}

@end
