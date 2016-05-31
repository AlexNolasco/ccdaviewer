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


#import "HL7AllergyReactionSummary.h"
#import "HL7CodeSummary.h"

@implementation HL7AllergyReactionSummary
- (id)copyWithZone:(nullable NSZone *)zone
{
    HL7AllergyReactionSummary *clone = [[HL7AllergyReactionSummary allocWithZone:zone] init];
    [clone setReactionCode:[[self reactionCode] copyWithZone:zone]];
    [clone setStatusCode:[[self statusCode] copyWithZone:zone]];
    [clone setSeverityCode:[[self severityCode] copyWithZone:zone]];
    return clone;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        [self setReactionCode:[decoder decodeObjectForKey:@"reactionCode"]];
        [self setStatusCode:[decoder decodeObjectForKey:@"statusCode"]];
        [self setSeverityCode:[decoder decodeObjectForKey:@"severityCode"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:[self reactionCode] forKey:@"reactionCode"];
    [encoder encodeObject:[self statusCode] forKey:@"statusCode"];
    [encoder encodeObject:[self severityCode] forKey:@"severityCode"];
}
@end
