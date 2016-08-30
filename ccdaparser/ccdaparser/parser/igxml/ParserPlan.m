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


#import "ParserPlan.h"
#import "ParserContext.h"

@implementation ParserPlan {
    NSMutableDictionary *_plans;
}

- (instancetype)initWithDepth:(NSInteger)depth
{
    if ((self = [super init])) {
        if (depth != -1) {
            _depth = depth;
        } else {
            _depth = -1;
        }
    }
    return self;
}

+ (instancetype)plan
{
    return [[self alloc] initWithDepth:-1];
}

+ (instancetype)planAtDepth:(NSInteger)depth
{
    return [[self alloc] initWithDepth:depth];
}

- (BOOL)shouldCountinueAtDepth:(NSInteger)depth
{
    if (_depth == -1) {
        return YES;
    }
    // because of same element with attributes, +1 because plan is set prior to depth
    return _depth == depth || _depth + 1 == depth;
}

- (void)when:(NSString *)name parseWithBlock:(ParserBlock)blk
{
    [self when:name populate:nil parseWithBlock:blk append:YES];
}

- (void)always:(NSString *)name parseWithBlock:(ParserBlock)blk
{
    [self when:name populate:nil parseWithBlock:blk append:NO];
}

- (void)when:(NSString *)name populate:(HL7Element *)element parseWithBlock:(ParserBlock)blk append:(BOOL)append
{

    if (_plans == nil) {
        _plans = [[NSMutableDictionary alloc] initWithCapacity:8];
    }

    if (name && [name length] > 0 && blk != nil) {
        NSMutableArray *array = [_plans objectForKey:name];

        if (array == nil) {
            array = [[NSMutableArray alloc] initWithCapacity:1];
            [_plans setObject:array forKey:name];
        }

        if (!append && [array count] > 0) {
            [array removeAllObjects];
        }

        if (element != nil) {
            [array addObject:@[ blk, element ]];
        } else {
            [array addObject:@[ blk, [NSNull null] ]];
        }
    }
}

- (id)objectForKey:(NSString *)aKey
{
    return [_plans objectForKey:aKey];
}
@end
