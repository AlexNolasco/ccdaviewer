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

#import "HL7LanguageCommunication.h"
#import "HL7CodeSystem.h"

@implementation HL7LanguageCommunication

#pragma mark NSCopying
- (id)copyWithZone:(nullable NSZone *)zone
{
    HL7LanguageCommunication *clone = [self copyWithZone:zone];
    
    [clone setLanguageCode:[[self languageCode] copyWithZone:zone]];
    [clone setModeCode:[[self modeCode] copyWithZone:zone]];
    [clone setProficiencyLevelCode:[[self proficiencyLevelCode] copyWithZone:zone]];
    [clone setPreferenceInd:[self preferenceInd]];
    return clone;
}

#pragma mark NSCoding
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        [self setLanguageCode:[decoder decodeObjectForKey:@"languageCode"]];
        [self setModeCode:[decoder decodeObjectForKey:@"modeCode"]];
        [self setProficiencyLevelCode:[decoder decodeObjectForKey:@"proficiencyLevelCode"]];
        [self setPreferenceInd:[decoder decodeBoolForKey:@"preferenceInd"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:[self languageCode] forKey:@"languageCode"];
    [encoder encodeObject:[self modeCode] forKey:@"modeCode"];
    [encoder encodeObject:[self proficiencyLevelCode] forKey:@"proficiencyLevelCode"];
    [encoder encodeBool:[self preferenceInd] forKey:@"preferenceInd"];
}

@end
