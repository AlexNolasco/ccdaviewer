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


#import "HL7AllergyEntry+Additions.h"
#import "HL7AllergyObservation.h"
#import "HL7PlayingEntity.h"
#import "HL7Value.h"
#import "HL7Text.h"
#import "HL7Code.h"
#import "HL7Name.h"
#import "HL7const.h"
#import "HL7OriginalText.h"
#import "HL7ParticipantRole.h"
#import "HL7Participant.h"
#import "HL7AllergyConcernAct.h"
#import "HL7EntryRelationship.h"
#import "NSString+ObjectiveSugar.h"

@implementation HL7AllergyEntry (Additions)


- (void)iterateObservationsByTemplateId:(NSString *)templateId withBlock:(void (^)(HL7AllergyObservation *observation, BOOL *stop))blk
{
    if (![self problemAct]) {
        return;
    }

    BOOL stop = NO;
    for (HL7Entry *entry in [[[self problemAct] firstEntryRelationship] descendants]) {
        if (![entry isKindOfClass:[HL7AllergyObservation class]]) {
            continue;
        }

        HL7AllergyObservation *allergyObservation = (HL7AllergyObservation *)entry;
        if ([allergyObservation hasTemplateId:templateId]) {
            blk(allergyObservation, &stop);
            if (stop) {
                break;
            }
            continue;
        }

        for (HL7Entry *entry in [allergyObservation descendants]) {
            if (![entry isKindOfClass:[HL7EntryRelationship class]]) {
                continue;
            }

            HL7EntryRelationship *entryRelationship = (HL7EntryRelationship *)entry;
            for (HL7Entry *entry in [entryRelationship descendants]) {
                if ([entry isKindOfClass:[HL7AllergyObservation class]]) {
                    HL7AllergyObservation *allergyObservation = (HL7AllergyObservation *)entry;
                    if ([allergyObservation hasTemplateId:templateId]) {
                        blk(allergyObservation, &stop);
                        if (stop) {
                            break;
                        }
                    }
                }
            }
            if (stop)
                break;
        }
        if (stop)
            break;
    }
}

- (HL7AllergyObservation *_Nullable)allergen
{
    // SUBJ 1..1 (..4.7)
    __block HL7AllergyObservation *result;
    [self iterateObservationsByTemplateId:HL7TemplateAllergyObservation
                                withBlock:^(HL7AllergyObservation *observation, BOOL *stop) {
                                    result = observation;
                                }];
    return result;
}

- (NSArray<HL7AllergyObservation *> *_Nonnull)reactions
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:2];
    // MSFT 0..* (..4.9)
    [self iterateObservationsByTemplateId:HL7TemplateAllergyReactionObservation
                                withBlock:^(HL7AllergyObservation *observation, BOOL *stop) {
                                    [array addObject:observation];
                                }];
    return [array copy];
}

- (HL7Value *_Nullable)firstReactionValue
{
    NSArray<HL7AllergyObservation *> *reactions = [self reactions];
    if (![reactions count]) {
        return nil;
    }
    return [[reactions firstObject] value];
}

- (HL7AllergyObservation *_Nullable)severity
{
    // SUBJ 0..1 (..4.8)
    return [[self allergen] severity];
}

- (HL7AllergyObservation *_Nullable)status
{
    // REFR 0..1 (..4.28)
    __block HL7AllergyObservation *result;
    [self iterateObservationsByTemplateId:HL7TemplateAllergyStatusObservation
                                withBlock:^(HL7AllergyObservation *observation, BOOL *stop) {
                                    result = observation;
                                    *stop = YES;
                                }];
    return result;
}

- (NSString *_Nullable)getAllergenUsingSectionTextAsReference:(HL7Text *)sectionText
{
    HL7AllergyObservation *obseration = [self allergen];
    if (obseration == nil) {
        return nil;
    }


    NSString *result;
    HL7Value *value = [obseration value];
    HL7Code *code = [[obseration participant] participantRolePlayingEntityCode];

    // in some cases the code can be of nullflavor and contain translations
    if (code && [[code displayName] length] > 0) {
        result = [[code displayName] copy];
    }

    if (result == nil) {
        HL7PlayingEntity *playingEntity = [[obseration participant] playingEntity];
        if (playingEntity && [[[playingEntity name] name] length]) {
            result = [[[playingEntity name] name] copy];
        }
    }

    if (result == nil) {
        result = [[[[[[obseration participant] participantRole] playingEntity] name] name] copy];
    }

    if (result == nil) {
        if (value && [[value originalTextElement] hasReferenceId]) { // this reference could contain other entries in the HTML
            result = [sectionText getIdentifierValueById:[[[value originalTextElement] referenceValue] copy]];
        }
    }
    return [result strip];
}

- (NSArray<NSString *> *_Nonnull)getReactionsNamesUsingSectionTextAsReference:(HL7Text *_Nullable)sectionText
{
    NSMutableArray<NSString *> *result = [[NSMutableArray alloc] initWithCapacity:2];

    for (HL7Observation *observation in [self reactions]) {
        NSString *name;
        HL7Value *value = [observation value];
        if (value != nil) {
            name = [sectionText getIdentifierValueById:[[[value originalTextElement] referenceValue] copy]];
        }
        if (name == nil && [[[observation text] firstReference] length]) {
            name = [[sectionText getIdentifierValueById:[[observation text] firstReference]] copy];
        }

        if (name != nil) {
            name = [[name strip] copy];
            if ([name length]) {
                [result addObject:name];
            }
        }
    }
    return [result copy];
}

- (NSString *_Nullable)getFirstReactionNameUsingSectionTextAsReference:(HL7Text *_Nullable)sectionText
{
    NSArray *reactions = [self getReactionsNamesUsingSectionTextAsReference:sectionText];
    if (![reactions count]) {
        return nil;
    }
    return [[reactions firstObject] copy];
}

- (NSString *_Nullable)getStatusUsingSectionTextAsReference:(HL7Text *_Nullable)sectionText
{
    return [[self status] getTextFromValueOrSectionText];
}

- (NSString *_Nullable)getSeverityUsingSectionTextAsReference:(HL7Text *_Nullable)sectionText
{
    return [[self severity] getTextFromValueOrSectionText];
}

- (HL7CodeSystem *_Nullable)allergenCode
{
    HL7AllergyObservation *obseration = [self allergen];
    if (obseration == nil) {
        return nil;
    }
    return [[obseration participant] participantRolePlayingEntityCode];
}

- (HL7Value *_Nullable)allergenValue
{
    HL7AllergyObservation *obseration = [self allergen];
    if (obseration == nil) {
        return nil;
    }
    return [obseration value];
}

- (HL7Value *_Nullable)severityValue
{
    return [[self severity] value];
}

- (HL7Value *_Nullable)statusValue
{
    return [[self status] value];
}
@end
