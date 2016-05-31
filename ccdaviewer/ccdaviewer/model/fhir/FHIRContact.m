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


#import "FHIRContact.h"
#import "FHIRTelecom.h"
#import "FHIRName.h"
#import "FHIRPeriod.h"


NSString *const kFHIRContactGender = @"gender";
NSString *const kFHIRContactTelecom = @"telecom";
NSString *const kFHIRContactName = @"name";
NSString *const kFHIRContactPeriod = @"period";


@interface FHIRContact ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation FHIRContact

@synthesize gender = _gender;
@synthesize telecom = _telecom;
@synthesize name = _name;
@synthesize period = _period;


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
        self.gender = [self objectOrNilForKey:kFHIRContactGender fromDictionary:dict];
        NSObject *receivedFHIRTelecom = [dict objectForKey:kFHIRContactTelecom];
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
        self.name = [FHIRName modelObjectWithDictionary:[dict objectForKey:kFHIRContactName]];
        self.period = [FHIRPeriod modelObjectWithDictionary:[dict objectForKey:kFHIRContactPeriod]];
    }

    return self;
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.gender forKey:kFHIRContactGender];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForTelecom] forKey:kFHIRContactTelecom];
    [mutableDict setValue:[self.name dictionaryRepresentation] forKey:kFHIRContactName];
    [mutableDict setValue:[self.period dictionaryRepresentation] forKey:kFHIRContactPeriod];

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

    self.gender = [aDecoder decodeObjectForKey:kFHIRContactGender];
    self.telecom = [aDecoder decodeObjectForKey:kFHIRContactTelecom];
    self.name = [aDecoder decodeObjectForKey:kFHIRContactName];
    self.period = [aDecoder decodeObjectForKey:kFHIRContactPeriod];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_gender forKey:kFHIRContactGender];
    [aCoder encodeObject:_telecom forKey:kFHIRContactTelecom];
    [aCoder encodeObject:_name forKey:kFHIRContactName];
    [aCoder encodeObject:_period forKey:kFHIRContactPeriod];
}

- (id)copyWithZone:(NSZone *)zone
{
    FHIRContact *copy = [[FHIRContact alloc] init];

    if (copy) {

        copy.gender = [self.gender copyWithZone:zone];
        copy.telecom = [self.telecom copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.period = [self.period copyWithZone:zone];
    }

    return copy;
}


@end
