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
#import "HL7ResultRangeAnalyzer.h"
#import "HL7ResultObservation.h"
#import "HL7Value.h"
#import "HL7CodeSystem_Private.h"

@interface HL7ResultRangeAnalyzerTests : XCTestCase

@end

@implementation HL7ResultRangeAnalyzerTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testResultNil
{
    HL7ResultRangeAnalyzer * analyzer = [HL7ResultRangeAnalyzer new];
    HL7ResultRange range = [analyzer resultRangeForSummaryEntry:nil forGender:HL7AdministrativeGenderCodeFemale];
    
    XCTAssertEqual(range, HL7ResultRangeUnknown);
}

- (void)testResultUnknownGender
{
    HL7ResultRangeAnalyzer * analyzer = [HL7ResultRangeAnalyzer new];
    HL7ResultObservation * observation = [HL7ResultObservation new];
    HL7ResultRange range = [analyzer resultRangeForSummaryEntry:observation forGender:HL7AdministrativeGenderCodeUnknown];
    
    XCTAssertEqual(range, HL7ResultRangeUnknown);
}

- (void)testResultNoValueCode
{
    HL7ResultRangeAnalyzer * analyzer = [HL7ResultRangeAnalyzer new];
    HL7ResultObservation * observation = [HL7ResultObservation new];
    HL7ResultRange range = [analyzer resultRangeForSummaryEntry:observation forGender:HL7AdministrativeGenderCodeFemale];
    
    XCTAssertEqual(range, HL7ResultRangeUnknown);
}


- (void)testResultNoMatch
{
    HL7ResultRangeAnalyzer * analyzer = [HL7ResultRangeAnalyzer new];
    HL7ResultObservation * observation = [HL7ResultObservation new];
    observation.value = [HL7Value new];
    observation.value.code = @"xyz";
    HL7ResultRange range = [analyzer resultRangeForSummaryEntry:observation forGender:HL7AdministrativeGenderCodeFemale];
    
    XCTAssertEqual(range, HL7ResultRangeUnknown);
}

- (void)testLoinc1751_7Normal
{
    HL7ResultRangeAnalyzer * analyzer = [HL7ResultRangeAnalyzer new];
    HL7ResultObservation * observation = [HL7ResultObservation new];
    observation.code = [HL7Code new];
    observation.code.code = @"1751-7";
    observation.value = [HL7Value new];
    observation.value.value = @"3.9";
    observation.value.unit = @"g/dL";
    HL7ResultRange range = [analyzer resultRangeForSummaryEntry:observation forGender:HL7AdministrativeGenderCodeFemale];
    XCTAssertEqual(range, HL7ResultRangeNormal);
}

- (void)testLoinc1751_7BelowNormal
{
    HL7ResultRangeAnalyzer * analyzer = [HL7ResultRangeAnalyzer new];
    HL7ResultObservation * observation = [HL7ResultObservation new];
    observation.code = [HL7Code new];
    observation.code.code = @"1751-7";
    observation.value = [HL7Value new];
    observation.value.value = @"3.89";
    observation.value.unit = @"g/dL";
    HL7ResultRange range = [analyzer resultRangeForSummaryEntry:observation forGender:HL7AdministrativeGenderCodeFemale];
    XCTAssertEqual(range, HL7ResultRangeBelowNormal);
}

- (void)testLoinc1751_7AboveNormal
{
    HL7ResultRangeAnalyzer * analyzer = [HL7ResultRangeAnalyzer new];
    HL7ResultObservation * observation = [HL7ResultObservation new];
    observation.code = [HL7Code new];
    observation.code.code = @"1751-7";
    observation.value = [HL7Value new];
    observation.value.value = @"13.89";
    observation.value.unit = @"g/dL";
    HL7ResultRange range = [analyzer resultRangeForSummaryEntry:observation forGender:HL7AdministrativeGenderCodeFemale];
    XCTAssertEqual(range, HL7ResultRangeAboveNormal);
}

- (void)testLoinc1751_7MismatchUnits
{
    HL7ResultRangeAnalyzer * analyzer = [HL7ResultRangeAnalyzer new];
    HL7ResultObservation * observation = [HL7ResultObservation new];
    observation.code = [HL7Code new];
    observation.code.code = @"1751-7";
    observation.value = [HL7Value new];
    observation.value.value = @"3.9";
    observation.value.unit = @"xyz";
    HL7ResultRange range = [analyzer resultRangeForSummaryEntry:observation forGender:HL7AdministrativeGenderCodeFemale];
    XCTAssertEqual(range, HL7ResultRangeUnknown);
}

- (void)testLoinc6690_2Normal
{
    HL7ResultRangeAnalyzer * analyzer = [HL7ResultRangeAnalyzer new];
    HL7ResultObservation * observation = [HL7ResultObservation new];
    observation.code = [HL7Code new];
    observation.code.code = @"6690-2";
    observation.value = [HL7Value new];
    observation.value.value = @"5.8";
    observation.value.unit = @"10*9/L";
    HL7ResultRange range = [analyzer resultRangeForSummaryEntry:observation forGender:HL7AdministrativeGenderCodeFemale];
    XCTAssertEqual(range, HL7ResultRangeNormal);
}

- (void)testLoinc6690_2UnknownUnit
{
    HL7ResultRangeAnalyzer * analyzer = [HL7ResultRangeAnalyzer new];
    HL7ResultObservation * observation = [HL7ResultObservation new];
    observation.code = [HL7Code new];
    observation.code.code = @"6690-2";
    observation.value = [HL7Value new];
    observation.value.value = @"5.8";
    observation.value.unit = @"cm";
    HL7ResultRange range = [analyzer resultRangeForSummaryEntry:observation forGender:HL7AdministrativeGenderCodeFemale];
    XCTAssertEqual(range, HL7ResultRangeUnknown);
}

- (void)testLoinc6690_2BelowNormal
{
    HL7ResultRangeAnalyzer * analyzer = [HL7ResultRangeAnalyzer new];
    HL7ResultObservation * observation = [HL7ResultObservation new];
    observation.code = [HL7Code new];
    observation.code.code = @"6690-2";
    observation.value = [HL7Value new];
    observation.value.value = @"4.0";
    observation.value.unit = @"THOUS/MCL";
    HL7ResultRange range = [analyzer resultRangeForSummaryEntry:observation forGender:HL7AdministrativeGenderCodeFemale];
    XCTAssertEqual(range, HL7ResultRangeBelowNormal);
}

- (void)testLoinc6690_2AboveNormal
{
    HL7ResultRangeAnalyzer * analyzer = [HL7ResultRangeAnalyzer new];
    HL7ResultObservation * observation = [HL7ResultObservation new];
    observation.code = [HL7Code new];
    observation.code.code = @"6690-2";
    observation.value = [HL7Value new];
    observation.value.value = @"11.1";
    observation.value.unit = @"X_10-3/uL";
    HL7ResultRange range = [analyzer resultRangeForSummaryEntry:observation forGender:HL7AdministrativeGenderCodeFemale];
    XCTAssertEqual(range, HL7ResultRangeAboveNormal);
}

- (void)testLoinc789_8Normal
{
    HL7ResultRangeAnalyzer * analyzer = [HL7ResultRangeAnalyzer new];
    HL7ResultObservation * observation = [HL7ResultObservation new];
    observation.code = [HL7Code new];
    observation.code.code = @"789-8";
    observation.value = [HL7Value new];
    observation.value.value = @"5.8";
    observation.value.unit = @"MILL/MCL";
    HL7ResultRange range = [analyzer resultRangeForSummaryEntry:observation forGender:HL7AdministrativeGenderCodeFemale];
    XCTAssertEqual(range, HL7ResultRangeNormal);
}

- (void)testLoinc789_8BelowNormal
{
    HL7ResultRangeAnalyzer * analyzer = [HL7ResultRangeAnalyzer new];
    HL7ResultObservation * observation = [HL7ResultObservation new];
    observation.code = [HL7Code new];
    observation.code.code = @"789-8";
    observation.value = [HL7Value new];
    observation.value.value = @"2.8";
    observation.value.unit = @"MILL/MCL";
    HL7ResultRange range = [analyzer resultRangeForSummaryEntry:observation forGender:HL7AdministrativeGenderCodeFemale];
    XCTAssertEqual(range, HL7ResultRangeBelowNormal);
}

- (void)testLoinc789_8AboveNormal
{
    HL7ResultRangeAnalyzer * analyzer = [HL7ResultRangeAnalyzer new];
    HL7ResultObservation * observation = [HL7ResultObservation new];
    observation.code = [HL7Code new];
    observation.code.code = @"789-8";
    observation.value = [HL7Value new];
    observation.value.value = @"6.8";
    observation.value.unit = @"MILL/MCL";
    HL7ResultRange range = [analyzer resultRangeForSummaryEntry:observation forGender:HL7AdministrativeGenderCodeFemale];
    XCTAssertEqual(range, HL7ResultRangeAboveNormal);
}

- (void)testLoinc4544_3NormalMale
{
    HL7ResultRangeAnalyzer * analyzer = [HL7ResultRangeAnalyzer new];
    HL7ResultObservation * observation = [HL7ResultObservation new];
    observation.code = [HL7Code new];
    observation.code.code = @"4544-3";
    observation.value = [HL7Value new];
    observation.value.value = @"45";
    observation.value.unit = @"%";
    HL7ResultRange range = [analyzer resultRangeForSummaryEntry:observation forGender:HL7AdministrativeGenderCodeMale];
    XCTAssertEqual(range, HL7ResultRangeNormal);
}

- (void)testLoinc4544_3BelowNormalMale
{
    HL7ResultRangeAnalyzer * analyzer = [HL7ResultRangeAnalyzer new];
    HL7ResultObservation * observation = [HL7ResultObservation new];
    observation.code = [HL7Code new];
    observation.code.code = @"4544-3";
    observation.value = [HL7Value new];
    observation.value.value = @"43";
    observation.value.unit = @"%";
    HL7ResultRange range = [analyzer resultRangeForSummaryEntry:observation forGender:HL7AdministrativeGenderCodeMale];
    XCTAssertEqual(range, HL7ResultRangeBelowNormal);
}

- (void)testLoinc4544_3NormalFemale
{
    HL7ResultRangeAnalyzer * analyzer = [HL7ResultRangeAnalyzer new];
    HL7ResultObservation * observation = [HL7ResultObservation new];
    observation.code = [HL7Code new];
    observation.code.code = @"4544-3";
    observation.value = [HL7Value new];
    observation.value.value = @"37";
    observation.value.unit = @"%";
    HL7ResultRange range = [analyzer resultRangeForSummaryEntry:observation forGender:HL7AdministrativeGenderCodeFemale];
    XCTAssertEqual(range, HL7ResultRangeNormal);
}

- (void)testLoinc4544_3BelowNormalFemale
{
    HL7ResultRangeAnalyzer * analyzer = [HL7ResultRangeAnalyzer new];
    HL7ResultObservation * observation = [HL7ResultObservation new];
    observation.code = [HL7Code new];
    observation.code.code = @"4544-3";
    observation.value = [HL7Value new];
    observation.value.value = @"36";
    observation.value.unit = @"%";
    HL7ResultRange range = [analyzer resultRangeForSummaryEntry:observation forGender:HL7AdministrativeGenderCodeFemale];
    XCTAssertEqual(range, HL7ResultRangeBelowNormal);
}

- (void)testLoinc30313_1NormalMale
{
    HL7ResultRangeAnalyzer * analyzer = [HL7ResultRangeAnalyzer new];
    HL7ResultObservation * observation = [HL7ResultObservation new];
    observation.code = [HL7Code new];
    observation.code.code = @"30313-1";
    observation.value = [HL7Value new];
    observation.value.value = @"13";
    observation.value.unit = @"g/dL";
    HL7ResultRange range = [analyzer resultRangeForSummaryEntry:observation forGender:HL7AdministrativeGenderCodeMale];
    XCTAssertEqual(range, HL7ResultRangeNormal);
}

- (void)testLoinc30313_1NormalFemale
{
    HL7ResultRangeAnalyzer * analyzer = [HL7ResultRangeAnalyzer new];
    HL7ResultObservation * observation = [HL7ResultObservation new];
    observation.code = [HL7Code new];
    observation.code.code = @"30313-1";
    observation.value = [HL7Value new];
    observation.value.value = @"12";
    observation.value.unit = @"g/dL";
    HL7ResultRange range = [analyzer resultRangeForSummaryEntry:observation forGender:HL7AdministrativeGenderCodeFemale];
    XCTAssertEqual(range, HL7ResultRangeNormal);
}

- (void)testLoinc2093_3NormalMale
{
    HL7ResultRangeAnalyzer * analyzer = [HL7ResultRangeAnalyzer new];
    HL7ResultObservation * observation = [HL7ResultObservation new];
    observation.code = [HL7Code new];
    observation.code.code = @"2093-3";
    observation.value = [HL7Value new];
    observation.value.value = @"190";
    observation.value.unit = @"mg/dL";
    HL7ResultRange range = [analyzer resultRangeForSummaryEntry:observation forGender:HL7AdministrativeGenderCodeMale];
    XCTAssertEqual(range, HL7ResultRangeNormal);
}

- (void)testLoinc2093_3AboveNormalMale
{
    HL7ResultRangeAnalyzer * analyzer = [HL7ResultRangeAnalyzer new];
    HL7ResultObservation * observation = [HL7ResultObservation new];
    observation.code = [HL7Code new];
    observation.code.code = @"2093-3";
    observation.value = [HL7Value new];
    observation.value.value = @"201";
    observation.value.unit = @"mg/dL";
    HL7ResultRange range = [analyzer resultRangeForSummaryEntry:observation forGender:HL7AdministrativeGenderCodeMale];
    XCTAssertEqual(range, HL7ResultRangeAboveNormal);
}

- (void)testLoinc2093_3NormalFemale
{
    HL7ResultRangeAnalyzer * analyzer = [HL7ResultRangeAnalyzer new];
    HL7ResultObservation * observation = [HL7ResultObservation new];
    observation.code = [HL7Code new];
    observation.code.code = @"2093-3";
    observation.value = [HL7Value new];
    observation.value.value = @"190";
    observation.value.unit = @"mg/dL";
    HL7ResultRange range = [analyzer resultRangeForSummaryEntry:observation forGender:HL7AdministrativeGenderCodeFemale];
    XCTAssertEqual(range, HL7ResultRangeNormal);
}
@end
