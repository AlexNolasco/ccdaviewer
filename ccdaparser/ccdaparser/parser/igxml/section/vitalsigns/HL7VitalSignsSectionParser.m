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


#import "HL7VitalSignsSectionParser.h"
#import "HL7Const.h"
#import "HL7CCD.h"
#import "HL7VitalSignsSection.h"
#import "HL7VitalSignsEntry.h"
#import "HL7VitalSignsObservation.h"
#import "HL7VitalSignsComponentParser.h"
#import "HL7VitalSignsOrganizerParser.h"
#import "HL7VitalSignsOrganizer.h"
#import "IGXMLReader.h"
#import "IGXMLReader+Additions.h"
#import "ParserContext.h"

@implementation HL7VitalSignsSectionParser
- (NSString *)templateId
{
    return HL7TemplateVitalSignsEntriesRequired;
}

- (BOOL)supportsEntries
{
    return YES;
}

- (nullable HL7Section *)createSectionFromSection:(nullable HL7Section *)section
{
    return [[HL7VitalSignsSection alloc] initWithSection:section];
}

- (HL7Entry *_Nullable)createEntryWithNode:(IGXMLReader *_Nonnull)node
{
    return [[HL7VitalSignsEntry alloc] initWithTypeCode:[node attributeWithName:HL7AttributeTypeCode]];
}

- (void)parse:(ParserContext *)context node:(IGXMLReader *)node into:(HL7Entry *)entry error:(NSError *__autoreleasing *)error
{

    HL7VitalSignsSection *section = (HL7VitalSignsSection *)[context section];
    if ([node isStartOfElementWithName:HL7ElementEntry]) {
        [[section entries] addObject:entry]; // Add entry
    } else if ([node isStartOfElementWithName:HL7ElementOrganizer]) {

        HL7VitalSignsOrganizerParser *organizerParser = [[HL7VitalSignsOrganizerParser alloc] init];
        HL7VitalSignsOrganizer *organizer = [[HL7VitalSignsOrganizer alloc] init];
        HL7VitalSignsEntry *vitalSignsEntry = (HL7VitalSignsEntry *)entry;

        [vitalSignsEntry setOrganizer:organizer];
        [context setElement:organizer];
        [organizerParser parse:context error:error];
    }
}

- (BOOL)parse:(ParserContext *)context error:(NSError *__autoreleasing *)error
{
    [super parse:context error:error];
    [[[context hl7ccd] sections] addObject:[context section]];
    return YES;
}

@end
