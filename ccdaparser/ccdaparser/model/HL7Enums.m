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


#import "HL7Enums.h"
#import "HelperMacros.h"
#import "HL7Const.h"

@implementation HL7Enumerations

+ (NSString *)enumName:(NSString *)name code:(NSInteger)code
{
    NSString *key = [NSString stringWithFormat:@"%@.%ld", name, (long)code];
    return LOCALIZED_STRING(key);
}

+ (NSString *)maritalStatusAsString:(HL7MaritalStatusCode)maritalStatusCode
{
    return [self enumName:@"HL7MaritalStatusCode" code:maritalStatusCode];
}

+ (NSString *)genderAsString:(HL7AdministrativeGenderCode)genderCode
{
    return [self enumName:@"HL7AdministrativeGenderCode" code:genderCode];
}

+ (NSString *_Nullable)useAsString:(HL7UseAddressType)useCode
{
    return [self enumName:@"HL7UseAddress" code:useCode];
}

+ (NSString *_Nullable)nameUseAsString:(HL7UseNameType)nameUseCode
{
    return [self enumName:@"HL7UseName" code:nameUseCode];
}

+ (NSString *_Nullable)statusCodeAsString:(HL7StatusCodeCode)statusCodeCode
{
    return [self enumName:@"HL7StatusCodeCode" code:statusCodeCode];
}

+ (NSString *_Nullable)moodCodeAsString:(HL7MoodCode)moodCode
{
    return [self enumName:@"HL7MoodCode" code:moodCode];
}

+ (NSString *_Nullable)problemSeverityAsString:(HL7ProblemSeverityCode)problemSeverityCode
{
    return [self enumName:@"HL7ProblemSeverityCode" code:problemSeverityCode];
}

+ (HL7NullFlavor)hl7NullFlavorFromString:(NSString *)nullFlavor
{
    if (![nullFlavor length]) {
        return HL7NullFlavorNull;
    } else if ([nullFlavor isEqualToString:@"UNK"]) {
        return HL7NullFlavorUnknown;
    } else if ([nullFlavor isEqualToString:@"ASKU"]) {
        return HL7NullFlavorAskedButUnknown;
    } else if ([nullFlavor isEqualToString:@"MSK"]) {
        return HL7NullFlavorMasked;
    } else if ([nullFlavor isEqualToString:@"NINF"]) {
        return HL7NullFlavorNegativeInfinitive;
    } else if ([nullFlavor isEqualToString:@"NI"]) {
        return HL7NullFlavorNoInformation;
    } else if ([nullFlavor isEqualToString:@"NA"]) {
        return HL7NullFlavorNotApplicable;
    } else if ([nullFlavor isEqualToString:@"NASK"]) {
        return HL7NullFlavorNotAsked;
    } else if ([nullFlavor isEqualToString:@"OTH"]) {
        return HL7NullFlavorOther;
    } else if ([nullFlavor isEqualToString:@"PINF"]) {
        return HL7NullFlavorPositiveInfinitive;
    } else if ([nullFlavor isEqualToString:@"QS"]) {
        return HL7NullFlavorSufficientQuantity;
    } else if ([nullFlavor isEqualToString:@"NAV"]) {
        return HL7NullFlavorTemporaryUnavailable;
    } else if ([nullFlavor isEqualToString:@"UNC"]) {
        return HL7NullFlavorUnCoded;
    } else if ([nullFlavor isEqualToString:@"TRC"]) {
        return HL7NullFlavorTrace;
    } else {
        return HL7NullFlavorNull;
    }
}

+ (HL7UseAddressType)hl7AddressTypeUseFromString:(NSString *_Nullable)useCode
{
    if ([useCode length]) {
        if ([useCode isEqualToString:@"H"]) {
            return HL7UseAddressTypeHome; // H: Home address
        } else if ([useCode isEqualToString:@"HP"]) {
            return HL7UseAddressTypePrimaryHome; // HP: Primary home address
        } else if ([useCode isEqualToString:@"HV"]) {
            return HL7UseAddressTypePrimaryVacationHome; // HV: Vacation home address
        } else if ([useCode isEqualToString:@"WP"]) {
            return HL7UseAddressTypeWorkPlace; // WP: Workplace address
        } else if ([useCode isEqualToString:@"DIR"]) {
            return HL7UseAddressTypeDirectWorkPlaceAddress; // DIR: Direct work place address
        } else if ([useCode isEqualToString:@"PUB"]) {
            return HL7UseAddressTypePublic; // PUB: Public work place address (mail room, front desk, etc.)
        } else if ([useCode isEqualToString:@"BAD"]) {
            return HL7UseAddressTypeBadAddress; // BAD: Bad address
        } else if ([useCode isEqualToString:@"TMP"]) {
            return HL7UseAddressTypeTemporary; // TMP: Temporary address
        }
    }
    return HL7UseAddressTypeUnknown;
}

+ (HL7UseNameType)hl7NameUseFromString:(NSString *_Nullable)useNameCode
{
    if (![useNameCode length]) {
        return HL7UseNameTypeUnknown;
    }
    if ([useNameCode isEqualToString:@"C"]) {
        return HL7UseNameTypeLicense;
    } else if ([useNameCode isEqualToString:@"I"]) {
        return HL7UseNameTypeIndigenous;
    } else if ([useNameCode isEqualToString:@"L"]) {
        return HL7UseNameTypeLegal;
    } else if ([useNameCode isEqualToString:@"P"]) {
        return HL7UseNameTypePseudonym;
    } else if ([useNameCode isEqualToString:@"A"]) {
        return HL7UseNameTypeArtist;
    } else if ([useNameCode isEqualToString:@"R"]) {
        return HL7UseNameTypeReligious;
    } else if ([useNameCode isEqualToString:@"SRCH"]) {
        return HL7UseNameTypeSearch;
    } else if ([useNameCode isEqualToString:@"PHON"]) {
        return HL7UseNameTypeSearchPhonetic;
    } else if ([useNameCode isEqualToString:@"SNDX"]) {
        return HL7UseNameTypeSearchSoundex;
    } else if ([useNameCode isEqualToString:@"ABC"]) {
        return HL7UseNameTypeAlphabetic;
    } else if ([useNameCode isEqualToString:@"SYL"]) {
        return HL7UseNameTypeSyllabic;
    } else if ([useNameCode isEqualToString:@"IDE"]) {
        return HL7UseNameTypeIdeographic;
    } else {
        return HL7UseNameTypeUnknown;
    }
}

+ (HL7UseTelecomType)hl7TelecomUseFromString:(NSString *_Nullable)useTelecomCode
{
    if (![useTelecomCode length]) {
        return HL7UseTelecomTypeUnknown;
    }
    if ([useTelecomCode isEqualToString:@"H"]) {
        return HL7UseTelecomTypeHome;
    } else if ([useTelecomCode isEqualToString:@"HP"]) {
        return HL7UseTelecomTypeHomePrimary;
    } else if ([useTelecomCode isEqualToString:@"HV"]) {
        return HL7UseTelecomTypeHomeVacation;
    } else if ([useTelecomCode isEqualToString:@"WP"]) {
        return HL7UseTelecomTypeWorkPlace;
    } else if ([useTelecomCode isEqualToString:@"DIR"]) {
        return HL7UseTelecomTypeDirect;
    } else if ([useTelecomCode isEqualToString:@"PUB"]) {
        return HL7UseTelecomTypePublic;
    } else if ([useTelecomCode isEqualToString:@"BAD"]) {
        return HL7UseTelecomTypeBad;
    } else if ([useTelecomCode isEqualToString:@"TMP"]) {
        return HL7UseTelecomTypeTemporary;
    } else if ([useTelecomCode isEqualToString:@"AS"]) {
        return HL7UseTelecomTypeAnsweringMachine;
    } else if ([useTelecomCode isEqualToString:@"EC"]) {
        return HL7UseTelecomTypeEmergencyContact;
    } else if ([useTelecomCode isEqualToString:@"MC"]) {
        return HL7UseTelecomTypeMobileContact;
    } else if ([useTelecomCode isEqualToString:@"PG"]) {
        return HL7UseTelecomTypePager;
    } else {
        return HL7UseTelecomTypeUnknown;
    }
}

+ (HL7ProblemSeverityCode)hl7ProblemSeverityCodeFromString:(NSString *_Nullable)problemSeverityCode
{
    if (![problemSeverityCode length]) {
        return HL7ProblemSeverityCodeUnknown;
    }
    if ([problemSeverityCode isEqualToString:@"255604002"]) {
        return HL7ProblemSeverityCodeMild;
    } else if ([problemSeverityCode isEqualToString:@"371923003"]) {
        return HL7ProblemSeverityCodeMildToModerate;
    } else if ([problemSeverityCode isEqualToString:@"6736007"]) {
        return HL7ProblemSeverityCodeModerate;
    } else if ([problemSeverityCode isEqualToString:@"371924009"]) {
        return HL7ProblemSeverityCodeModerateToSevere;
    } else if ([problemSeverityCode isEqualToString:@"24484000"]) {
        return HL7ProblemSeverityCodeSevere;
    } else if ([problemSeverityCode isEqualToString:@"399166001"]) {
        return HL7ProblemSeverityCodeFatal;
    } else {
        return HL7ProblemSeverityCodeUnknown;
    }
}
@end
