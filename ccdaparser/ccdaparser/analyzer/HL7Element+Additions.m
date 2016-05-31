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


#import "HL7Element+Additions.h"
#import "HL7StatusCode.h"
#import "HL7ClassMoodProtocol.h"

@implementation HL7Element (Additions)
- (HL7MoodCode)hl7MoodCode
{
    if (![self conformsToProtocol:@protocol(HL7ClassMoodProtocol)]) {
        return HL7MoodCodeUnknown;
    }

    HL7Element<HL7ClassMoodProtocol> *classMood = (HL7Element<HL7ClassMoodProtocol> *)self;
    if ([[classMood moodCode] isEqualToString:@"EVN"]) {
        return HL7MoodCodeEvn;
    } else if ([[classMood moodCode] isEqualToString:@"INT"]) {
        return HL7MoodCodeInt;
    } else if ([[classMood moodCode] isEqualToString:@"RQO"]) {
        return HL7MoodCodeRqo;
    } else if ([[classMood moodCode] isEqualToString:@"APT"]) {
        return HL7MoodCodeApt;
    } else if ([[classMood moodCode] isEqualToString:@"ARQ"]) {
        return HL7MoodCodeArq;
    } else if ([[classMood moodCode] isEqualToString:@"PRP"]) {
        return HL7MoodCodePrp;
    } else if ([[classMood moodCode] isEqualToString:@"PRMS"]) {
        return HL7MoodCodePrms;
    } else if ([[classMood moodCode] isEqualToString:@"GOL"]) {
        return HL7MoodCodeGol;
    } else if ([[classMood moodCode] isEqualToString:@"EVN.CRT"]) {
        return HL7MoodCodeEvnCrt;
    } else {
        return HL7MoodCodeUnknown;
    }
}
@end
