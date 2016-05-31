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


#import "FHIRTelecom.h"


NSString *const kFHIRTelecomSystem = @"system";
NSString *const kFHIRTelecomValue = @"value";
NSString *const kFHIRTelecomUse = @"use";


@interface FHIRTelecom ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation FHIRTelecom

@synthesize system = _system;
@synthesize value = _value;
@synthesize use = _use;


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
        self.system = [self objectOrNilForKey:kFHIRTelecomSystem fromDictionary:dict];
        self.value = [self objectOrNilForKey:kFHIRTelecomValue fromDictionary:dict];
        self.use = [self objectOrNilForKey:kFHIRTelecomUse fromDictionary:dict];
    }

    return self;
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.system forKey:kFHIRTelecomSystem];
    [mutableDict setValue:self.value forKey:kFHIRTelecomValue];
    [mutableDict setValue:self.use forKey:kFHIRTelecomUse];

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

    self.system = [aDecoder decodeObjectForKey:kFHIRTelecomSystem];
    self.value = [aDecoder decodeObjectForKey:kFHIRTelecomValue];
    self.use = [aDecoder decodeObjectForKey:kFHIRTelecomUse];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_system forKey:kFHIRTelecomSystem];
    [aCoder encodeObject:_value forKey:kFHIRTelecomValue];
    [aCoder encodeObject:_use forKey:kFHIRTelecomUse];
}

- (id)copyWithZone:(NSZone *)zone
{
    FHIRTelecom *copy = [[FHIRTelecom alloc] init];

    if (copy) {

        copy.system = [self.system copyWithZone:zone];
        copy.value = [self.value copyWithZone:zone];
        copy.use = [self.use copyWithZone:zone];
    }

    return copy;
}


@end
