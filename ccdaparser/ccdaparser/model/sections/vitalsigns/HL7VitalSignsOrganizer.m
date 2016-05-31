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


#import "HL7VitalSignsOrganizer.h"
#import "HL7Code.h"
#import "HL7VitalSignsObservation.h"
#import "HL7Codes.h"

@implementation HL7VitalSignsOrganizer

- (NSMutableArray<HL7VitalSignsObservation *> *)observations
{
    if (_observations == nil) {
        _observations = [[NSMutableArray alloc] initWithCapacity:2];
    }
    return _observations;
}

- (HL7VitalSignsObservation *_Nullable)getObservationByCodeId:(NSString *_Nonnull)codeId
{
    for (HL7VitalSignsObservation *observation in [self observations]) {
        if ([[[observation code] code] isEqualToString:codeId]) {
            return observation;
        }
    }
    return nil;
}

- (BOOL)hasAtLeastOneSummaryItem
{
    if ([self bmi] != nil || [self bpDiastolic] != nil || [self bpSystolic] != nil || [self heartRate] != nil || [self weight] != nil || [self height] != nil) {
        return YES;
    }
    return NO;
}

- (HL7VitalSignsObservation *_Nullable)bmi
{
    return [self getObservationByCodeId:CODELOINCBMI];
}

- (HL7VitalSignsObservation *_Nullable)height
{
    return [self getObservationByCodeId:CODELOINCHeight];
}

- (HL7VitalSignsObservation *_Nullable)weight
{
    return [self getObservationByCodeId:CODELOINCWeight];
}

- (HL7VitalSignsObservation *_Nullable)bpSystolic
{
    return [self getObservationByCodeId:CODELOINCBPSystolic];
}

- (HL7VitalSignsObservation *_Nullable)bpDiastolic
{
    return [self getObservationByCodeId:CODELOINCBPDiastolic];
}

- (HL7VitalSignsObservation *_Nullable)heartRate
{
    return [self getObservationByCodeId:CODELOINCHeartRate];
}

- (HL7VitalSignsObservation *_Nullable)temperature
{
    return [self getObservationByCodeId:CODELOINCTemperature];
}

@end
