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


#import "HL7AllergyConcernAct.h"
#import "HL7EntryRelationship.h"
#import "HL7Element.h"
#import "HL7Observation.h"

@implementation HL7AllergyConcernAct

- (NSMutableArray<HL7EntryRelationship *> *)descendants
{
    if (_descendants == nil) {
        _descendants = [[NSMutableArray alloc] initWithCapacity:2];
    }
    return _descendants;
}

- (HL7EntryRelationship *)firstEntryRelationship
{
    if (![[self descendants] count]) {
        return nil;
    }

    // a concern act may contain multiple relationships
    for (HL7EntryRelationship *relationship in [self descendants]) {
        for (HL7Element *element in [relationship descendants]) {
            if ([element isKindOfClass:[HL7Observation class]]) {
                return relationship;
            }
        }
    }
    return [[self descendants] firstObject];
}
@end
