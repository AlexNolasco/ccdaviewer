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


#import "FHIRLink.h"


NSString *const kFHIRLinkTarget = @"target";
NSString *const kFHIRLinkUrl = @"url";
NSString *const kFHIRLinkAssurance = @"assurance";


@interface FHIRLink ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation FHIRLink

@synthesize target = _target;
@synthesize url = _url;
@synthesize assurance = _assurance;


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
        self.target = [self objectOrNilForKey:kFHIRLinkTarget fromDictionary:dict];
        self.url = [self objectOrNilForKey:kFHIRLinkUrl fromDictionary:dict];
        self.assurance = [self objectOrNilForKey:kFHIRLinkAssurance fromDictionary:dict];
    }

    return self;
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.target forKey:kFHIRLinkTarget];
    [mutableDict setValue:self.url forKey:kFHIRLinkUrl];
    [mutableDict setValue:self.assurance forKey:kFHIRLinkAssurance];

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

    self.target = [aDecoder decodeObjectForKey:kFHIRLinkTarget];
    self.url = [aDecoder decodeObjectForKey:kFHIRLinkUrl];
    self.assurance = [aDecoder decodeObjectForKey:kFHIRLinkAssurance];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_target forKey:kFHIRLinkTarget];
    [aCoder encodeObject:_url forKey:kFHIRLinkUrl];
    [aCoder encodeObject:_assurance forKey:kFHIRLinkAssurance];
}

- (id)copyWithZone:(NSZone *)zone
{
    FHIRLink *copy = [[FHIRLink alloc] init];

    if (copy) {

        copy.target = [self.target copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
        copy.assurance = [self.assurance copyWithZone:zone];
    }

    return copy;
}


@end
