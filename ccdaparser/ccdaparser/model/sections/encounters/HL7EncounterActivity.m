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


#import "HL7EncounterActivity.h"
#import "HL7Const.h"
#import "HL7EntryRelationship.h"
#import "HL7IndicationObservation.h"
#import "HL7EncounterDiagnosis.h"
#import "HL7EntryRelationshipFinder.h"

@implementation HL7EncounterActivity
- (NSMutableArray<HL7EntryRelationship *> *)descendants
{
    if (_descendants == nil) {
        _descendants = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _descendants;
}

- (HL7Element *_Nullable)elementByTemplateId:(NSString *)templateId
{
    return [HL7EntryRelationshipFinder findByTemplateId:templateId inCollection:self];
}

- (HL7IndicationObservation *_Nullable)indicationObservation
{
    HL7Element *element = [self elementByTemplateId:HL7TemplateIndicationObservation];
    if ([element isKindOfClass:[HL7IndicationObservation class]]) {
        return (HL7IndicationObservation *)element;
    } else {
        return nil;
    }
}

- (HL7EncounterDiagnosis *_Nullable)encounterDiagnosis
{
    HL7Element *element = [self elementByTemplateId:HL7TemplateEncounterDiagnosis];
    if ([element isKindOfClass:[HL7EncounterDiagnosis class]]) {
        return (HL7EncounterDiagnosis *)element;
    } else {
        return nil;
    }
}

@end
