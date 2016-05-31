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


#import "HL7ElementParser.h"
#import "HL7Enums.h"

@class HL7Addr;
@class HL7Code;
@class HL7Translation;
@class HL7Telecom;
@class HL7Name;
@class HL7Identifier;
@class HL7Text;
@class HL7EffectiveTime;
@class HL7Value;
@class HL7Time;
@class HL7TemplateId;
@class HL7Author;
@class HL7StatusCode;
@class HL7PlayingEntity;
@class HL7Participant;
@class HL7OriginalText;
@class HL7InterpretationCode;
@class HL7DoseQuantity;

/** parser extensions */
@interface HL7ElementParser (Additions)
+ (nonnull HL7Code *)codeFromReader:(nonnull IGXMLReader *)reader withElementName:(nonnull NSString *)name withBlock:(void (^_Nullable)(IGXMLReader *_Nonnull))blk;
+ (nonnull HL7Code *)codeFromReader:(nonnull IGXMLReader *)reader withElementName:(nonnull NSString *)name;
+ (nonnull HL7Code *)codeFromReader:(nonnull IGXMLReader *)reader;
+ (nonnull HL7Code *)routeFromReader:(nonnull IGXMLReader *)reader;
+ (nonnull HL7Code *)administrationUnitCodeFromReader:(nonnull IGXMLReader *)reader;
+ (nonnull HL7Code *)targetSiteCodeFromReader:(nonnull IGXMLReader *)reader;
+ (nonnull HL7Code *)priorityCodeFromReader:(nonnull IGXMLReader *)reader;
+ (nonnull HL7Code *)methodCodeFromReader:(nonnull IGXMLReader *)reader;
+ (nonnull HL7DoseQuantity *)doseFromCodeReader:(nonnull IGXMLReader *)reader;
+ (nonnull HL7InterpretationCode *)interpretationCodeFromReader:(nonnull IGXMLReader *)reader;
+ (nonnull HL7Translation *)translationFromReader:(nonnull IGXMLReader *)reader;
+ (nonnull HL7StatusCode *)statusCodeFromReader:(nonnull IGXMLReader *)reader;
+ (nonnull HL7Value *)valueFromReader:(nonnull IGXMLReader *)reader;
+ (nonnull HL7Addr *)addrFromReader:(nonnull IGXMLReader *)reader;
+ (nonnull HL7Telecom *)telecomFromReader:(nonnull IGXMLReader *)reader;
+ (nonnull HL7Name *)nameFromReader:(nonnull IGXMLReader *)reader;
+ (nonnull HL7Identifier *)identifierFromReader:(nonnull IGXMLReader *)reader;
+ (nonnull HL7TemplateId *)templateIdFromReader:(nonnull IGXMLReader *)reader;
+ (nonnull HL7Text *)textFromReader:(nonnull IGXMLReader *)reader;
+ (nonnull HL7EffectiveTime *)effectiveTimeFromReader:(nonnull IGXMLReader *)reader;
+ (nonnull HL7Time *)timeFromReader:(nonnull IGXMLReader *)reader;
+ (nonnull HL7PlayingEntity *)playingEntityFromReader:(nonnull IGXMLReader *)reader;
#pragma mark clinical
+ (nonnull HL7Author *)authorFromReader:(nonnull IGXMLReader *)reader;
+ (nonnull HL7Participant *)participantFromReader:(nonnull IGXMLReader *)reader;
+ (nonnull HL7OriginalText *)originalTextFromReader:(nonnull IGXMLReader *)reader;
@end
