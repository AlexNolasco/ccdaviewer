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


#import "FHIRPatient.h"
#import "FHIRTelecom.h"
#import "FHIRLink.h"
#import "FHIRContact.h"
#import "FHIRName.h"


NSString *const kFHIRBaseClassGender = @"gender";
NSString *const kFHIRBaseClassId = @"id";
NSString *const kFHIRBaseClassTelecom = @"telecom";
NSString *const kFHIRBaseClassBirthDate = @"birthDate";
NSString *const kFHIRBaseClassDeceasedBoolean = @"deceasedBoolean";
NSString *const kFHIRBaseClassLink = @"link";
NSString *const kFHIRBaseClassContact = @"contact";
NSString *const kFHIRBaseClassResourceType = @"resourceType";
NSString *const kFHIRBaseClassName = @"name";


@interface FHIRPatient ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation FHIRPatient

@synthesize gender = _gender;
@synthesize internalBaseClassIdentifier = _internalBaseClassIdentifier;
@synthesize telecom = _telecom;
@synthesize birthDate = _birthDate;
@synthesize deceasedBoolean = _deceasedBoolean;
@synthesize link = _link;
@synthesize contact = _contact;
@synthesize resourceType = _resourceType;
@synthesize name = _name;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];

    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.gender = [self objectOrNilForKey:kFHIRBaseClassGender fromDictionary:dict];
        self.internalBaseClassIdentifier = [self objectOrNilForKey:kFHIRBaseClassId fromDictionary:dict];
        NSObject *receivedFHIRTelecom = [dict objectForKey:kFHIRBaseClassTelecom];
        NSMutableArray *parsedFHIRTelecom = [NSMutableArray array];
        if ([receivedFHIRTelecom isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in(NSArray *)receivedFHIRTelecom) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedFHIRTelecom addObject:[FHIRTelecom modelObjectWithDictionary:item]];
                }
            }
        } else if ([receivedFHIRTelecom isKindOfClass:[NSDictionary class]]) {
            [parsedFHIRTelecom addObject:[FHIRTelecom modelObjectWithDictionary:(NSDictionary *)receivedFHIRTelecom]];
        }

        self.telecom = [NSArray arrayWithArray:parsedFHIRTelecom];
        self.birthDate = [self objectOrNilForKey:kFHIRBaseClassBirthDate fromDictionary:dict];
        self.deceasedBoolean = [[self objectOrNilForKey:kFHIRBaseClassDeceasedBoolean fromDictionary:dict] boolValue];
        NSObject *receivedFHIRLink = [dict objectForKey:kFHIRBaseClassLink];
        NSMutableArray *parsedFHIRLink = [NSMutableArray array];
        if ([receivedFHIRLink isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in(NSArray *)receivedFHIRLink) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedFHIRLink addObject:[FHIRLink modelObjectWithDictionary:item]];
                }
            }
        } else if ([receivedFHIRLink isKindOfClass:[NSDictionary class]]) {
            [parsedFHIRLink addObject:[FHIRLink modelObjectWithDictionary:(NSDictionary *)receivedFHIRLink]];
        }

        self.link = [NSArray arrayWithArray:parsedFHIRLink];
        NSObject *receivedFHIRContact = [dict objectForKey:kFHIRBaseClassContact];
        NSMutableArray *parsedFHIRContact = [NSMutableArray array];
        if ([receivedFHIRContact isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in(NSArray *)receivedFHIRContact) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedFHIRContact addObject:[FHIRContact modelObjectWithDictionary:item]];
                }
            }
        } else if ([receivedFHIRContact isKindOfClass:[NSDictionary class]]) {
            [parsedFHIRContact addObject:[FHIRContact modelObjectWithDictionary:(NSDictionary *)receivedFHIRContact]];
        }

        self.contact = [NSArray arrayWithArray:parsedFHIRContact];
        self.resourceType = [self objectOrNilForKey:kFHIRBaseClassResourceType fromDictionary:dict];
        NSObject *receivedFHIRName = [dict objectForKey:kFHIRBaseClassName];
        NSMutableArray *parsedFHIRName = [NSMutableArray array];
        if ([receivedFHIRName isKindOfClass:[NSArray class]]) {
            for (NSDictionary *item in(NSArray *)receivedFHIRName) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [parsedFHIRName addObject:[FHIRName modelObjectWithDictionary:item]];
                }
            }
        } else if ([receivedFHIRName isKindOfClass:[NSDictionary class]]) {
            [parsedFHIRName addObject:[FHIRName modelObjectWithDictionary:(NSDictionary *)receivedFHIRName]];
        }

        self.name = [NSArray arrayWithArray:parsedFHIRName];
    }

    return self;
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.gender forKey:kFHIRBaseClassGender];
    [mutableDict setValue:self.internalBaseClassIdentifier forKey:kFHIRBaseClassId];
    NSMutableArray *tempArrayForTelecom = [NSMutableArray array];
    for (NSObject *subArrayObject in self.telecom) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForTelecom addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForTelecom addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForTelecom] forKey:kFHIRBaseClassTelecom];
    [mutableDict setValue:self.birthDate forKey:kFHIRBaseClassBirthDate];
    [mutableDict setValue:[NSNumber numberWithBool:self.deceasedBoolean] forKey:kFHIRBaseClassDeceasedBoolean];
    NSMutableArray *tempArrayForLink = [NSMutableArray array];
    for (NSObject *subArrayObject in self.link) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForLink addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForLink addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForLink] forKey:kFHIRBaseClassLink];
    NSMutableArray *tempArrayForContact = [NSMutableArray array];
    for (NSObject *subArrayObject in self.contact) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForContact addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForContact addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForContact] forKey:kFHIRBaseClassContact];
    [mutableDict setValue:self.resourceType forKey:kFHIRBaseClassResourceType];
    NSMutableArray *tempArrayForName = [NSMutableArray array];
    for (NSObject *subArrayObject in self.name) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForName addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForName addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForName] forKey:kFHIRBaseClassName];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.gender = [aDecoder decodeObjectForKey:kFHIRBaseClassGender];
    self.internalBaseClassIdentifier = [aDecoder decodeObjectForKey:kFHIRBaseClassId];
    self.telecom = [aDecoder decodeObjectForKey:kFHIRBaseClassTelecom];
    self.birthDate = [aDecoder decodeObjectForKey:kFHIRBaseClassBirthDate];
    self.deceasedBoolean = [aDecoder decodeBoolForKey:kFHIRBaseClassDeceasedBoolean];
    self.link = [aDecoder decodeObjectForKey:kFHIRBaseClassLink];
    self.contact = [aDecoder decodeObjectForKey:kFHIRBaseClassContact];
    self.resourceType = [aDecoder decodeObjectForKey:kFHIRBaseClassResourceType];
    self.name = [aDecoder decodeObjectForKey:kFHIRBaseClassName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_gender forKey:kFHIRBaseClassGender];
    [aCoder encodeObject:_internalBaseClassIdentifier forKey:kFHIRBaseClassId];
    [aCoder encodeObject:_telecom forKey:kFHIRBaseClassTelecom];
    [aCoder encodeObject:_birthDate forKey:kFHIRBaseClassBirthDate];
    [aCoder encodeBool:_deceasedBoolean forKey:kFHIRBaseClassDeceasedBoolean];
    [aCoder encodeObject:_link forKey:kFHIRBaseClassLink];
    [aCoder encodeObject:_contact forKey:kFHIRBaseClassContact];
    [aCoder encodeObject:_resourceType forKey:kFHIRBaseClassResourceType];
    [aCoder encodeObject:_name forKey:kFHIRBaseClassName];
}

- (id)copyWithZone:(NSZone *)zone
{
    FHIRPatient *copy = [[FHIRPatient alloc] init];

    if (copy) {

        copy.gender = [self.gender copyWithZone:zone];
        copy.internalBaseClassIdentifier = [self.internalBaseClassIdentifier copyWithZone:zone];
        copy.telecom = [self.telecom copyWithZone:zone];
        copy.birthDate = [self.birthDate copyWithZone:zone];
        copy.deceasedBoolean = self.deceasedBoolean;
        copy.link = [self.link copyWithZone:zone];
        copy.contact = [self.contact copyWithZone:zone];
        copy.resourceType = [self.resourceType copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
    }

    return copy;
}


@end
