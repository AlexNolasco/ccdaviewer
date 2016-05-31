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


#import "HL7EffectiveTimeElement.h"
#import "NSDate+Additions.h"

@implementation HL7EffectiveTimeElement

- (id)copyWithZone:(NSZone *)zone
{
    HL7EffectiveTimeElement *clone = [super copyWithZone:zone];
    [clone setValue:[[self value] copyWithZone:zone]];
    return clone;
}

- (NSDate *_Nullable)valueAsNSDate
{
    return [NSDate fromISO8601String:[self value]];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"\n%@: { date: %@ }", [[self class] description], [self value]];
}

#pragma mark -
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        [self setValue:[decoder decodeObjectForKey:@"value"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:[self value] forKey:@"value"];
}
@end
