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


#import "HL7StatusCode.h"

@implementation HL7StatusCode
- (BOOL)equalsToValue:(NSArray<NSString *> *_Nonnull)values
{
    for (NSString *value in values) {
        if ([[self code] caseInsensitiveCompare:value] == NSOrderedSame) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isActive
{
    return [self statusCode] == HL7StatusCodeCodeActive;
}

- (BOOL)isResolved
{
    return [self statusCode] == HL7StatusCodeCodeResolved;
}

- (BOOL)isUnknown
{
    return [self statusCode] == HL7StatusCodeCodeUnknown;
}

- (id)copyWithZone:(nullable NSZone *)zone
{
    HL7StatusCode *clone = [[HL7StatusCode allocWithZone:zone] init];
    [clone setCode:[[self code] copyWithZone:zone]];
    return clone;
}

- (HL7StatusCodeCode)statusCode
{
    if ([self equalsToValue:@[ @"active" ]]) {
        return HL7StatusCodeCodeActive;
    } else if ([self equalsToValue:@[ @"resolved" ]]) {
        return HL7StatusCodeCodeResolved;
    } else if ([self equalsToValue:@[ @"completed" ]]) {
        return HL7StatusCodeCodeCompleted;
    } else {
        return HL7StatusCodeCodeUnknown;
    }
}

#pragma mark -
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        [self setCode:[decoder decodeObjectForKey:@"code"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:[self code] forKey:@"code"];
}
@end
