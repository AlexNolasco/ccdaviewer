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


#import "HL7Telecom_Private.h"
#import "NSString+ObjectiveSugar.h"
#import "HL7Enums_Private.h"
#import "HelperMacros.h"

NSString *const TELECOM_PREFIX = @"tel:";
NSString *const EMAIL_PREFIX = @"mailto:";
NSString *const HTTP_PREFIX = @"http://";
NSString *const HTTPS_PREFIX = @"https://";

@implementation HL7Telecom
- (void)setValue:(NSString *)value
{
    if (value != nil) {
        _value = [value copy];
        _telecomType = [self telecomTypeByString:_value];
    }
}

- (HL7TelecomType)telecomTypeByString:(NSString *)string
{
    if ([string hasPrefix:TELECOM_PREFIX]) {
        return HL7TelecomTypeTelephone;
    } else if ([string hasPrefix:EMAIL_PREFIX]) {
        return HL7TelecomTypeEmail;
    } else if ([string hasPrefix:HTTP_PREFIX]) {
        return HL7TelecomTypeHttp;
    } else if ([string hasPrefix:HTTPS_PREFIX]) {
        return HL7TelecomTypeHttps;
    }
    return HL7TelecomTypeUnknown;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", [self value]];
}

- (NSString *_Nullable)valueWithoutPrefix
{
    if ([self telecomType] == HL7TelecomTypeTelephone) {
        return [[self value] substringFromIndex:[TELECOM_PREFIX length]];
    } else if ([self telecomType] == HL7TelecomTypeEmail) {
        return [[self value] substringFromIndex:[EMAIL_PREFIX length]];
    } else if ([self telecomType] == HL7TelecomTypeHttp) {
        return [[self value] substringFromIndex:[HTTP_PREFIX length]];
    } else if ([self telecomType] == HL7TelecomTypeHttps) {
        return [[self value] substringFromIndex:[HTTPS_PREFIX length]];
    } else {
        return [[self value] copy];
    }
}

- (BOOL)usedFor:(HL7UseTelecomType)purpose
{
    if (![[self uses] length] && purpose == HL7UseTelecomTypeUnknown) {
        return YES;
    }

    NSArray *components = [[self uses] componentsSeparatedByString:@" "];
    for (NSString *use in components) {
        if ([HL7Enumerations hl7TelecomUseFromString:use] == purpose) {
            return YES;
        }
    }
    return NO;
}

#pragma mark NSCopying
- (id)copyWithZone:(nullable NSZone *)zone
{
    HL7Telecom *clone = [super copyWithZone:zone];
    [clone setValue:[[self value] copy]];
    [clone setUses:[[self uses] copy]];
    return clone;
}

#pragma mark NSCoding
- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super initWithCoder:decoder])) {
        [self setValue:[decoder decodeObjectForKey:@"value"]];
        [self setUses:[decoder decodeObjectForKey:@"uses"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeObject:[self value] forKey:@"value"];
    [encoder encodeObject:[self uses] forKey:@"uses"];
}

@end
