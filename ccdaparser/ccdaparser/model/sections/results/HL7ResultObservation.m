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


#import "HL7ResultObservation.h"
#import "HL7InterpretationCode.h"
#import "HL7ResultReferenceRange.h"
#import "HL7Code.h"
#import "HL7Enums.h"

@implementation HL7ResultObservation

- (NSMutableArray<HL7InterpretationCode *> *)interpretationCodes
{
    if (_interpretationCodes == nil) {
        _interpretationCodes = [[NSMutableArray alloc] initWithCapacity:2];
    }
    return _interpretationCodes;
}

- (NSMutableArray<HL7ResultReferenceRange *> *)referenceRanges
{
    if (_referenceRanges == nil) {
        _referenceRanges = [[NSMutableArray alloc] initWithCapacity:2];
    }
    return _referenceRanges;
}

- (void)addReferenceRangeWithValue:(HL7Value *_Nullable)value
{
    if (value == nil) {
        return;
    }
    HL7ResultReferenceRange *referenceRange = [[HL7ResultReferenceRange alloc] initWithValue:value];
    [[self referenceRanges] addObject:referenceRange];
}

- (HL7InterpretationCode *_Nullable)firstInterpretationCode
{
    if (![[self interpretationCodes] count]) {
        return nil;
    }
    return [[self interpretationCodes] firstObject];
}

- (HL7ResultReferenceRange *_Nullable)firstReferenceRange
{
    if (![[self referenceRanges] count]) {
        return nil;
    }
    return [[self referenceRanges] firstObject];
}

- (BOOL)isEmpty
{
    if (![self code] || ![[[self code] displayName] length]) {
        return YES;
    }
    return NO;
}
@end
