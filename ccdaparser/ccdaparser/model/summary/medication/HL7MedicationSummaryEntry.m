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


#import "HL7MedicationSummaryEntry_Private.h"
#import "HL7MedicationEntry.h"
#import "HL7SummaryEntry_Private.h"
#import "HL7CodeSummary_Private.h"
#import "HL7ManufacturedProduct.h"
#import "HL7ManufacturedMaterial.h"
#import "HL7SubstanceAdministration.h"
#import "HL7DoseQuantity.h"
#import "HL7DateRange_Private.h"
#import "HL7StatusCode.h"
#import "HL7EffectiveTime.h"
#import "HL7Period.h"

@implementation HL7MedicationSummaryEntry

- (HL7CodeSummary *)routeCode
{
    return _routeCode;
}

- (instancetype _Nonnull)initWithMedicationEntry:(HL7MedicationEntry *_Nonnull)medicationEntry
{
    if ((self = [super init])) {
        [self setNarrative:[[[medicationEntry medicationName] copy] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        [self setRouteCode:[HL7CodeSummary codeFromCode:[[medicationEntry substanceAdministration] routeCode]]];
        [self setDoseQuantityValue:[[[[medicationEntry substanceAdministration] doseQuantity] value] copy]];
        [self setDoseQuantityUnit:[[[[medicationEntry substanceAdministration] doseQuantity] unit] copy]];
        [self setEffectiveTime:[HL7DateRange dateRangeWithEffectiveTime:[[medicationEntry substanceAdministration] effectiveTime]]];
        [self setActive:[medicationEntry isActive]];

        HL7Period *period = [[[medicationEntry substanceAdministration] periodicTimeInterval] period];

        if (period != nil) {
            [self setPeriodValue:[[period value] copy]];
            [self setPeriodUnit:[[period unit] copy]];
        }
    }
    return self;
}

#pragma mark -
- (id)copyWithZone:(nullable NSZone *)zone
{
    HL7MedicationSummaryEntry *clone = [super copyWithZone:zone];
    [clone setRouteCode:[[self routeCode] copy]];
    [clone setDoseQuantityValue:[[self doseQuantityUnit] copy]];
    [clone setDoseQuantityUnit:[[self doseQuantityValue] copy]];
    [clone setEffectiveTime:[[self effectiveTime] copy]];
    [clone setActive:[self active]];
    [clone setPeriodUnit:[[self periodUnit] copy]];
    [clone setPeriodValue:[[self periodValue] copy]];
    [clone setStatusIsUnknown:[self statusIsUnknown]];
    return clone;
}

#pragma mark -
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder]) {
        [self setRouteCode:[decoder decodeObjectForKey:@"routeCode"]];
        [self setDoseQuantityValue:[decoder decodeObjectForKey:@"doseQuantityValue"]];
        [self setDoseQuantityUnit:[decoder decodeObjectForKey:@"doseQuantityUnit"]];
        [self setEffectiveTime:[decoder decodeObjectForKey:@"effectiveTime"]];
        [self setActive:[decoder decodeBoolForKey:@"active"]];
        [self setPeriodUnit:[decoder decodeObjectForKey:@"periodUnit"]];
        [self setPeriodValue:[decoder decodeObjectForKey:@"periodValue"]];
        [self setStatusIsUnknown:[decoder decodeBoolForKey:@"statusIsUnknown"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeObject:[self routeCode] forKey:@"routeCode"];
    [encoder encodeObject:[self doseQuantityValue] forKey:@"doseQuantityValue"];
    [encoder encodeObject:[self doseQuantityUnit] forKey:@"doseQuantityUnit"];
    [encoder encodeObject:[self effectiveTime] forKey:@"effectiveTime"];
    [encoder encodeBool:[self active] forKey:@"active"];
    [encoder encodeObject:[self periodUnit] forKey:@"periodUnit"];
    [encoder encodeObject:[self periodValue] forKey:@"periodValue"];
    [encoder encodeBool:[self statusIsUnknown] forKey:@"statusIsUnknown"];
}
@end
