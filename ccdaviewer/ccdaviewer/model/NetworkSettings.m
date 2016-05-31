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


#import "NetworkSettings.h"

@implementation NetworkSettings

- (instancetype)initWithURLString:(NSString *)string npi:(NSString *)npi
{
    if ((self = [super init])) {
        [self setUrl:[NSURL URLWithString:string]];
        [self setNpi:[npi copy]];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"\n\turl:%@\n\t%@", [self url], [self npi]];
}

#pragma mark -
- (id)copyWithZone:(nullable NSZone *)zone
{
    NetworkSettings *clone = [[NetworkSettings allocWithZone:zone] init];
    [clone setUrl:[[self url] copy]];
    [clone setNpi:[[self npi] copy]];
    return clone;
}

#pragma mark -
- (id)initWithCoder:(NSCoder *)decoder
{
    [self setUrl:[decoder decodeObjectForKey:@"url"]];
    [self setNpi:[decoder decodeObjectForKey:@"npi"]];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:[self url] forKey:@"url"];
    [encoder encodeObject:[self npi] forKey:@"npi"];
}
@end
