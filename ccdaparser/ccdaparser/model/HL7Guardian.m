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


#import "HL7Guardian.h"
#import "HL7Name.h"
#import "HL7Code.h"
#import "HL7Telecom.h"

@implementation HL7Guardian
- (NSMutableArray<HL7Addr *> *)addresses
{
    if (_addresses == nil) {
        _addresses = [[NSMutableArray alloc] initWithCapacity:2];
    }
    return _addresses;
}

- (NSMutableArray<HL7Telecom *> *)telecoms
{
    if (_telecoms == nil) {
        _telecoms = [[NSMutableArray alloc] initWithCapacity:2];
    }
    return _telecoms;
}

- (id)copyWithZone:(nullable NSZone *)zone
{
    HL7Guardian *clone = [[HL7Guardian allocWithZone:zone] init];
    [clone setName:[[self name] copyWithZone:zone]];
    [clone setCode:[[self code] copyWithZone:zone]];
    [clone setAddresses:[[NSMutableArray allocWithZone:zone] initWithArray:[self addresses] copyItems:YES]];
    [clone setTelecoms:[[NSMutableArray allocWithZone:zone] initWithArray:[self telecoms] copyItems:YES]];
    return clone;
}
@end
