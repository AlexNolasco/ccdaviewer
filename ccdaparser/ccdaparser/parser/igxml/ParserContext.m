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


#import "ParserContext.h"
#import "NSMutableArray+ObjectiveSugar.h"

@interface ParserContext ()
@property (nonatomic, strong) NSMutableArray *stashes;
@end

@implementation ParserContext

- (nonnull instancetype)initWithReader:(nonnull IGXMLReader *)reader
{
    if ((self = [super init])) {
        [self setReader:reader];
    }
    return self;
}

- (nonnull instancetype)initWithReader:(nonnull IGXMLReader *)reader hl7ccd:(nonnull HL7CCD *)hl7ccd
{
    if ((self = [self initWithReader:reader])) {
        [self setHl7ccd:hl7ccd];
    }
    return self;
}

- (void)stashElementReplaceWith:(HL7Element *_Nonnull)element withBlock:(void (^_Nonnull)())block
{
    [self stashElementReplaceWith:element];
    block();
    [self popElement];
}

- (NSMutableArray *)stashes
{
    if (_stashes == nil) {
        _stashes = [[NSMutableArray alloc] initWithCapacity:2];
    }
    return _stashes;
}

- (void)stashElementReplaceWith:(HL7Element *_Nonnull)element
{
    [[self stashes] push:[self element]];
    [self setElement:element];
}

- (void)popElement
{
    if ([[self stashes] count] > 0) {
        [self setElement:[[self stashes] pop]];
    }
}
@end
