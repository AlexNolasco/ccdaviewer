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


#import "HL7SectionParser.h"
#import "HL7Const.h"
#import "HL7Section.h"
#import "HL7ElementParser+Additions.h"
#import "HL7Entry.h"
#import "ObjectiveSugar.h"
#import "IGXMLReader+Additions.h"
#import "ParserContext.h"
#import "ParserPlan.h"
#import "HelperMacros.h"

@implementation HL7SectionParser

- (NSString *)designatedElementName
{
    return HL7ElementSection;
}

- (NSString *)templateId
{
    return @"";
}

- (BOOL)supportsEntries
{
    return NO;
}

- (NSString *_Nullable)name
{
    NSString *key = [NSString stringWithFormat:@"%@.%@", @"parser", [self templateId]];
    return LOCALIZED_STRING(key);
}

- (HL7Entry *_Nullable)createEntryWithNode:(IGXMLReader *_Nonnull)node
{
    if (![self supportsEntries]) {
        return nil;
    } else {
        return [[HL7Entry alloc] initWithTypeCode:[node attributeWithName:HL7AttributeTypeCode]];
    }
}

- (HL7Section *)createSectionFromSection:(HL7Section *)section
{
    return nil;
}

- (void)parse:(ParserContext *)context node:(IGXMLReader *)node into:(HL7Entry *)entry error:(NSError *__autoreleasing *)error
{
}

- (ParserPlan *)createParsePlan:(ParserContext *)context HL7Element:(HL7Section *)section error:(NSError *__autoreleasing *)error
{

    NSAssert([ParserPlan plan] != nil, @"should have value");
    ParserPlan *plan = [ParserPlan planAtDepth:[[context reader] depth]];

    // template Id
    [plan when:HL7ElementTemplateId
        parseWithBlock:^(ParserContext *context, IGXMLReader *node, BOOL *stop) {
            [[section templateIds] addObject:[HL7ElementParser templateIdFromReader:node]];
        }];

    // Code
    [plan when:HL7ElementCode
        parseWithBlock:^(ParserContext *context, IGXMLReader *node, BOOL *stop) {
            [section setCode:[HL7ElementParser codeFromReader:node]];
        }];

    // Title
    [plan when:HL7ElementTitle
        parseWithBlock:^(ParserContext *context, IGXMLReader *node, BOOL *stop) {
            [section setTitle:[[[node text] strip] copy]];
        }];

    // Element text
    [plan when:HL7ElementText
        parseWithBlock:^(ParserContext *context, IGXMLReader *node, BOOL *stop) {
            [section setText:[HL7ElementParser textFromReader:node]];
        }];

    // Entries
    if ([self supportsEntries]) {
        [plan when:HL7ElementEntry
            parseWithBlock:^(ParserContext *context, IGXMLReader *node, BOOL *stop) {
                // each entry
                HL7Entry *entry = [self createEntryWithNode:node];
                if ([node hasAttributes]) {
                    [entry setTypeCode:[node attributeWithName:HL7AttributeTypeCode]];
                }
                [entry setParentSection:[context section]];
                [self iterate:context
                    untilEndOfElementName:HL7ElementEntry
                               usingBlock:^(ParserContext *context, BOOL *stop) {
                                   [self parse:context node:[context node] into:entry error:error];
                               }];
            }];
    }
    return plan;
}

- (BOOL)parse:(ParserContext *)context error:(NSError *__autoreleasing *)error
{
    ParserPlan *plan = [self createParsePlan:context HL7Element:[context section] error:error];

    [self iterate:context
        usingBlock:^(ParserContext *context, BOOL *stop) {
            [self parse:context usingPlan:plan stop:stop];
        }];
    return YES;
}
@end
