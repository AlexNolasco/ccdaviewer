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


#import "HL7DateRange_Private.h"
#import "HL7EffectiveTime.h"
#import "HL7EffectiveTimeElement.h"

@implementation HL7DateRange

- (instancetype _Nonnull)initWithStart:(NSDate *_Nullable)start end:(NSDate *_Nullable)end
{
    if ((self = [super init])) {
        if (start != nil) {
            [self setStart:[start copy]];
        }
        if (end != nil) {
            [self setEnd:[end copy]];
        }
    }
    return self;
}

- (instancetype _Nonnull)initWithEffectiveTime:(HL7EffectiveTime *_Nullable)effectiveTime
{
    if ([[effectiveTime nullFlavor] length]) {
        [self setNullFlavor:[[effectiveTime nullFlavor] copy]];
    }
    if ([[effectiveTime low] value] == nil && [[effectiveTime high] value] == nil && [effectiveTime value] != nil) {
        return [self initWithStart:[effectiveTime valueAsNSDate] end:nil];
    }
    return [self initWithStart:[[effectiveTime low] valueAsNSDate] end:[[effectiveTime high] valueAsNSDate]];
}

+ (instancetype _Nonnull)dateRangeWithEffectiveTime:(HL7EffectiveTime *_Nullable)effectiveTime
{
    return [[self alloc] initWithEffectiveTime:effectiveTime];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"start: %@ end: %@ nullFlavor: %@", [self start], [self end], [self nullFlavor]];
}

#pragma mark -
- (id)copyWithZone:(nullable NSZone *)zone
{
    HL7DateRange *clone = [[HL7DateRange allocWithZone:zone] init];
    [clone setStart:[[self start] copyWithZone:zone]];
    [clone setEnd:[[self end] copyWithZone:zone]];
    return clone;
}

#pragma mark -
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        [self setNullFlavor:[decoder decodeObjectForKey:@"nullFlavor"]];
        [self setStart:[decoder decodeObjectForKey:@"start"]];
        [self setEnd:[decoder decodeObjectForKey:@"end"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    if ([self start] != nil) {
        [encoder encodeObject:[self start] forKey:@"start"];
    }
    if ([self end] != nil) {
        [encoder encodeObject:[self end] forKey:@"end"];
    }
    if ([[self nullFlavor] length]) {
        [encoder encodeObject:[self nullFlavor] forKey:@"nullFlavor"];
    }
}
@end
