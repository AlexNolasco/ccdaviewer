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


#import "HL7AllergyAnalyzer.h"
#import "HL7Summary_Private.h"
#import "HL7Const.h"
#import "HL7CCD.h"
#import "HL7EffectiveTime.h"
#import "HL7EffectiveTimeElement.h"
#import "HL7DateRange_Private.h"
#import "HL7EffectiveTimeElement.h"
#import "HL7CodeSummary.h"
#import "HL7CodeSummary_Private.h"
#import "HL7Element+Additions.h"
#import "HL7CodeSystem_Private.h"
#import "HL7Act.h"
#import "HL7AllergyEntry.h"
#import "HL7AllergySection.h"
#import "HL7AllergySummary.h"
#import "HL7AllergySummaryEntry_Private.h"
#import "HL7AllergyObservation.h"
#import "HL7AllergySummaryEntry.h"
#import "HL7AllergyConcernAct.h"
#import "HL7AllergyReactionSummary.h"
#import "HL7AllergyEntry+Additions.h"
#import "HL7AllergySummary_Private.h"

@implementation HL7AllergyAnalyzer

- (NSString *)templateId
{
    return HL7TemplateAllergySectionEntriesRequired;
}

- (HL7AllergySummaryEntry *)createAllergySummaryFrom:(HL7AllergyEntry *)allergyEntry andSection:(HL7AllergySection *)section
{
    if (![allergyEntry problemAct]) {
        return nil;
    }

    HL7AllergyObservation *observation = [allergyEntry allergen];
    if (observation == nil) {
        return nil;
    }

    HL7AllergySummaryEntry *result = [HL7AllergySummaryEntry new];
    [result setDateOfOnsetRange:[[HL7DateRange alloc] initWithStart:[[[observation effectiveTime] low] valueAsNSDate] end:[[[observation effectiveTime] high] valueAsNSDate]]];

    // allergen code
    HL7CodeSummary *allergenCodeSummary = [[HL7CodeSummary alloc] initWithCodeSystem:[allergyEntry allergenCode]];
    [allergenCodeSummary setResolvedName:[allergyEntry getAllergenUsingSectionTextAsReference:[section text]]];
    [result setAllergenCode:allergenCodeSummary];

    // allergen value
    HL7CodeSummary *allergenValueSummary = [[HL7CodeSummary alloc] initWithValue:[allergyEntry allergenValue]];
    [result setAllergenValue:allergenValueSummary];

    // reaction
    HL7CodeSummary *reactionCodeSummary = [[HL7CodeSummary alloc] initWithValue:[allergyEntry firstReactionValue]];
    [reactionCodeSummary setResolvedName:[allergyEntry getFirstReactionNameUsingSectionTextAsReference:[section text]]];
    [result setReactionCode:reactionCodeSummary];

    // status
    HL7CodeSummary *statusCodeSummary = [[HL7CodeSummary alloc] initWithValue:[allergyEntry statusValue]];
    [statusCodeSummary setResolvedName:[allergyEntry getStatusUsingSectionTextAsReference:[section text]]];
    [result setStatusCode:statusCodeSummary];

    // severity
    HL7CodeSummary *severityCodeSummary = [[HL7CodeSummary alloc] initWithValue:[allergyEntry severityValue]];
    [severityCodeSummary setResolvedName:[allergyEntry getSeverityUsingSectionTextAsReference:[section text]]];
    [result setSeverityCode:severityCodeSummary];

    // no knowns
    [result setNoKnownAllergiesFound:allergyEntry.allergen.noKnownAllergiesFound];
    [result setNoKnownMedicationAllergiesFound:allergyEntry.allergen.noKnownMedicationAllergiesFound];

    // reactions
    if ([allergyEntry reactions] > 0) {
        [result setReactions:[[NSMutableArray alloc] initWithCapacity:[[allergyEntry reactions] count]]];
        for (HL7AllergyObservation *reactionObservation in [allergyEntry reactions]) {
            HL7AllergyReactionSummary *reactionSummary = [[HL7AllergyReactionSummary alloc] init];

            HL7CodeSummary *reaction = [[HL7CodeSummary alloc] initWithValue:[reactionObservation value]];
            [reaction setResolvedName:[reactionObservation getTextFromValueOrSectionText]];
            [reactionSummary setReactionCode:reaction];

            HL7CodeSummary *severity = [[HL7CodeSummary alloc] initWithValue:[[reactionObservation severity] value]];
            [severity setResolvedName:[[reactionObservation severity] getTextFromValueOrSectionText]];
            [reactionSummary setSeverityCode:severity];

            [[result reactions] addObject:reactionSummary];
        }
    }
    return result;
}

- (id<HL7SummaryProtocol> _Nonnull)analyzeSectionUsingDocument:(HL7CCD *_Nonnull)document
{
    HL7AllergySection *allergySection = (HL7AllergySection *)[document getSectionByTemplateId:[self templateId]];
    HL7AllergySummary *summary = [[HL7AllergySummary alloc] initWithElement:allergySection];

    if (allergySection != nil) {
        [summary setNoKnownAllergiesFound:[allergySection noKnownAllergiesFound]];
        [summary setNoKnownMedicationAllergiesFound:[allergySection noKnownMedicationAllergiesFound]];


        for (HL7AllergyEntry *allergyEntry in [allergySection entries]) {
            HL7AllergySummaryEntry *analyzedEntry = [self createAllergySummaryFrom:allergyEntry andSection:allergySection];
            if (analyzedEntry != nil && [[analyzedEntry allergen] length]) {
                [[summary entries] addObject:analyzedEntry];
            }
        }
    }
    return summary;
}
@end
