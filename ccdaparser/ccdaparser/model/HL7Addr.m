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


#import "HL7Addr.h"

@implementation HL7Addr

- (NSMutableArray *)streetAddressLines
{
    if (_streetAddressLines == nil) {
        _streetAddressLines = [[NSMutableArray alloc] initWithCapacity:2];
    }
    return _streetAddressLines;
}

- (nullable NSString *)addressLine
{
    if ([[self streetAddressLines] count] == 0) {
        return nil;
    }
    return [[[self streetAddressLines] firstObject] copy];
}

#pragma mark NSCopying
- (id)copyWithZone:(nullable NSZone *)zone
{
    HL7Addr *clone = [[HL7Addr allocWithZone:zone] init];
    [clone setStreetAddressLines:[[NSMutableArray allocWithZone:zone] initWithArray:[self streetAddressLines] copyItems:YES]];
    [clone setCity:[[self city] copyWithZone:zone]];
    [clone setState:[[self state] copyWithZone:zone]];
    [clone setPostalCode:[[self postalCode] copyWithZone:zone]];
    [clone setCountry:[[self country] copyWithZone:zone]];
    [clone setUses:[[self uses] copyWithZone:zone]];
    return clone;
}
@end
