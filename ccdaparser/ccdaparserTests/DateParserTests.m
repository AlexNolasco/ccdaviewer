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


#import "NSDate+Additions.h"
#import <XCTest/XCTest.h>

@interface DateParserTests : XCTestCase

@end

@implementation DateParserTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testyyyyMMddHHmmssZ
{

    NSString *isoString = @"20071005100600-0400";
    NSDate *result = [NSDate fromISO8601String:isoString];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:result];
    XCTAssertNotNil(result);
    XCTAssertNotNil(result);
    XCTAssertEqual(2007, [components year]);
    XCTAssertEqual(10, [components month]);
    XCTAssertEqual(5, [components day]);
    XCTAssertEqual(10, [components hour]);
    XCTAssertEqual(06, [components minute]);
}

- (void)testyyyyMMddHHmmZ
{
    NSString *isoString = @"201308151030-0800";
    NSDate *result = [NSDate fromISO8601String:isoString];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:result];
    XCTAssertNotNil(result);
    XCTAssertNotNil(result);
    XCTAssertEqual(2013, [components year]);
    XCTAssertEqual(8, [components month]);
    XCTAssertEqual(15, [components day]);
}

- (void)testyyyyMMddHHmm
{
    NSString *isoString = @"201308151030";
    NSDate *result = [NSDate fromISO8601String:isoString];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:result];
    XCTAssertNotNil(result);
    XCTAssertEqual(2013, [components year]);
    XCTAssertEqual(8, [components month]);
    XCTAssertEqual(15, [components day]);
    XCTAssertEqual(10, [components hour]);
    XCTAssertEqual(30, [components minute]);
}

- (void)testyyyyMMddHHmmss
{
    NSString *isoString = @"20100401100000";
    NSDate *result = [NSDate fromISO8601String:isoString];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:result];
    XCTAssertNotNil(result);
    XCTAssertEqual(2010, [components year]);
    XCTAssertEqual(4, [components month]);
    XCTAssertEqual(1, [components day]);
    XCTAssertEqual(10, [components hour]);
    XCTAssertEqual(0, [components minute]);
}

- (void)testyyyyMMdd
{
    NSString *isoString = @"20130815";
    NSDate *result = [NSDate fromISO8601String:isoString];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:result];
    XCTAssertNotNil(result);
    XCTAssertEqual(2013, [components year]);
    XCTAssertEqual(8, [components month]);
    XCTAssertEqual(15, [components day]);
}

- (void)testyyyy
{
    NSString *isoString = @"1973";
    NSDate *result = [NSDate fromISO8601String:isoString];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:result];
    XCTAssertNotNil(result);
    XCTAssertEqual(1973, [components year]);
    XCTAssertEqual(1, [components month]);
    XCTAssertEqual(1, [components day]);
}

@end
