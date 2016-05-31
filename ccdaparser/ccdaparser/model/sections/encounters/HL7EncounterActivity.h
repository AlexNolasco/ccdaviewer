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


#import "HL7TemplateElement.h"
#import "HL7EntryRelationshipContainerProtocol.h"
@class HL7EntryRelationship;
@class HL7IndicationObservation;
@class HL7EncounterDiagnosis;

/** This template wraps relevant problems or diagnoses at the close of a visit or that need to be followed after the visit. */
@interface HL7EncounterActivity : HL7TemplateElement <HL7EntryRelationshipContainerProtocol>
// Contains exactly one [1..1] Indication (templateId: 2.16.840.1.113883.10.20.22.4.19) (observation (RSON))
// Contains exactly one [1..1] Encounter Diagnosis (templateId: 2.16.840.1.113883.10.20.22.4.80) (act)
@property (nonnull, nonatomic, strong) NSMutableArray<HL7EntryRelationship *> *descendants;
- (HL7IndicationObservation *_Nullable)indicationObservation;
- (HL7EncounterDiagnosis *_Nullable)encounterDiagnosis;
@end
