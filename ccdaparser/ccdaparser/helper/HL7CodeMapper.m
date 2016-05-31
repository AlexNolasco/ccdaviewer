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


#import "HL7CodeMapper.h"
#import "HL7Enums.h"
#import "HL7Code.h"

@implementation HL7CodeMapper
+ (HL7AdministrativeGenderCode)genderFromCode:(HL7Code *)code
{
    if (code == nil || [code code] == nil || ![[code codeSystem] isEqualToString:@"2.16.840.1.113883.5.1"]) {
        return HL7AdministrativeGenderCodeUnknown;
    }

    if ([[code code] isEqualToString:@"F"]) {
        return HL7AdministrativeGenderCodeFemale;
    } else if ([[code code] isEqualToString:@"M"]) {
        return HL7AdministrativeGenderCodeMale;
    } else if ([[code code] isEqualToString:@"UN"]) {
        return HL7AdministrativeGenderCodeUndifferentiated;
    } else {
        return HL7AdministrativeGenderCodeUnknown;
    }
}

+ (HL7MaritalStatusCode)maritalStatusFromCode:(HL7Code *)code
{

    if (code == nil || [code code] == nil || ![[code codeSystem] isEqualToString:@"2.16.840.1.113883.5.2"]) {
        return HL7MaritalStatusCodeUnknown;
    }

    if ([[code code] isEqualToString:@"A"]) {
        return HL7MaritalStatusCodeAnulled;
    } else if ([[code code] isEqualToString:@"D"]) {
        return HL7MaritalStatusCodeDivorced;
    } else if ([[code code] isEqualToString:@"I"]) {
        return HL7MaritalStatusCodeInterlocutory;
    } else if ([[code code] isEqualToString:@"L"]) {
        return HL7MaritalStatusCodeLegallySeparated;
    } else if ([[code code] isEqualToString:@"M"]) {
        return HL7MaritalStatusCodeMarried;
    } else if ([[code code] isEqualToString:@"P"]) {
        return HL7MaritalStatusCodePolygamous;
    } else if ([[code code] isEqualToString:@"S"]) {
        return HL7MaritalStatusCodeNeverMarried;
    } else if ([[code code] isEqualToString:@"T"]) {
        return HL7MaritalStatusCodeDomesticPartner;
    } else if ([[code code] isEqualToString:@"W"]) {
        return HL7MaritalStatusCodeWidowed;
    }
    return HL7MaritalStatusCodeUnknown;
}

@end
