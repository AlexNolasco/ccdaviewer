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


#import "HL7Act.h"
@class HL7AllergyObservation;
@class HL7EntryRelationship;
@class HL7EffectiveTime;

/*
2.16.840.1.113883.10.20.22.4.30
This clinical statement act represents a concern relating to a patient's allergies or adverse events. A
concern is a term used when referring to patient's problems that are related to one another. Observations of
problems or other clinical statements captured at a point in time are wrapped in a Allergy Problem Act, or
"Concern" act, which represents the ongoing process tracked over time. This outer Allergy Problem Act
(representing the "Concern") can contain nested problem observations or other nested clinical statements
relevant to the allergy concern.
**/
@interface HL7AllergyConcernAct : HL7Act
/** returns first entry relationship with an observation */
@property (nullable, nonatomic, readonly) HL7EntryRelationship *firstEntryRelationship;
@property (nonnull, nonatomic, strong) NSMutableArray<HL7EntryRelationship *> *descendants;
@end
