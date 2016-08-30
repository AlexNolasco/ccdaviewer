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


#import "HL7ProcedureSectionParser.h"
#import "HL7Const.h"
#import "HL7CCD.h"
#import "HL7ProcedureActivityProcedure.h"
#import "HL7ProcedureSection.h"
#import "HL7ProcedureEntry.h"
#import "HL7ProcedureActivityProcedureParser.h"
#import "HL7ProcedureActivityObservation.h"
#import "HL7ProcedureActivityAct.h"
#import "HL7ProcedureObservationParser.h"
#import "HL7ProcedureActivityActParser.h"
#import "HL7ActParser.h"
#import "IGXMLReader.h"
#import "IGXMLReader+Additions.h"
#import "ParserContext.h"

@implementation HL7ProcedureSectionParser
- (NSString *)templateId
{
    return HL7TemplateProcedures;
}

- (BOOL)supportsEntries
{
    return YES;
}

- (nullable HL7Section *)createSectionFromSection:(nullable HL7Section *)section
{
    return [[HL7ProcedureSection alloc] initWithSection:section];
}

- (HL7Entry *_Nullable)createEntryWithNode:(IGXMLReader *_Nonnull)node
{
    return [[HL7ProcedureEntry alloc] initWithTypeCode:[node attributeWithName:HL7AttributeTypeCode]];
}

- (void)parse:(ParserContext *)context node:(IGXMLReader *)node into:(HL7Entry *)entry error:(NSError *__autoreleasing *)error
{
    HL7ProcedureSection *section = (HL7ProcedureSection *)[context section];

    if ([node isStartOfElementWithName:HL7ElementEntry]) {
        [[section entries] addObject:entry]; // Add entry
    } else if ([node isStartOfElementWithName:HL7ElementProcedure]) {
        HL7ProcedureActivityProcedure *procedure = [HL7ProcedureActivityProcedure new];
        [context setElement:procedure];

        [[HL7ProcedureActivityProcedureParser new] parse:context error:error];
        [((HL7ProcedureEntry *)entry) setProcedure:procedure];
    } else if ([node isStartOfElementWithName:HL7ElementObservation]) {
        HL7ProcedureActivityObservation *observation = [HL7ProcedureActivityObservation new];
        [context setElement:observation];

        [[HL7ProcedureObservationParser new] parse:context error:error];
        [((HL7ProcedureEntry *)entry) setObservation:observation];
    } else if ([node isStartOfElementWithName:HL7ElementAct]) {
        HL7ProcedureActivityAct *act = [HL7ProcedureActivityAct new];
        [context setElement:act];

        [[HL7ProcedureActivityActParser new] parse:context error:error];
        [((HL7ProcedureEntry *)entry) setAct:act];
    }
}

- (BOOL)parse:(ParserContext *)context error:(NSError *__autoreleasing *)error
{
    [super parse:context error:error];
    [[[context hl7ccd] sections] addObject:[context section]];
    return YES;
}
@end
