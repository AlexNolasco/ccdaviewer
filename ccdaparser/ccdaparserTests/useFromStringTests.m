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
#import "HL7Addr.h"
#import "HL7ElementParser+Additions.h"
#import "HL7Enums_Private.h"
#import "IGXMLReader+Additions.h"
#import "IGXMLReader.h"

@interface useFromStringTests : XCTestCase

@end

@implementation useFromStringTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testUseAddressFromString
{
    XCTAssertEqual(HL7UseAddressTypeHome, [HL7Enumerations hl7AddressTypeUseFromString:@"H"]);
    XCTAssertEqual(HL7UseAddressTypePrimaryHome, [HL7Enumerations hl7AddressTypeUseFromString:@"HP"]);
    XCTAssertEqual(HL7UseAddressTypePrimaryVacationHome, [HL7Enumerations hl7AddressTypeUseFromString:@"HV"]);
    XCTAssertEqual(HL7UseAddressTypeWorkPlace, [HL7Enumerations hl7AddressTypeUseFromString:@"WP"]);
    XCTAssertEqual(HL7UseAddressTypeBadAddress, [HL7Enumerations hl7AddressTypeUseFromString:@"BAD"]);
    XCTAssertEqual(HL7UseAddressTypePublic, [HL7Enumerations hl7AddressTypeUseFromString:@"PUB"]);
    XCTAssertEqual(HL7UseAddressTypeDirectWorkPlaceAddress, [HL7Enumerations hl7AddressTypeUseFromString:@"DIR"]);
    XCTAssertEqual(HL7UseAddressTypeUnknown, [HL7Enumerations hl7AddressTypeUseFromString:@"XXX"]);
}

- (void)testUseNameFromString
{
    XCTAssertEqual(HL7UseNameTypeLicense, [HL7Enumerations hl7NameUseFromString:@"C"]);
    XCTAssertEqual(HL7UseNameTypeIndigenous, [HL7Enumerations hl7NameUseFromString:@"I"]);
    XCTAssertEqual(HL7UseNameTypeLegal, [HL7Enumerations hl7NameUseFromString:@"L"]);
    XCTAssertEqual(HL7UseNameTypePseudonym, [HL7Enumerations hl7NameUseFromString:@"P"]);
    XCTAssertEqual(HL7UseNameTypeArtist, [HL7Enumerations hl7NameUseFromString:@"A"]);
    XCTAssertEqual(HL7UseNameTypeReligious, [HL7Enumerations hl7NameUseFromString:@"R"]);
    XCTAssertEqual(HL7UseNameTypeSearch, [HL7Enumerations hl7NameUseFromString:@"SRCH"]);
    XCTAssertEqual(HL7UseNameTypeSearchPhonetic, [HL7Enumerations hl7NameUseFromString:@"PHON"]);
    XCTAssertEqual(HL7UseNameTypeSearchSoundex, [HL7Enumerations hl7NameUseFromString:@"SNDX"]);
    XCTAssertEqual(HL7UseNameTypeAlphabetic, [HL7Enumerations hl7NameUseFromString:@"ABC"]);
    XCTAssertEqual(HL7UseNameTypeSyllabic, [HL7Enumerations hl7NameUseFromString:@"SYL"]);
    XCTAssertEqual(HL7UseNameTypeIdeographic, [HL7Enumerations hl7NameUseFromString:@"IDE"]);
}

- (void)testUseTelecomFromString
{
    XCTAssertEqual(HL7UseTelecomTypeUnknown, [HL7Enumerations hl7TelecomUseFromString:@"XXX"]);
    XCTAssertEqual(HL7UseTelecomTypeHome, [HL7Enumerations hl7TelecomUseFromString:@"H"]);
    XCTAssertEqual(HL7UseTelecomTypeHomePrimary, [HL7Enumerations hl7TelecomUseFromString:@"HP"]);
    XCTAssertEqual(HL7UseTelecomTypeHomeVacation, [HL7Enumerations hl7TelecomUseFromString:@"HV"]);
    XCTAssertEqual(HL7UseTelecomTypeWorkPlace, [HL7Enumerations hl7TelecomUseFromString:@"WP"]);
    XCTAssertEqual(HL7UseTelecomTypeDirect, [HL7Enumerations hl7TelecomUseFromString:@"DIR"]);
    XCTAssertEqual(HL7UseTelecomTypePublic, [HL7Enumerations hl7TelecomUseFromString:@"PUB"]);
    XCTAssertEqual(HL7UseTelecomTypeBad, [HL7Enumerations hl7TelecomUseFromString:@"BAD"]);
    XCTAssertEqual(HL7UseTelecomTypeTemporary, [HL7Enumerations hl7TelecomUseFromString:@"TMP"]);
    XCTAssertEqual(HL7UseTelecomTypeAnsweringMachine, [HL7Enumerations hl7TelecomUseFromString:@"AS"]);
    XCTAssertEqual(HL7UseTelecomTypeEmergencyContact, [HL7Enumerations hl7TelecomUseFromString:@"EC"]);
    XCTAssertEqual(HL7UseTelecomTypeMobileContact, [HL7Enumerations hl7TelecomUseFromString:@"MC"]);
    XCTAssertEqual(HL7UseTelecomTypePager, [HL7Enumerations hl7TelecomUseFromString:@"PG"]);
}
@end
