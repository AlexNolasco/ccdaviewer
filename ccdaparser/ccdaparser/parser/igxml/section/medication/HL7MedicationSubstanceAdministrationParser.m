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


#import "HL7MedicationSubstanceAdministrationParser.h"
#import "HL7Const.h"
#import "HL7SubstanceAdministration.h"
#import "HL7ManufacturedProduct.h"
#import "HL7ManufacturedMaterial.h"
#import "HL7ElementParser+Additions.h"
#import "HL7EffectiveTime.h"
#import "IGXMLReader.h"
#import "IGXMLReader+Additions.h"
#import "ParserPlan.h"
#import "ParserContext.h"

@implementation HL7MedicationSubstanceAdministrationParser

- (NSString *)designatedElementName
{
    return HL7ElementSubstanceAdministration;
}

- (ParserPlan *)createParsePlan:(ParserContext *)context HL7Element:(HL7SubstanceAdministration *)substanceAdministration error:(NSError *__autoreleasing *)error
{

    ParserPlan *plan = [super createParsePlan:context HL7Element:substanceAdministration error:error];

    [plan when:[self designatedElementName]
        parseWithBlock:^(ParserContext *context, IGXMLReader *node, BOOL *stop) {
            [substanceAdministration setClassCode:[node attributeWithName:HL7AttributeClassCode]];
            [substanceAdministration setMoodCode:[node attributeWithName:HL7AttributeMoodCode]];
        }];

    [plan always:HL7ElementEffectiveTime
        parseWithBlock:^(ParserContext *context, IGXMLReader *node, BOOL *stop) {
            HL7EffectiveTime *effectiveTime = [HL7ElementParser effectiveTimeFromReader:node];
            if ([effectiveTime xsiTimeInterval] == HL7XSITimeIntervalsContiguousTimeInterval) {
                [substanceAdministration setEffectiveTime:effectiveTime];
            } else if ([effectiveTime xsiTimeInterval] == HL7XSITimeIntervalsPeriodicTimeInterval) {
                [substanceAdministration setPeriodicTimeInterval:effectiveTime];
            }
        }];

    // route code
    [plan when:HL7ElementRouteCode
        parseWithBlock:^(ParserContext *context, IGXMLReader *node, BOOL *stop) {
            [substanceAdministration setRouteCode:[HL7ElementParser routeFromReader:node]];
        }];

    // dose
    [plan when:HL7ElementDoseQuantity
        parseWithBlock:^(ParserContext *context, IGXMLReader *node, BOOL *stop) {
            [substanceAdministration setDoseQuantity:[HL7ElementParser doseFromCodeReader:node]];
        }];

    // administration unit code
    [plan when:HL7ElementAdministrationUnitCode
        parseWithBlock:^(ParserContext *context, IGXMLReader *node, BOOL *stop) {
            [substanceAdministration setAdministrationUnitCode:[HL7ElementParser administrationUnitCodeFromReader:node]];
        }];

    // consumable / manufacturedProduct / manufacturedMaterial
    [plan when:HL7ElementConsumable
        parseWithBlock:^(ParserContext *context, IGXMLReader *node, BOOL *stop) {
            HL7ManufacturedProduct *manufacturedProduct = [[HL7ManufacturedProduct alloc] init];
            [self iterate:context
                untilEndOfElementName:HL7ElementConsumable
                           usingBlock:^(ParserContext *context, BOOL *stop) {

                               if ([[context reader] isStartOfElementWithName:HL7ElementTemplateId]) {
                                   [manufacturedProduct setTemplateId:[node attributeWithName:HL7AttributeRoot]];
                               } else if ([[context reader] isStartOfElementWithName:HL7ElementManufacturedMaterial]) {
                                   HL7ManufacturedMaterial *manufacturedMaterial = [[HL7ManufacturedMaterial alloc] init];
                                   [manufacturedProduct setManufacturedMaterial:manufacturedMaterial];

                                   [self iterate:context
                                       untilEndOfElementName:HL7ElementManufacturedMaterial
                                                  usingBlock:^(ParserContext *context, BOOL *stop) {
                                                      if ([[context reader] isStartOfElementWithName:HL7ElementCode]) {
                                                          [manufacturedMaterial setCode:[HL7ElementParser codeFromReader:[context reader]]];
                                                      } else if ([[context reader] isStartOfElementWithName:HL7ElementName]) {
                                                          [manufacturedMaterial setName:[[context reader] text]];
                                                      }
                                                  }];
                               }
                           }];
            [substanceAdministration setManufacturedProduct:manufacturedProduct];
        }];
    return plan;
}

- (BOOL)parse:(ParserContext *)context error:(NSError *__autoreleasing *)error
{

    ParserPlan *parserPlan = [self createParsePlan:context HL7Element:(HL7SubstanceAdministration *)[context element] error:error];
    [self iterate:(ParserContext *)context
        usingBlock:^(ParserContext *context, BOOL *stop) {
            [self parse:context usingPlan:parserPlan stop:stop];
        }];
    return YES;
}

@end
