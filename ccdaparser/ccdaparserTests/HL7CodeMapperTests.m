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
#import "HL7CodeMapper.h"
#import "HL7CodeSystem_Private.h"
#import "HL7Enums.h"
#import "HL7CodeSystem_Private.h"


@interface HL7CodeMapperTests : XCTestCase
@end

@implementation HL7CodeMapperTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testMaritalStatusAnulled
{
    HL7Code *code = [[HL7Code alloc] init];
    [code setCode:@"A"];
    [code setDisplayName:@"Anulled"];
    [code setCodeSystem:@"2.16.840.1.113883.5.2"];

    HL7MaritalStatusCode maritalStatusCode = [HL7CodeMapper maritalStatusFromCode:code];
    XCTAssertEqual(maritalStatusCode, HL7MaritalStatusCodeAnulled);
}

- (void)testMaritalStatusMarried
{
    HL7Code *code = [[HL7Code alloc] init];
    [code setCode:@"M"];
    [code setDisplayName:@"Married"];
    [code setCodeSystem:@"2.16.840.1.113883.5.2"];

    HL7MaritalStatusCode maritalStatusCode = [HL7CodeMapper maritalStatusFromCode:code];
    XCTAssertEqual(maritalStatusCode, HL7MaritalStatusCodeMarried);
}

- (void)testMaritalStatusDivorced
{
    HL7Code *code = [[HL7Code alloc] init];
    [code setCode:@"D"];
    [code setDisplayName:@"Divorced"];
    [code setCodeSystem:@"2.16.840.1.113883.5.2"];

    HL7MaritalStatusCode maritalStatusCode = [HL7CodeMapper maritalStatusFromCode:code];
    XCTAssertEqual(maritalStatusCode, HL7MaritalStatusCodeDivorced);
}

- (void)testMaritalStatusNeverMarried
{
    HL7Code *code = [[HL7Code alloc] init];
    [code setCode:@"S"];
    [code setDisplayName:@"Never Married"];
    [code setCodeSystem:@"2.16.840.1.113883.5.2"];

    HL7MaritalStatusCode maritalStatusCode = [HL7CodeMapper maritalStatusFromCode:code];
    XCTAssertEqual(maritalStatusCode, HL7MaritalStatusCodeNeverMarried);
}

- (void)testGenderCodeFemale
{
    HL7Code *code = [[HL7Code alloc] init];
    [code setCode:@"F"];
    [code setDisplayName:@"Female"];
    [code setCodeSystem:@"2.16.840.1.113883.5.1"];

    HL7AdministrativeGenderCode genderCode = [HL7CodeMapper genderFromCode:code];
    XCTAssertEqual(genderCode, HL7AdministrativeGenderCodeFemale);
}

- (void)testGenderCodeMale
{
    HL7Code *code = [[HL7Code alloc] init];
    [code setCode:@"M"];
    [code setDisplayName:@"Male"];
    [code setCodeSystem:@"2.16.840.1.113883.5.1"];

    HL7AdministrativeGenderCode genderCode = [HL7CodeMapper genderFromCode:code];
    XCTAssertEqual(genderCode, HL7AdministrativeGenderCodeMale);
}

- (void)testGenderCodeUndifferentiated
{
    HL7Code *code = [[HL7Code alloc] init];
    [code setCode:@"UN"];
    [code setDisplayName:@"Undifferentiated"];
    [code setCodeSystem:@"2.16.840.1.113883.5.1"];

    HL7AdministrativeGenderCode genderCode = [HL7CodeMapper genderFromCode:code];
    XCTAssertEqual(genderCode, HL7AdministrativeGenderCodeUndifferentiated);
}

@end
