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
#import "HL7ElementParser+Additions.h"
#import "HL7Name_Private.h"
#import "IGXMLReader+Additions.h"
#import "IGXMLReader.h"


@interface HL7NameTests : XCTestCase

@end

@implementation HL7NameTests

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
    NSString *xml = @"<name/>";
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];
    HL7Name *name = [HL7ElementParser nameFromReader:reader];

    XCTAssertNotNil(name);
}

- (void)testSuccess
{
    NSString *xml = @"<name><prefix>Mr.</prefix><given>Alex</"
                    @"given><family>Nolasco</family><suffix>3rd</suffix><name/>";
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];
    HL7Name *name = [HL7ElementParser nameFromReader:reader];

    XCTAssertNotNil(name);
    XCTAssert([[name first] isEqualToString:@"Alex"]);
    XCTAssert([[name last] isEqualToString:@"Nolasco"]);
    XCTAssert([[name prefix] isEqualToString:@"Mr."]);
    XCTAssert([[name suffix] isEqualToString:@"3rd"]);
    XCTAssert([[name description] isEqualToString:@"Mr. Alex Nolasco"]);
}

@end
