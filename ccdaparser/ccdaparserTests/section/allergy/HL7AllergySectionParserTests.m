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
#import "HL7ActParser.h"
#import "HL7AllergyConcernAct.h"
#import "HL7AllergyConcernAct.h"
#import "HL7AllergyEntry+Additions.h"
#import "HL7AllergyEntry.h"
#import "HL7AllergyObservation.h"
#import "HL7AllergySection.h"
#import "HL7AllergySectionParser.h"
#import "HL7CCD.h"
#import "HL7CCDParser.h"
#import "HL7CCDParserDelegateProtocol.h"
#import "HL7Const.h"
#import "HL7ElementStructureBodyProtocol.h"
#import "HL7Entry.h"
#import "HL7EntryRelationship.h"
#import "HL7Enums.h"
#import "HL7SectionMapperProtocol.h"
#import "HL7TemplateId.h"
#import "HL7Text.h"
#import "IGXMLReader+Additions.h"
#import "IGXMLReader.h"
#import "ParserContext.h"
#import "ParserPlan.h"

@interface HL7AllergySectionParserTests : XCTestCase <HL7CCDParserDelegateProtocol>
@end

@implementation HL7AllergySectionParserTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each
    // test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each
    // test method in the class.
    [super tearDown];
}

#pragma mark -
- (void)willParseSectionsWithMapping:(id<HL7SectionMapperProtocol>)mapper
{
    [mapper enableParsers:[[NSSet alloc] initWithArray:@[ HL7TemplateAllergySectionEntriesRequired ]]];
}

#pragma mark -
- (void)testEmpty
{
    NSString *xml = @"<section/>";
    NSError *error;
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];
    HL7CCD *ccd = [[HL7CCD alloc] init];
    HL7Section *section = [[HL7Section alloc] init];
    HL7AllergySectionParser *allergySectionParser = [[HL7AllergySectionParser alloc] init];
    HL7AllergySection *allergySection = (HL7AllergySection *)[allergySectionParser createSectionFromSection:section];
    ParserContext *parserContext = [[ParserContext alloc] initWithReader:reader hl7ccd:ccd];

    // prepare
    [parserContext setSection:allergySection];

    // execute
    [allergySectionParser parse:parserContext error:&error];

    // assert
    XCTAssertNil(error);
    XCTAssertTrue([[allergySectionParser templateId] isEqualToString:@"2.16.840.1.113883.10.20.22.2.6.1"]);
    XCTAssertTrue([allergySectionParser supportsEntries]);
    XCTAssertTrue([[ccd sections] count] == 1);
}

- (void)testNoEntries
{
    NSString *xml = @"<section>"
                    @"<code code=\"48765-2\" codeSystem=\"2.16.840.1.113883.6.1\" "
                    @"codeSystemName=\"LOINC\"/>"
                    @"<title>t</title>"
                    @"<text>x</text>"
                    @"</section>";

    NSError *error;
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];
    HL7CCD *ccd = [[HL7CCD alloc] init];
    HL7Section *section = [[HL7Section alloc] init];
    HL7AllergySectionParser *allergySectionParser = [[HL7AllergySectionParser alloc] init];
    HL7AllergySection *allergySection = (HL7AllergySection *)[allergySectionParser createSectionFromSection:section];
    ParserContext *parserContext = [[ParserContext alloc] initWithReader:reader hl7ccd:ccd];

    // prepare
    [parserContext setSection:allergySection];

    // execute
    [allergySectionParser parse:parserContext error:&error];

    // assert
    XCTAssertNil(error);
    XCTAssertTrue([[ccd sections] count] == 1);
    XCTAssertNotNil([allergySection code]);
    XCTAssertNotNil([allergySection text]);
    XCTAssertNotNil([allergySection title]);
}

- (void)testNoKnownAllergies
{
    NSString *xml = @"<section>"
                    @"<code code=\"48765-2\" codeSystem=\"2.16.840.1.113883.6.1\" "
                    @"codeSystemName=\"LOINC\"/>"
                    @"<title>t</title>"
                    @"<text>x</text>"
                    @"<entry typeCode=\"DRIV\">"
                    @"<act classCode=\"ACT\" moodCode=\"EVN\">"
                    @"<entryRelationship typeCode=\"SUBJ\">"
                    @"<observation classCode=\"OBS\" moodCode=\"EVN\" negationInd=\"true\">"
                    @"<templateId root=\"2.16.840.1.113883.10.20.22.4.7\" />"
                    @"<code code=\"ASSERTION\" codeSystem=\"2.16.840.1.113883.5.4\" />"
                    @"<statusCode code=\"completed\" />"
                    @"<value xsi:type=\"CD\" code=\"419199007\" displayName=\"Allergy to "
                    @"substance (disorder)\" codeSystem=\"2.16.840.1.113883.6.96\" "
                    @"codeSystemName=\"SNOMED CT\" />"
                    @"</observation>"
                    @"</entryRelationship>"
                    @"</act>"
                    @"</entry>"
                    @"</section>";

    NSError *error;
    HL7CCD *ccd = [[HL7CCD alloc] init];
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];
    HL7Section *section = [[HL7Section alloc] init];
    HL7AllergySectionParser *allergySectionParser = [[HL7AllergySectionParser alloc] init];
    HL7AllergySection *allergySection = (HL7AllergySection *)[allergySectionParser createSectionFromSection:section];
    ParserContext *parserContext = [self createContextFromString:xml ccd:ccd reader:reader];

    // prepare
    [parserContext setSection:allergySection];

    // execute
    [allergySectionParser parse:parserContext error:&error];

    // assert
    XCTAssertNil(error);
    XCTAssertTrue([allergySection noKnownAllergiesFound]);
    XCTAssertFalse([allergySection noKnownMedicationAllergiesFound]);
}

- (void)testNoKnownMedicationAllergies
{
    NSString *xml = @"<section>"
                    @"<code code=\"48765-2\" codeSystem=\"2.16.840.1.113883.6.1\" "
                    @"codeSystemName=\"LOINC\"/>"
                    @"<title>t</title>"
                    @"<text>x</text>"
                    @"<entry typeCode=\"DRIV\">"
                    @"<act classCode=\"ACT\" moodCode=\"EVN\">"
                    @"<entryRelationship typeCode=\"SUBJ\">"
                    @"<observation classCode=\"OBS\" moodCode=\"EVN\" negationInd=\"true\">"
                    @"<templateId root=\"2.16.840.1.113883.10.20.22.4.7\" />"
                    @"<code code=\"ASSERTION\" codeSystem=\"2.16.840.1.113883.5.4\" />"
                    @"<statusCode code=\"completed\" />"
                    @"<value xsi:type=\"CD\" code=\"416098002\" displayName=\"Allergy to "
                    @"medication\" codeSystem=\"2.16.840.1.113883.6.96\" "
                    @"codeSystemName=\"SNOMED CT\" />"
                    @"</observation>"
                    @"</entryRelationship>"
                    @"</act>"
                    @"</entry>"
                    @"</section>";

    NSError *error;
    HL7CCD *ccd = [[HL7CCD alloc] init];
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];
    HL7Section *section = [[HL7Section alloc] init];
    HL7AllergySectionParser *allergySectionParser = [[HL7AllergySectionParser alloc] init];
    HL7AllergySection *allergySection = (HL7AllergySection *)[allergySectionParser createSectionFromSection:section];
    ParserContext *parserContext = [self createContextFromString:xml ccd:ccd reader:reader];

    // prepare
    [parserContext setSection:allergySection];

    // execute
    [allergySectionParser parse:parserContext error:&error];

    // assert
    XCTAssertNil(error);
    XCTAssertFalse([allergySection noKnownAllergiesFound]);
    XCTAssertTrue([allergySection noKnownMedicationAllergiesFound]);
}

- (ParserContext *)createContextFromString:(NSString *)xml ccd:(HL7CCD *)ccd reader:(IGXMLReader *)reader
{
    ParserContext *parserContext = [[ParserContext alloc] initWithReader:reader hl7ccd:ccd];
    return parserContext;
}

- (void)testActEntryRelationshipObservation
{
    NSString *xml = @"<section>"
                    @"<code code=\"48765-2\" codeSystem=\"2.16.840.1.113883.6.1\" "
                    @"codeSystemName=\"LOINC\"/>"
                    @"<title>t</title>"
                    @"<text>x</text>"
                    @"<entry typeCode=\"DRIV\">"
                    @"<act classCode=\"ACT\" moodCode=\"EVN\">"
                    @"<entryRelationship typeCode=\"SUBJ\" inversionInd=\"true\">"
                    @"<observation classCode=\"OBS\" moodCode=\"EVN\">"
                    @"<templateId root=\"2.16.840.1.113883.10.20.22.4.7\" />"
                    @"<code code=\"ASSERTION\" codeSystem=\"2.16.840.1.113883.5.4\" />"
                    @"<statusCode code=\"completed\" />"
                    @"</observation>"
                    @"</entryRelationship>"
                    @"</act>"
                    @"</entry>"
                    @"</section>";

    NSError *error;
    HL7CCD *ccd = [[HL7CCD alloc] init];
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];
    HL7AllergySectionParser *allergySectionParser = [[HL7AllergySectionParser alloc] init];
    HL7AllergySection *allergySection = (HL7AllergySection *)[allergySectionParser createSectionFromSection:[[HL7Section alloc] init]];
    ParserContext *parserContext = [self createContextFromString:xml ccd:ccd reader:reader];

    // prepare
    [parserContext setSection:allergySection];

    // execute
    [allergySectionParser parse:parserContext error:&error];

    // assert
    XCTAssertNil(error);
    XCTAssertTrue([[ccd sections] count] == 1);
    XCTAssertNotNil([allergySection title]);
    XCTAssertTrue([[allergySection title] isEqualToString:@"t"]);
    XCTAssertTrue([[[allergySection text] text] isEqualToString:@"x"]);
    XCTAssertNotNil([allergySection code]);
    XCTAssertNotNil([allergySection text]);
    XCTAssertTrue([[allergySection entries] count] == 1);
    XCTAssertTrue([[[[allergySection entries] objectAtIndex:0] typeCode] isEqualToString:@"DRIV"]);

    HL7AllergyEntry *entry = [[allergySection entries] firstObject];
    XCTAssertNotNil([entry problemAct]);
    XCTAssertTrue([[[entry problemAct] classCode] isEqualToString:@"ACT"]);
    XCTAssertTrue([[[entry problemAct] moodCode] isEqualToString:@"EVN"]);
    XCTAssertNotNil([entry allergen]);
    XCTAssertNil([entry severity]);
    XCTAssertTrue([[entry reactions] count] == 0);

    HL7AllergyConcernAct *concernAct = [entry problemAct];
    XCTAssertNotNil([concernAct firstEntryRelationship]);
    XCTAssertTrue([[[concernAct firstEntryRelationship] typeCode] isEqualToString:@"SUBJ"]);
    XCTAssertTrue([[[concernAct firstEntryRelationship] inversionInd] isEqualToString:@"true"]);

    HL7EntryRelationship *entryRelationship = [concernAct firstEntryRelationship];
    XCTAssertTrue([[entryRelationship descendants] count] == 1);
    HL7AllergyObservation *allergyObservation = [[entryRelationship descendants] firstObject];
    XCTAssertTrue([[allergyObservation classCode] isEqualToString:@"OBS"]);
    XCTAssertTrue([[allergyObservation moodCode] isEqualToString:@"EVN"]);
    XCTAssertFalse([allergySection noKnownAllergiesFound]);
    XCTAssertFalse([allergySection noKnownMedicationAllergiesFound]);
}

- (void)testEntryMultipleEntryRelationships
{
    NSString *xml = @"<section>"
                    @"<code code=\"48765-2\" codeSystem=\"2.16.840.1.113883.6.1\" "
                    @"codeSystemName=\"LOINC\"/>"
                    @"<title>t</title>"
                    @"<text>x</text>"
                    @"<entry typeCode=\"DRIV\">"
                    @"<act classCode=\"ACT\" moodCode=\"EVN\">"

                    @"<entryRelationship typeCode=\"SUBJ\">"
                    @"<observation classCode=\"OBS\" moodCode=\"EVN\">"
                    @"<templateId root=\"2.16.840.1.113883.10.20.22.4.7\" />"

                     "<!-- severity?-->"
                    @"<entryRelationship typeCode=\"SUBJ\" inversionInd=\"true\">"
                    @"<observation classCode=\"OBS\" moodCode=\"EVN\">"
                    @"<templateId root=\"2.16.840.1.113883.10.20.22.4.8\" />"
                    @"</observation>"
                    @"</entryRelationship>"

                    @"<entryRelationship typeCode=\"MFST\" inversionInd=\"true\">"
                    @"<observation classCode=\"OBS\" moodCode=\"EVN\">"
                    @"<templateId root=\"2.16.840.1.113883.10.20.22.4.9\" />"
                    @"<entryRelationship typeCode=\"SUBJ\" inversionInd=\"true\">"
                    @"<!-- ** Severity observation ** -->"
                    @"<observation classCode=\"OBS\" moodCode=\"EVN\">"
                    @"</observation>"
                    @"</entryRelationship>"
                    @"</observation>"
                    @"</entryRelationship>"

                    @"</observation>"
                    @"</entryRelationship>"

                    @"</act>"
                    @"</entry>"
                    @"</section>";

    NSError *error;
    HL7CCD *ccd = [[HL7CCD alloc] init];
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xml];
    HL7AllergySectionParser *allergySectionParser = [[HL7AllergySectionParser alloc] init];
    HL7AllergySection *allergySection = (HL7AllergySection *)[allergySectionParser createSectionFromSection:[[HL7Section alloc] init]];
    ParserContext *parserContext = [self createContextFromString:xml ccd:ccd reader:reader];

    // prepare
    [parserContext setSection:allergySection];

    // execute
    [allergySectionParser parse:parserContext error:&error];

    // assert
    XCTAssertNil(error);
    XCTAssertTrue([[ccd sections] count] == 1);
    XCTAssertNotNil([allergySection title]);
    XCTAssertNotNil([allergySection code]);
    XCTAssertNotNil([allergySection text]);
    XCTAssertTrue([[allergySection entries] count] == 1);
    HL7AllergyEntry *entry = [[allergySection entries] firstObject];
    XCTAssertNotNil([entry problemAct]);
    XCTAssertNotNil([entry severity]);
    XCTAssertTrue([[entry reactions] count] == 1);
    HL7AllergyConcernAct *concernAct = [entry problemAct];
    XCTAssertNotNil([concernAct firstEntryRelationship]);
    HL7EntryRelationship *entryRelationship = [concernAct firstEntryRelationship];
    XCTAssertTrue([[entryRelationship descendants] count] == 1);
    HL7AllergyObservation *allergyObservation = (HL7AllergyObservation *)[[entryRelationship descendants] firstObject];
    XCTAssertNotNil(allergyObservation);
    XCTAssertNotNil([allergyObservation severity]);
    XCTAssertTrue([[allergyObservation descendants] count] == 2);
    entryRelationship = [[allergyObservation descendants] objectAtIndex:0];
    XCTAssertTrue([[entryRelationship descendants] count] == 1);
    HL7AllergyObservation *subAllergyObservation = [[entryRelationship descendants] objectAtIndex:0];
    XCTAssertTrue([[subAllergyObservation descendants] count] == 0);
    entryRelationship = [[allergyObservation descendants] objectAtIndex:1];
    XCTAssertTrue([[entryRelationship descendants] count] == 1);
    subAllergyObservation = [[entryRelationship descendants] objectAtIndex:0];
    XCTAssertTrue([[subAllergyObservation descendants] count] == 1);
    entryRelationship = [[subAllergyObservation descendants] objectAtIndex:0];
    XCTAssertTrue([[entryRelationship descendants] count] == 1);
    subAllergyObservation = [[entryRelationship descendants] objectAtIndex:0];
    XCTAssertTrue([[subAllergyObservation descendants] count] == 0);
    XCTAssertFalse([allergySection noKnownAllergiesFound]);
    XCTAssertFalse([allergySection noKnownMedicationAllergiesFound]);
}

#pragma mark integration tests
- (void)testCCDAllScriptsEnterpriseEHR
{
    HL7CCDParser *parser = [HL7CCDParser new];
    NSError *error;
    [parser setDelegate:self];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:@"allscripts" ofType:@"xml"];

    // execute
    HL7CCD *ccd = [parser parseXMLFilePath:resource error:&error];

    // assert
    HL7AllergySection *allergySection = (HL7AllergySection *)[ccd getSectionByTemplateId:HL7TemplateAllergySectionEntriesRequired];
    XCTAssertNil(error);
    XCTAssertNotNil(ccd);
    XCTAssertEqual([[allergySection entries] count], 2);
    HL7AllergyEntry *entry1 = [[allergySection entries] objectAtIndex:0];
    XCTAssertNotNil([entry1 status]);
    HL7AllergyEntry *entry2 = [[allergySection entries] objectAtIndex:1];
    XCTAssertNotNil([entry2 status]);
    XCTAssertFalse([allergySection noKnownAllergiesFound]);
    XCTAssertFalse([allergySection noKnownMedicationAllergiesFound]);
    XCTAssertNotNil([[[allergySection entries] objectAtIndex:0] problemAct]);
    XCTAssertNotNil([[[allergySection entries] objectAtIndex:1] problemAct]);
    XCTAssertTrue([[[[allergySection entries] objectAtIndex:0] getAllergenUsingSectionTextAsReference:[allergySection text]] isEqualToString:@"Codeine"]);
    XCTAssertTrue([[[[allergySection entries] objectAtIndex:0] getFirstReactionNameUsingSectionTextAsReference:[allergySection text]] isEqualToString:@"Nausea"]);
    XCTAssertTrue([[[[allergySection entries] objectAtIndex:1] getAllergenUsingSectionTextAsReference:[allergySection text]] isEqualToString:@"Penicillin G Potassium SOLR"]);
    XCTAssertTrue([[[[allergySection entries] objectAtIndex:1] getFirstReactionNameUsingSectionTextAsReference:[allergySection text]] isEqualToString:@"Hives"]);
}

- (void)testCCDNextGen
{
    HL7CCDParser *parser = [HL7CCDParser new];
    NSError *error;
    [parser setDelegate:self];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:@"nextgen" ofType:@"xml"];

    // execute
    HL7CCD *ccd = [parser parseXMLFilePath:resource error:&error];

    // assert
    HL7AllergySection *section = (HL7AllergySection *)[ccd getSectionByTemplateId:HL7TemplateAllergySectionEntriesRequired];
    XCTAssertNil(error);
    XCTAssertNotNil(ccd);
    XCTAssertNotNil(section);
    XCTAssertTrue([[section entries] count] == 3);
    XCTAssertFalse([section noKnownAllergiesFound]);
    XCTAssertFalse([section noKnownMedicationAllergiesFound]);
    XCTAssertNotNil([[[section entries] objectAtIndex:0] problemAct]);
    XCTAssertNotNil([[[section entries] objectAtIndex:1] problemAct]);
    XCTAssertNotNil([[[section entries] objectAtIndex:2] problemAct]);
    XCTAssertTrue([[[[section entries] objectAtIndex:0] getAllergenUsingSectionTextAsReference:[section text]] isEqualToString:@"Codeine"]);
    XCTAssertTrue([[[[section entries] objectAtIndex:0] getFirstReactionNameUsingSectionTextAsReference:[section text]] isEqualToString:@"Shortness of Breath"]);
    XCTAssertTrue([[[[section entries] objectAtIndex:1] getAllergenUsingSectionTextAsReference:[section text]] isEqualToString:@"Aspirin"]);
    XCTAssertTrue([[[[section entries] objectAtIndex:1] getFirstReactionNameUsingSectionTextAsReference:[section text]] isEqualToString:@"Hives"]);
    XCTAssertTrue([[[[section entries] objectAtIndex:2] getAllergenUsingSectionTextAsReference:[section text]] isEqualToString:@"penicillin G benzathine"]);
    XCTAssertTrue([[[[section entries] objectAtIndex:2] getFirstReactionNameUsingSectionTextAsReference:[section text]] isEqualToString:@"Hives"]);
}

- (void)testCCDVitera
{
    HL7CCDParser *parser = [HL7CCDParser new];
    NSError *error;
    [parser setDelegate:self];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:@"vitera" ofType:@"xml"];

    // execute
    HL7CCD *ccd = [parser parseXMLFilePath:resource error:&error];

    // assert
    HL7AllergySection *section = (HL7AllergySection *)[ccd getSectionByTemplateId:HL7TemplateAllergySectionEntriesRequired];
    XCTAssertNil(error);
    XCTAssertNotNil(ccd);
    XCTAssertNotNil(section);
    XCTAssertEqual([[section entries] count], 5);
    XCTAssertFalse([section noKnownAllergiesFound]);
    XCTAssertFalse([section noKnownMedicationAllergiesFound]);
    XCTAssertNotNil([[[section entries] objectAtIndex:0] problemAct]);
    XCTAssertNotNil([[[section entries] objectAtIndex:1] problemAct]);
    XCTAssertNotNil([[[section entries] objectAtIndex:2] problemAct]);
    XCTAssertNotNil([[[section entries] objectAtIndex:3] problemAct]);
    XCTAssertNotNil([[[section entries] objectAtIndex:4] problemAct]);
    XCTAssertTrue([[[[section entries] objectAtIndex:0] getAllergenUsingSectionTextAsReference:[section text]] isEqualToString:@"Ragweed"]);
    XCTAssertTrue([[[[section entries] objectAtIndex:0] getFirstReactionNameUsingSectionTextAsReference:[section text]] isEqualToString:@"Itchy eyes and nasal congestion"]);
    XCTAssertTrue([[[[section entries] objectAtIndex:1] getAllergenUsingSectionTextAsReference:[section text]] isEqualToString:@"Latex"]);
    XCTAssertTrue([[[[section entries] objectAtIndex:1] getFirstReactionNameUsingSectionTextAsReference:[section text]] isEqualToString:@"Skin Rashes/Hives"]);
    XCTAssertTrue([[[[section entries] objectAtIndex:2] getAllergenUsingSectionTextAsReference:[section text]] isEqualToString:@"Aspirin 325 MG / butalbital 50 MG / Caffeine 40 MG / "
                                                                                                                               @"Codeine 30 MG Oral Capsule"]);
    XCTAssertTrue([[[[section entries] objectAtIndex:2] getFirstReactionNameUsingSectionTextAsReference:[section text]] isEqualToString:@"Nausea/Vomiting/Diarrhea"]);
    XCTAssertTrue([[[[section entries] objectAtIndex:3] getAllergenUsingSectionTextAsReference:[section text]] isEqualToString:@"Cheese"]);
    XCTAssertTrue([[[[section entries] objectAtIndex:3] getFirstReactionNameUsingSectionTextAsReference:[section text]] isEqualToString:@"Nausea/Vomiting/Diarrhea"]);
    XCTAssertTrue([[[[section entries] objectAtIndex:4] getAllergenUsingSectionTextAsReference:[section text]] isEqualToString:@"Birds"]);
    XCTAssertTrue([[[[section entries] objectAtIndex:4] getFirstReactionNameUsingSectionTextAsReference:[section text]] isEqualToString:@"Skin Rashes/Hives, Nausea/Vomiting/Diarrhea"]);
}

- (void)testEmerge
{
    HL7CCDParser *parser = [HL7CCDParser new];
    NSError *error;
    [parser setDelegate:self];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:@"emerge" ofType:@"xml"];

    // execute
    HL7CCD *ccd = [parser parseXMLFilePath:resource error:&error];

    // assert
    HL7AllergySection *section = (HL7AllergySection *)[ccd getSectionByTemplateId:HL7TemplateAllergySectionEntriesRequired];
    XCTAssertNil(error);
    XCTAssertNotNil(ccd);
    XCTAssertNotNil(section);
    XCTAssertEqual([[section entries] count], 3);
    XCTAssertFalse([section noKnownAllergiesFound]);
    XCTAssertFalse([section noKnownMedicationAllergiesFound]);
    XCTAssertNotNil([[[section entries] objectAtIndex:0] problemAct]);
    XCTAssertNotNil([[[[section entries] objectAtIndex:0] problemAct] code]);
    XCTAssertNotNil([[[[section entries] objectAtIndex:0] problemAct] statusCode]);
    XCTAssertNotNil([[[[section entries] objectAtIndex:0] problemAct] effectiveTime]);
    XCTAssertNotNil([[[[section entries] objectAtIndex:0] problemAct] identifier]);
    XCTAssertNotNil([[[section entries] objectAtIndex:1] problemAct]);
    XCTAssertNotNil([[[[section entries] objectAtIndex:1] problemAct] code]);
    XCTAssertNotNil([[[[section entries] objectAtIndex:1] problemAct] statusCode]);
    XCTAssertNotNil([[[[section entries] objectAtIndex:1] problemAct] effectiveTime]);
    XCTAssertNotNil([[[[section entries] objectAtIndex:1] problemAct] identifier]);
    XCTAssertNotNil([[[section entries] objectAtIndex:2] problemAct]);
    XCTAssertNotNil([[[[section entries] objectAtIndex:2] problemAct] code]);
    XCTAssertNotNil([[[[section entries] objectAtIndex:2] problemAct] statusCode]);
    XCTAssertNotNil([[[[section entries] objectAtIndex:2] problemAct] effectiveTime]);
    XCTAssertNotNil([[[[section entries] objectAtIndex:2] problemAct] identifier]);
    XCTAssertTrue([[[[section entries] objectAtIndex:0] getAllergenUsingSectionTextAsReference:[section text]] isEqualToString:@"Eggs"]);
    XCTAssertTrue([[[[section entries] objectAtIndex:1] getAllergenUsingSectionTextAsReference:[section text]] isEqualToString:@"Amikacin Sulfate 50 MG/ML Injectable Solution"]);
    XCTAssertTrue([[[[section entries] objectAtIndex:2] getAllergenUsingSectionTextAsReference:[section text]] isEqualToString:@"Penicillin V"]);
}
@end
