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


#import "HL7Participant.h"
#import "HL7ParticipantRole.h"
#import "HL7PlayingEntity.h"

@implementation HL7Participant
- (HL7Code *_Nullable)participantRolePlayingEntityCode
{
    return [[self playingEntity] code];
}

- (HL7PlayingEntity *_Nullable)playingEntity
{
    if ([self participantRole] == nil) {
        return nil;
    }
    return [[self participantRole] playingEntity];
}

- (id)copyWithZone:(nullable NSZone *)zone
{
    HL7Participant *clone = [super copyWithZone:zone];
    [clone setTypeCode:[[self typeCode] copyWithZone:zone]];
    [clone setParticipantRole:[[self participantRole] copyWithZone:zone]];
    return clone;
}
@end
