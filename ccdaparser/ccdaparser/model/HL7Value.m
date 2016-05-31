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


#import "HL7Value.h"
#import "HL7OriginalText.h"
#import "HL7PhysicalQuantityInterval.h"

@implementation HL7Value

- (id)copyWithZone:(nullable NSZone *)zone
{
    HL7Value *clone = [super copyWithZone:zone];
    [clone setType:[[self type] copyWithZone:zone]];
    [clone setValue:[[self value] copyWithZone:zone]];
    [clone setLow:[[self low] copyWithZone:zone]];
    [clone setHigh:[[self high] copyWithZone:zone]];
    [clone setText:[[self text] copyWithZone:zone]];
    return clone;
}

- (BOOL)physicalUnitsAreEqual
{
    return [[[self low] unit] isEqualToString:[[self high] unit]];
}

- (HL7XSIType)xsiType
{
    if (![[self type] length]) {
        return HL7XSITypeUnknown;
    }
    if ([[self type] isEqualToString:@"PQ"]) {
        return HL7XSITypePhysicalQuality;
    } else if ([[self type] isEqualToString:@"CD"]) {
        return HL7XSITypeCodedConcept;
    } else if ([[self type] isEqualToString:@"IVL_PQ"]) {
        return HL7XSITypeQuantityRange;
    } else if ([[self type] isEqualToString:@"CO"]) {
        return HL7XSITypeCode;
    } else if ([[self type] isEqualToString:@"ST"]) {
        return HL7XSITypeStructuredText;
    } else {
        return HL7XSITypeUnknown;
    }
}

#pragma mark -
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder]) {
        [self setType:[decoder decodeObjectForKey:@"type"]];
        [self setValue:[decoder decodeObjectForKey:@"value"]];
        [self setUnit:[decoder decodeObjectForKey:@"unit"]];
        [self setText:[decoder decodeObjectForKey:@"text"]];
        [self setLow:[decoder decodeObjectForKey:@"low"]];
        [self setHigh:[decoder decodeObjectForKey:@"high"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeObject:[self type] forKey:@"type"];
    [encoder encodeObject:[self value] forKey:@"value"];
    [encoder encodeObject:[self unit] forKey:@"unit"];
    [encoder encodeObject:[self text] forKey:@"text"];
    [encoder encodeObject:[self low] forKey:@"low"];
    [encoder encodeObject:[self high] forKey:@"high"];
}
@end
