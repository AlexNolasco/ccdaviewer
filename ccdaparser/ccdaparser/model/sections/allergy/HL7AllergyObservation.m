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


#import "HL7Const.h"
#import "HL7AllergyObservation.h"
#import "HL7AllergySection.h"
#import "HL7Entry.h"
#import "HL7EntryRelationship.h"
#import "HL7TemplateId.h"
#import "HL7Value.h"
#import "HL7StatusCode.h"
#import "HL7Enums.h"
#import "HL7Codes.h"
#import "HL7Text.h"
#import "NSString+ObjectiveSugar.h"

@implementation HL7AllergyObservation

- (NSMutableArray<__kindof HL7Element *> *)descendants
{
    if (_descendants == nil) {
        _descendants = [[NSMutableArray alloc] init];
    }

    return _descendants;
}

- (void)addChildElement:(HL7Element *)element
{
    [[self descendants] addObject:element];
}

- (BOOL)noKnownAllergyTo:(NSString *)code in:(HL7AllergyObservation *)allergyObservation
{
    if ([allergyObservation isNegationIndTrue] && [[allergyObservation statusCode] equalsToValue:@[ StatusCodeCompleted, StatusCodeActive ]] && [[allergyObservation code] isCodeSystem:CodeSystemIdActCode withValue:ActCodeAssertion] && [[allergyObservation value] isCodeSystem:CodeSystemIdSNOMEDCT withValue:code]) {
        return YES;
    }
    return NO;
}

- (BOOL)noKnownAllergiesFound
{
    return [self noKnownAllergyTo:CODESNOMEDCTAllergyToSubstance in:self];
}

- (BOOL)noKnownMedicationAllergiesFound
{
    return [self noKnownAllergyTo:CODESNOMEDCTAllergyToDrug in:self];
}

/*
When the Severity Observation is associated directly with an allergy it characterizes the allergy.
When the Severity Observation is associated with a Reaction Observation it characterizes a Reaction
**/
- (HL7AllergyObservation *_Nullable)severity
{

    if ([self isSeverityObservation]) {
        return nil;
    }

    // allergy observation
    for (HL7Entry *entry in [self descendants]) {
        if (![entry isKindOfClass:[HL7EntryRelationship class]]) {
            continue;
        }

        HL7EntryRelationship *entryRelationship = (HL7EntryRelationship *)entry;
        if (![[entryRelationship typeCode] isEqualToString:HL7ValueTypeCodeSubj]) {
            continue;
        }

        for (HL7Entry *entry in [entryRelationship descendants]) {
            if (![entry isKindOfClass:[HL7AllergyObservation class]]) {
                continue;
            }

            HL7AllergyObservation *allergyObservation = (HL7AllergyObservation *)entry;
            if ([allergyObservation hasTemplateId:HL7TemplateAllergySeverityObservation]) { // *4.8
                return allergyObservation;
            }
            break;
        }
    }
    return nil;
}

- (BOOL)isObservation
{
    return [self hasTemplateId:HL7TemplateAllergyObservation];
}

- (BOOL)isReactionObservation
{
    return [self hasTemplateId:HL7TemplateAllergyReactionObservation];
}

- (BOOL)isSeverityObservation
{
    return [self hasTemplateId:HL7TemplateAllergySeverityObservation];
}

- (NSString *_Nullable)getTextFromValueOrSectionText
{

    return [self getTextFromDisplayName:[[self value] displayName] orSectionText:[[self parentSection] text]];
}
@end
