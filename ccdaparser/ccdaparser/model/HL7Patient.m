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


#import "HL7Patient.h"
#import "HL7Name.h"
#import "HL7Code.h"
#import "HL7CodeMapper.h"
#import "NSDate+Additions.h"

@implementation HL7Patient
- (nullable NSDate *)birthday
{
    if (![[self birthTime] length]) {
        return nil;
    }
    return [NSDate fromISO8601String:[self birthTime]];
}

- (NSUInteger)age
{
    if (![self birthday]) {
        return 0;
    }
    NSDate *now = [NSDate date];
    NSDateComponents *ageComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:[self birthday] toDate:now options:0];
    return [ageComponents year];
}

- (HL7AdministrativeGenderCode)gender
{
    return [HL7CodeMapper genderFromCode:[self administrativeGenderCode]];
}

- (HL7MaritalStatusCode)maritalStatus
{
    return [HL7CodeMapper maritalStatusFromCode:[self maritalStatusCode]];
}

- (NSMutableArray<HL7Name *> *)names
{
    if (_names == nil) {
        _names = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _names;
}

- (HL7Name *)name
{
    if ([[self names] count] == 0) {
        return nil;
    }
    return [[self names] firstObject];
}

- (NSMutableArray *)guardians
{
    if (_guardians == nil) {
        _guardians = [[NSMutableArray alloc] init];
    }
    return _guardians;
}
@end
