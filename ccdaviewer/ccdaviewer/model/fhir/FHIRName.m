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


#import "FHIRName.h"


NSString *const kFHIRNameGiven = @"given";
NSString *const kFHIRNameUse = @"use";
NSString *const kFHIRNameFamily = @"family";


@interface FHIRName ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation FHIRName

@synthesize given = _given;
@synthesize use = _use;
@synthesize family = _family;


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
        self.given = [self objectOrNilForKey:kFHIRNameGiven fromDictionary:dict];
        self.use = [self objectOrNilForKey:kFHIRNameUse fromDictionary:dict];
        self.family = [self objectOrNilForKey:kFHIRNameFamily fromDictionary:dict];
    }

    return self;
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForGiven = [NSMutableArray array];
    for (NSObject *subArrayObject in self.given) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForGiven addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForGiven addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForGiven] forKey:kFHIRNameGiven];
    [mutableDict setValue:self.use forKey:kFHIRNameUse];
    NSMutableArray *tempArrayForFamily = [NSMutableArray array];
    for (NSObject *subArrayObject in self.family) {
        if ([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForFamily addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForFamily addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForFamily] forKey:kFHIRNameFamily];

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

    self.given = [aDecoder decodeObjectForKey:kFHIRNameGiven];
    self.use = [aDecoder decodeObjectForKey:kFHIRNameUse];
    self.family = [aDecoder decodeObjectForKey:kFHIRNameFamily];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_given forKey:kFHIRNameGiven];
    [aCoder encodeObject:_use forKey:kFHIRNameUse];
    [aCoder encodeObject:_family forKey:kFHIRNameFamily];
}

- (id)copyWithZone:(NSZone *)zone
{
    FHIRName *copy = [[FHIRName alloc] init];

    if (copy) {

        copy.given = [self.given copyWithZone:zone];
        copy.use = [self.use copyWithZone:zone];
        copy.family = [self.family copyWithZone:zone];
    }

    return copy;
}


@end
