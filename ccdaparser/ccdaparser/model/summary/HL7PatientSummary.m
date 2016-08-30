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


#import "HL7PatientSummary.h"
#import "HL7PatientSummary_Private.h"
#import "HL7GuardianSummary_Private.h"
#import "HL7Name.h"
#import "HL7PatientRole.h"
#import "HL7Patient.h"
#import "HL7Code.h"
#import "HL7Codes.h"
#import "HelperMacros.h"
#import "HL7Telecom_Private.h"
#import "HelperMacros.h"

@implementation HL7PatientSummary

- (instancetype)initWithPatientRole:(HL7PatientRole *)patientRole
{
    if ((self = [super init])) {
        HL7Patient *patient = [patientRole patient];
        [self setDob:[[patient birthday] copy]];
        [self setTelecoms:[[NSArray alloc] initWithArray:[patientRole telecoms] copyItems:YES]];
        if ([patient birthday] != nil) {
            [self setAge:[NSNumber numberWithInteger:[patient age]]];
        }
        [self setNames:[[NSArray alloc] initWithArray:[patient names] copyItems:YES]];
        [self setGenderCode:[patient gender]];
        [self setMaritalStatusCode:[patient maritalStatus]];
        [self setEthnicGroupCode:[[patient ethnicGroupCode] copy]];
        [self setRaceCode:[[patient raceCode] copy]];
        [self setReligiousAffiliationCode:[[patient religiousAffiliationCode] copy]];        
        [self setPreferredLanguage:[patient preferredLanguageAsString]];
        
        [self setGuardians:[[NSArray alloc] initWithArray:[patient guardians] copyItems:YES]];
        NSMutableArray<HL7GuardianSummary*>* guardians = [[NSMutableArray alloc] initWithCapacity:1];
        [patient.guardians enumerateObjectsUsingBlock:^(HL7Guardian * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           [guardians addObject:[[HL7GuardianSummary alloc] initWithGuardian:obj]];
        }];
        self.guardians = [guardians copy];
    }
    return self;
}

- (NSString *_Nullable)templateId
{
    return nil;
}

- (NSArray<__kindof HL7SummaryEntry *> *)allEntries
{
    return [NSArray new]; // technically patient role can have many patients. TODO: move to array.
}

- (NSString *_Nullable)title
{
    return LOCALIZED_STRING(@"parser.patientRole");
}

- (HL7Telecom *_Nullable)firstPhoneOrDefault
{
    for (HL7Telecom *telecom in [self telecoms]) {
        if ([telecom telecomType] == HL7TelecomTypeTelephone) {
            return telecom;
        }
    }
    return nil;
}

- (HL7Telecom *_Nullable)firstEmailOrDefault
{
    for (HL7Telecom *telecom in [self telecoms]) {
        if ([telecom telecomType] == HL7TelecomTypeEmail) {
            return telecom;
        }
    }
    return nil;
}

- (NSString *_Nullable)telecomByType:(HL7TelecomType)telecomType usedFor:(HL7UseTelecomType)use
{
    NSString *result = nil;

    for (HL7Telecom *telecom in [self telecoms]) {
        if ([telecom telecomType] == telecomType) {
            if ([telecom usedFor:use]) {
                result = [telecom valueWithoutPrefix];
                break;
            }
        }
    }
    return result;
}

- (NSString *_Nullable)phoneNumber
{
    if (![[self telecoms] count]) {
        return nil;
    }

    // try mobile
    NSString *number = [self telecomByType:HL7TelecomTypeTelephone usedFor:HL7UseTelecomTypeMobileContact];
    if (![number length]) { // then home
        number = [self telecomByType:HL7TelecomTypeTelephone usedFor:HL7UseTelecomTypeHome];
    }
    if (![number length]) { // then emergency contact
        number = [self telecomByType:HL7TelecomTypeTelephone usedFor:HL7UseTelecomTypeHomePrimary];
    }

    // then any..
    if (![number length]) {
        HL7Telecom *telecom = [self firstPhoneOrDefault];
        if (telecom && ![telecom usedFor:HL7UseTelecomTypeBad]) {
            number = [telecom valueWithoutPrefix];
        }
    }
    return number;
}

- (NSString *_Nullable)emailAddress
{
    NSString *email = [self telecomByType:HL7TelecomTypeEmail usedFor:HL7UseTelecomTypeHomePrimary];

    if (![email length]) {
        HL7Telecom *telecom = [self firstEmailOrDefault];
        if (telecom && ![telecom usedFor:HL7UseTelecomTypeBad]) {
            email = [telecom valueWithoutPrefix];
        }
    }
    return email;
}

- (HL7Name *)name
{
    if ([[self names] count] == 0) {
        return nil;
    }
    return [[self names] firstObject];
}

- (NSString *_Nullable)fullName
{
    if (![[self names] count]) {
        return nil;
    }
    return [[self name] description];
}

- (NSString *)maritalStatus
{
    return [HL7Enumerations maritalStatusAsString:[self maritalStatusCode]];
}

- (NSString *)gender
{
    return [HL7Enumerations genderAsString:[self genderCode]];
}

- (NSString *)ethnicGroup
{
    if ([self ethnicGroupCode] == nil) {
        return nil;
    }
    return [[self ethnicGroupCode] displayName];
}

- (NSString *_Nullable)race
{
    if ([self raceCode] == nil) {
        return nil;
    }
    return [[self raceCode] displayName];
}

- (NSString *_Nullable)religiousAffiliation
{
    if ([self religiousAffiliationCode] == nil || ![[[self religiousAffiliationCode] code] isEqualToString:CODEHL7ReligiousAffiliation]) {
    }
    
    return [[self religiousAffiliationCode] displayName];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"name: %@ age: %@ gender: %@ religious affiliation: %@", self.name.description, self.age.stringValue, self.gender, self.religiousAffiliation];
}

- (BOOL)ageHasValue
{
    if ([self age] && ![[self age] isKindOfClass:[NSNull class]]) {
        return YES;
    }
    return NO;
}

- (BOOL)isEmpty
{
    return NO;
}

#pragma mark NSCopying
- (id)copyWithZone:(nullable NSZone *)zone
{
    HL7PatientSummary *clone = [[HL7PatientSummary allocWithZone:zone] init];
    [clone setDob:[[self dob] copyWithZone:zone]];
    [clone setTelecoms:[[NSArray allocWithZone:zone] initWithArray:[self telecoms] copyItems:YES]];
    [clone setNames:[[NSArray allocWithZone:zone] initWithArray:[self names] copyItems:YES]];
    [clone setGenderCode:[self genderCode]];
    [clone setGuardians:[[NSArray allocWithZone:zone] initWithArray:[self guardians] copyItems:YES]];
    [clone setMaritalStatusCode:[self maritalStatusCode]];
    [clone setAge:[self age]];
    return clone;
}

#pragma mark NSCoding
- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init])) {
        [self setDob:[decoder decodeObjectForKey:@"dob"]];
        [self setTelecoms:[decoder decodeObjectForKey:@"telecoms"]];
        [self setNames:[decoder decodeObjectForKey:@"names"]];
        [self setGenderCode:[decoder decodeIntegerForKey:@"gender"]];
        [self setGuardians:[decoder decodeObjectForKey:@"guardians"]];
        [self setMaritalStatusCode:[decoder decodeIntegerForKey:@"maritalStatusCode"]];
        [self setAge:[decoder decodeObjectForKey:@"age"]];
        [self setEthnicGroupCode:[decoder decodeObjectForKey:@"ethnicGroupCode"]];
        [self setRaceCode:[decoder decodeObjectForKey:@"raceCode"]];
        [self setReligiousAffiliationCode:[decoder decodeObjectForKey:@"religiousAffilication"]];
        [self setPreferredLanguage:[decoder decodeObjectForKey:@"preferredLanguage"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:[self dob] forKey:@"dob"];
    [encoder encodeObject:[self telecoms] forKey:@"telecoms"];
    [encoder encodeObject:[self names] forKey:@"names"];
    [encoder encodeInteger:[self genderCode] forKey:@"gender"];
    [encoder encodeObject:[self guardians] forKey:@"guardians"];
    [encoder encodeInteger:[self maritalStatusCode] forKey:@"maritalStatusCode"];
    [encoder encodeObject:[self age] forKey:@"age"];
    [encoder encodeObject:[self ethnicGroupCode] forKey:@"ethnicGroupCode"];
    [encoder encodeObject:[self raceCode] forKey:@"raceCode"];
    [encoder encodeObject:[self religiousAffiliation] forKey:@"religiousAffilication"];
    [encoder encodeObject:[self preferredLanguage] forKey:@"preferredLanguage"];
}
@end
