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


#import "HL7PlanOfCareSectionParser.h"
#import "HL7Const.h"
#import "HL7CCD.h"
#import "HL7PlanOfCareSection.h"
#import "HL7PlanOfCareEntry.h"
#import "HL7ActParser.h"
#import "HL7PlanOfCareActivityAct.h"
#import "HL7PlanOfCareObservation.h"
#import "HL7PlanOfCareEncounter.h"
#import "HL7PlanOfCareProcedure.h"
#import "HL7PlanOfCareActivitySupply.h"
#import "HL7ObservationParser.h"
#import "HL7PlanOfCareSubstanceAdministration.h"
#import "HL7TemplateElementParser.h"
#import "HL7SubstanceAdministration.h"
#import "HL7PlanOfCareElementParser.h"
#import "IGXMLReader.h"
#import "IGXMLReader+Additions.h"
#import "ParserContext.h"

@implementation HL7PlanOfCareSectionParser {
    NSUInteger _entryDepth;
}

- (NSString *)templateId
{
    return HL7TemplatePlanOfCare;
}

- (BOOL)supportsEntries
{
    return YES;
}

- (nullable HL7Section *)createSectionFromSection:(nullable HL7Section *)section
{
    return [[HL7PlanOfCareSection alloc] initWithSection:section];
}

- (HL7Entry *_Nullable)createEntryWithNode:(IGXMLReader *_Nonnull)node
{
    return [[HL7PlanOfCareEntry alloc] initWithTypeCode:[node attributeWithName:HL7AttributeTypeCode]];
}

- (void)parseNode:(IGXMLReader *)node withBlock:(void (^)(HL7ElementParser *parser, HL7TemplateElement *templateElement))blk
{
    if ([node depth] != _entryDepth) {
        return;
    }
    if ([node isStartOfElementWithName:HL7ElementAct]) {
        blk([[HL7ActParser alloc] init], [[HL7PlanOfCareActivityAct alloc] init]);
    } else if ([node isStartOfElementWithName:HL7ElementEncounter]) {
        blk([[HL7PlanOfCareElementParser alloc] init], [[HL7PlanOfCareEncounter alloc] init]);
    } else if ([node isStartOfElementWithName:HL7ElementObservation]) {
        blk([[HL7ObservationParser alloc] init], [[HL7PlanOfCareObservation alloc] init]);
    } else if ([node isStartOfElementWithName:HL7ElementProcedure]) {
        blk([[HL7PlanOfCareElementParser alloc] init], [[HL7PlanOfCareProcedure alloc] init]);
    } else if ([node isStartOfElementWithName:HL7ElementSubstanceAdministration]) {
        blk([[HL7PlanOfCareElementParser alloc] init], [[HL7PlanOfCareSubstanceAdministration alloc] init]);
    } else if ([node isStartOfElementWithName:HL7ElementSupply]) {
        blk([[HL7PlanOfCareElementParser alloc] init], [[HL7PlanOfCareActivitySupply alloc] init]);
    }
}

- (void)parse:(ParserContext *)context node:(IGXMLReader *)node into:(HL7Entry *)entry error:(NSError *__autoreleasing *)error
{

    HL7PlanOfCareSection *section = (HL7PlanOfCareSection *)[context section];
    if ([node isStartOfElementWithName:HL7ElementEntry]) {
        _entryDepth = [node depth] + 1;
        [[section entries] addObject:entry]; // Add entry
        return;
    }

    [self parseNode:node
          withBlock:^(HL7ElementParser *parser, HL7TemplateElement *element) {
              [context setElement:element];
              [parser parse:context error:error];
              [((HL7PlanOfCareEntry *)entry) setPlanOfCareActivity:element];
          }];
}

- (BOOL)parse:(ParserContext *)context error:(NSError *__autoreleasing *)error
{
    [super parse:context error:error];
    [[[context hl7ccd] sections] addObject:[context section]];
    return YES;
}
@end
