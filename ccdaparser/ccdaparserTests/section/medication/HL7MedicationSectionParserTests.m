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


#import "HL7CCD.h"
#import "HL7CCDParser.h"
#import "HL7CCDParserDelegateProtocol.h"
#import "HL7Code.h"
#import "HL7Const.h"
#import "HL7Entry.h"
#import "HL7Enums.h"
#import "HL7ManufacturedMaterial.h"
#import "HL7ManufacturedProduct.h"
#import "HL7MedicationEntry.h"
#import "HL7MedicationSection.h"
#import "HL7SubstanceAdministration.h"
#import "IGXMLReader+Additions.h"
#import "IGXMLReader.h"
#import "ParserContext.h"
#import "ParserPlan.h"
#import <XCTest/XCTest.h>

@interface HL7MedicationSectionParserTests : XCTestCase <HL7CCDParserDelegateProtocol>
@end

@implementation HL7MedicationSectionParserTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

#pragma mark -

- (void)willParseSectionsWithMapping:(id<HL7SectionMapperProtocol>)mapper
{
    [mapper enableParsers:[[NSSet alloc] initWithArray:@[ HL7TemplateMedications ]]];
}

#pragma mark -

- (void)testHl7cdar2
{
    HL7CCDParser *parser = [HL7CCDParser new];
    NSError *error;
    [parser setDelegate:self];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:@"hl7cdar2" ofType:@"xml"];
    HL7MedicationEntry *entry;

    // execute
    HL7CCD *ccd = [parser parseXMLFilePath:resource error:&error];

    // assert
    HL7MedicationSection *section = (HL7MedicationSection *)[ccd getSectionByTemplateId:HL7TemplateMedications];

    XCTAssertNil(error);
    XCTAssertNotNil(ccd);
    XCTAssertNotNil(section);
    XCTAssertTrue([[section title] isEqualToString:@"MEDICATIONS"]);
    XCTAssertEqual([[section entries] count], 2);
    entry = [section entries][0];
    XCTAssertNotNil([entry substanceAdministration]);
    XCTAssertNotNil([[entry substanceAdministration] manufacturedProduct]);
    XCTAssertNotNil([[[entry substanceAdministration] manufacturedProduct] manufacturedMaterial]);
    XCTAssertTrue([[[[[[entry substanceAdministration] manufacturedProduct] manufacturedMaterial] code] displayName] isEqualToString:@"Proventil 0.09 MG/ACTUAT inhalant solution"]);
    XCTAssertTrue([[entry medicationName] isEqualToString:@"Proventil 0.09 MG/ACTUAT inhalant solution"]);
    entry = [section entries][1];
    XCTAssertNotNil([entry substanceAdministration]);
    XCTAssertNotNil([[entry substanceAdministration] manufacturedProduct]);
    XCTAssertNotNil([[[entry substanceAdministration] manufacturedProduct] manufacturedMaterial]);
    XCTAssertTrue([[[[[[entry substanceAdministration] manufacturedProduct] manufacturedMaterial] code] displayName] isEqualToString:@"Atenolol 25 MG Oral Tablet"]);
    XCTAssertTrue([[entry medicationName] isEqualToString:@"Atenolol 25 MG Oral Tablet"]);
    XCTAssertNotNil([entry manufacturedMaterial]);
    XCTAssertNotNil([entry manufacturedProduct]);
}
@end
