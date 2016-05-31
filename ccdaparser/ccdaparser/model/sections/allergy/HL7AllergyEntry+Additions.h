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


#import "HL7AllergyEntry.h"
@class HL7AllergyObservation;
@class HL7Text;
@class HL7CodeSystem;
@class HL7Value;

@interface HL7AllergyEntry (Additions)

- (HL7AllergyObservation *_Nullable)allergen;
- (NSArray<HL7AllergyObservation *> *_Nonnull)reactions;
- (HL7AllergyObservation *_Nullable)severity;
- (HL7AllergyObservation *_Nullable)status;

/** participant / participantRole / playingEntity / allergenCode */
- (HL7CodeSystem *_Nullable)allergenCode;
- (HL7Value *_Nullable)allergenValue;
- (HL7Value *_Nullable)firstReactionValue;
- (HL7Value *_Nullable)severityValue;
- (HL7Value *_Nullable)statusValue;

- (NSString *_Nullable)getAllergenUsingSectionTextAsReference:(HL7Text *_Nullable)sectionText;
- (NSString *_Nullable)getFirstReactionNameUsingSectionTextAsReference:(HL7Text *_Nullable)sectionText;
- (NSString *_Nullable)getSeverityUsingSectionTextAsReference:(HL7Text *_Nullable)sectionText;
- (NSString *_Nullable)getStatusUsingSectionTextAsReference:(HL7Text *_Nullable)sectionText;

- (NSArray<NSString *> *_Nonnull)getReactionsNamesUsingSectionTextAsReference:(HL7Text *_Nullable)sectionText;
@end
