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
@end
