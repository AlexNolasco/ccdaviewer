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


#import "IGXMLReader.h"
#import "IGXMLReader+Additions.h"
#import "ParserContext.h"
#import "ParserPlan.h"
#import "HL7AllergySectionParser.h"
#import "HL7Const.h"
#import "HL7Entry.h"
#import "HL7CCD.h"
#import "HL7AllergySection.h"
#import "HL7AllergyConcernAct.h"
#import "HL7ActParser.h"
#import "HL7AllergyConcernAct.h"
#import "HL7AllergyConcernActParser.h"
#import "HL7AllergyEntry.h"

@implementation HL7AllergySectionParser

- (NSString *)templateId
{
    return HL7TemplateAllergySectionEntriesRequired;
}

- (BOOL)supportsEntries
{
    return YES;
}

- (nullable HL7Section *)createSectionFromSection:(nullable HL7Section *)section
{
    return [[HL7AllergySection alloc] initWithSection:section];
}

- (HL7Entry *_Nullable)createEntryWithNode:(IGXMLReader *_Nonnull)node
{
    return [[HL7AllergyEntry alloc] initWithTypeCode:[node attributeWithName:HL7AttributeTypeCode]];
}

- (void)parse:(ParserContext *)context node:(IGXMLReader *)node into:(HL7Entry *)entry error:(NSError *__autoreleasing *)error
{
    HL7AllergySection *section = (HL7AllergySection *)[context section];

    if ([node isStartOfElementWithName:HL7ElementEntry]) { // Add entry
        [[section entries] addObject:entry];
    } else if ([node isStartOfElementWithName:HL7ElementAct]) {
        // Contains exactly one [1..1] Allergy Problem Act (templateId: 2.16.840.1.113883.10.20.22.4.30)
        HL7AllergyConcernAct *allergyConcernAct = [[HL7AllergyConcernAct alloc] init];
        [context setElement:allergyConcernAct];
        [[HL7AllergyConcernActParser new] parse:context error:error];
        [((HL7AllergyEntry *)entry) setProblemAct:allergyConcernAct];
    }
}

- (BOOL)parse:(ParserContext *)context error:(NSError *__autoreleasing *)error
{
    [super parse:context error:error];
    [[[context hl7ccd] sections] addObject:[context section]];
    return YES;
}
@end
