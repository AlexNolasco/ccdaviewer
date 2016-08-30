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


#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HL7UseAddressType) {
    // Unknown
    HL7UseAddressTypeUnknown = 0,
    // physical
    HL7UseAddressTypePhysical = 1,
    // home
    HL7UseAddressTypeHome = 2,
    // primary home
    HL7UseAddressTypePrimaryHome = 3,
    // vacation home
    HL7UseAddressTypePrimaryVacationHome = 4,
    // work place
    HL7UseAddressTypeWorkPlace = 5,
    // direct work place address
    HL7UseAddressTypeDirectWorkPlaceAddress = 6,
    // public
    HL7UseAddressTypePublic = 7,
    // bad address
    HL7UseAddressTypeBadAddress = 8,
    // birth place
    HL7UseAddressTypeBirthPlace = 9,
    // temporary
    HL7UseAddressTypeTemporary = 10,
    // postal
    HL7UseAddressTypePostal = 11,
    // alphabetic
    HL7UseAddressTypeAlphabetic = 12,
    // syllabic
    HL7UseAddressTypeSyllabic = 13,
    // ideographics
    HL7UseAddressTypeIdeographic = 14
};

typedef NS_ENUM(NSInteger, HL7UseNameType) {
    // Unknown
    HL7UseNameTypeUnknown = 0,
    // License or other document name that differs from legal name
    HL7UseNameTypeLicense = 1,
    // Indigenous
    HL7UseNameTypeIndigenous = 2,
    // Legal
    HL7UseNameTypeLegal = 3,
    // Pseudonym
    HL7UseNameTypePseudonym = 4,
    // Artist
    HL7UseNameTypeArtist = 5,
    // Religious
    HL7UseNameTypeReligious = 6,
    // Search
    HL7UseNameTypeSearch = 7,
    // Phonetic spelling of name
    HL7UseNameTypeSearchPhonetic = 8,
    // A “soundex code” for the name
    HL7UseNameTypeSearchSoundex = 9,
    // Alphabetic transcription of name (e.g. Japanese Romanji)
    HL7UseNameTypeAlphabetic = 10,
    // Syllabic script transcription (e.g. Kana or Hangul)
    HL7UseNameTypeSyllabic = 11,
    // Ideographic representation of name (e.g. Kanji)
    HL7UseNameTypeIdeographic = 12
};

typedef NS_ENUM(NSInteger, HL7UseTelecomType) {
    // Unkown
    HL7UseTelecomTypeUnknown = 0,
    // Home
    HL7UseTelecomTypeHome = 1,
    // Home Primary
    HL7UseTelecomTypeHomePrimary = 2,
    // Home Vacation
    HL7UseTelecomTypeHomeVacation = 3,
    // Workplace
    HL7UseTelecomTypeWorkPlace = 4,
    // Direct
    HL7UseTelecomTypeDirect = 5,
    // Public
    HL7UseTelecomTypePublic = 6,
    // Bad
    HL7UseTelecomTypeBad = 7,
    // Temp
    HL7UseTelecomTypeTemporary = 8,
    // Answering Machine
    HL7UseTelecomTypeAnsweringMachine = 9,
    // Emergency contact
    HL7UseTelecomTypeEmergencyContact = 10,
    // Mobile contact
    HL7UseTelecomTypeMobileContact = 11,
    // Pager
    HL7UseTelecomTypePager = 12
};

typedef NS_ENUM(NSInteger, HL7TelecomType) {
    // Unknown
    HL7TelecomTypeUnknown = 0,
    // telephone
    HL7TelecomTypeTelephone = 1,
    // email
    HL7TelecomTypeEmail = 2,
    // http
    HL7TelecomTypeHttp = 3,
    // https
    HL7TelecomTypeHttps = 4
};

typedef NS_ENUM(NSInteger, HL7AdministrativeGenderCode) {
    // Unknown
    HL7AdministrativeGenderCodeUnknown = 0,
    // undifferentiated
    HL7AdministrativeGenderCodeUndifferentiated = 1,
    // female
    HL7AdministrativeGenderCodeFemale = 2,
    // male
    HL7AdministrativeGenderCodeMale = 3
};

typedef NS_ENUM(NSInteger, HL7MaritalStatusCode) {
    // Unknown
    HL7MaritalStatusCodeUnknown = 0,
    // anulled
    HL7MaritalStatusCodeAnulled = 1,
    // divorced
    HL7MaritalStatusCodeDivorced = 2,
    // interlocutory
    HL7MaritalStatusCodeInterlocutory = 3,
    // separated
    HL7MaritalStatusCodeLegallySeparated = 4,
    // married
    HL7MaritalStatusCodeMarried = 5,
    // polygamous
    HL7MaritalStatusCodePolygamous = 6,
    // never married
    HL7MaritalStatusCodeNeverMarried = 7,
    // domestic partner
    HL7MaritalStatusCodeDomesticPartner = 8,
    // widowed
    HL7MaritalStatusCodeWidowed = 9
};

typedef NS_ENUM(NSInteger, HL7XSIType) {
    // Unknown
    HL7XSITypeUnknown = 0,
    // physical quality
    HL7XSITypePhysicalQuality,
    // coded concept
    HL7XSITypeCodedConcept,
    // quantity range
    HL7XSITypeQuantityRange,
    // code
    HL7XSITypeCode,
    // structured text
    HL7XSITypeStructuredText
};

typedef NS_ENUM(NSInteger, HL7StatusCodeCode) {
    // Unknown
    HL7StatusCodeCodeUnknown = 0,
    // Code active
    HL7StatusCodeCodeActive = 1,
    // Code resolved
    HL7StatusCodeCodeResolved = 2,
    // Code completed
    HL7StatusCodeCodeCompleted = 3,
};

typedef NS_ENUM(NSInteger, HL7NullFlavor) {
    // Unknown
    HL7NullFlavorNull = 0,
    // Unknown
    HL7NullFlavorUnknown = 1,
    // Asked but unknown
    HL7NullFlavorAskedButUnknown = 2,
    // Masked
    HL7NullFlavorMasked = 3,
    // Negative
    HL7NullFlavorNegativeInfinitive = 4,
    // No information
    HL7NullFlavorNoInformation = 5,
    // Not applicable
    HL7NullFlavorNotApplicable = 6,
    // Not asked
    HL7NullFlavorNotAsked = 7,
    // Flavor other
    HL7NullFlavorOther = 8,
    // Flavor postitive infinitive
    HL7NullFlavorPositiveInfinitive = 9,
    // Flavor sufficient quantity
    HL7NullFlavorSufficientQuantity = 10,
    // Temporarily unavailable
    HL7NullFlavorTemporaryUnavailable = 11,
    // Trace
    HL7NullFlavorTrace = 12,
    // Uncoded
    HL7NullFlavorUnCoded = 13
};

typedef NS_ENUM(NSInteger, HL7XSITimeInterval) {
    // Unknown
    HL7XSITimeIntervalsUnknown = 0,
    // TS
    HL7XSITimeIntervalsTimeStamp,
    // IVL_TS
    HL7XSITimeIntervalsContiguousTimeInterval,
    // PIVL_TS
    HL7XSITimeIntervalsPeriodicTimeInterval,
    // EIVL
    HL7XSITimeIntervalsEventRelatedTimeInterval
};

typedef NS_ENUM(NSInteger, HL7MoodCode) {
    // Unknown
    HL7MoodCodeUnknown = 0,
    // The clinical statement/event already happened
    HL7MoodCodeEvn = 1,
    // The clinical statement is intended to happen in the future
    HL7MoodCodeInt = 2,
    // The clinical statement is a request or order
    HL7MoodCodeRqo = 3,
    // The clinical statement is planned for a specific time/place (appointment)
    HL7MoodCodeApt = 4,
    // The clinical statement is a request to book an appointment
    HL7MoodCodeArq = 5,
    // The clinical statement is being proposed
    HL7MoodCodePrp = 6,
    // The clinical statement is promised
    HL7MoodCodePrms = 7,
    // The clinical statement is a definition/observation
    HL7MoodCodeDef = 8,
    // The clinical statement is a goal/objective
    HL7MoodCodeGol = 9,
    // The clinical statement is a pre-condition/criteria
    HL7MoodCodeEvnCrt = 10
};

typedef NS_ENUM(NSInteger, HL7ProblemSeverityCode) {
    // Unknown
    HL7ProblemSeverityCodeUnknown = 0,
    // 255604002
    HL7ProblemSeverityCodeMild = 1,
    // 371923003
    HL7ProblemSeverityCodeMildToModerate = 2,
    // 6736007
    HL7ProblemSeverityCodeModerate = 3,
    // 371924009
    HL7ProblemSeverityCodeModerateToSevere = 4,
    // 24484000
    HL7ProblemSeverityCodeSevere = 5,
    // 399166001
    HL7ProblemSeverityCodeFatal = 6
};

typedef NS_ENUM(NSInteger, HL7ConfidentialityCode) { HL7ConfidentialityCodeUnknown = 0, HL7ConfidentialityCodeLow = 1, HL7ConfidentialityCodeModerate = 2, HL7ConfidentialityCodeNormal = 3, HL7ConfidentialityCodeRestricted = 4, HL7ConfidentialityCodeUnrestricted = 5, HL7ConfidentialityCodeVeryRestricted = 6, HL7ConfidentialityCodeBusiness = 7, HL7ConfidentialityCodeClinician = 8, HL7ConfidentialityCodeIndividual = 9 };
@interface HL7Enumerations : NSObject
@end
