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


#import "HL7CodeSystem_Private.h"
#import "HL7NullFlavorElement_Private.h"

@implementation HL7CodeSystem

- (instancetype _Nonnull)initWithCodeSystem:(HL7CodeSystem *_Nullable)code
{
    if ((self = [super initWithFlavorElement:code])) {
        if (code != nil) {
            [self setCode:[[code code] copy]];
            [self setCodeSystem:[[code codeSystem] copy]];
            [self setCodeSystemName:[[code codeSystemName] copy]];
            [self setDisplayName:[[code displayName] copy]];
        }
    }
    return self;
}

- (BOOL)isCodeSystem:(NSString *)codeSystem
{
    return [[self codeSystem] isEqualToString:codeSystem];
}

- (BOOL)isCodeSystem:(NSString *_Nonnull)codeSystem withValue:(NSString *_Nonnull)value
{
    return [[self codeSystem] isEqualToString:codeSystem] && [[self code] isEqualToString:value];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Code: %@ CodeSystem: %@ CodeSystemName: %@ DisplayName: %@", [self code], [self codeSystem], [self codeSystemName], [self displayName]];
}

#pragma mark -
- (id)copyWithZone:(nullable NSZone *)zone
{
    HL7CodeSystem *clone = [super copyWithZone:zone];
    [clone setCode:[[self code] copyWithZone:zone]];
    [clone setCodeSystem:[[self codeSystem] copyWithZone:zone]];
    [clone setCodeSystemName:[[self codeSystemName] copyWithZone:zone]];
    [clone setDisplayName:[[self displayName] copyWithZone:zone]];
    return clone;
}

#pragma mark -
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder]) {
        [self setCode:[decoder decodeObjectForKey:@"code"]];
        [self setCodeSystem:[decoder decodeObjectForKey:@"codeSystem"]];
        [self setCodeSystemName:[decoder decodeObjectForKey:@"codeSystemName"]];
        [self setDisplayName:[decoder decodeObjectForKey:@"displayName"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeObject:[self code] forKey:@"code"];
    [encoder encodeObject:[self codeSystem] forKey:@"codeSystem"];
    [encoder encodeObject:[self codeSystemName] forKey:@"codeSystemName"];
    [encoder encodeObject:[self displayName] forKey:@"displayName"];
}
@end
