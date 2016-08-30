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


#import "HL7VitalSignsSummaryEntry_Private.h"
#import "HL7VitalSignsSummaryItem_Private.h"
#import "HL7VitalSignsOrganizer_Private.h"
#import "HL7VitalSignsObservation.h"
#import "HL7EffectiveTime.h"
#import "HelperMacros.h"
#import "NSDate+TimeAgo.h"

@implementation HL7VitalSignsSummaryEntry

- (instancetype _Nonnull)initWithOrganizer:(HL7VitalSignsOrganizer *_Nonnull)organizer sectionText:(HL7Text *_Nullable)sectionText
{
    if ((self = [super init])) {
        [self setBmi:[HL7VitalSignsSummaryItem createWithObservation:[organizer bmi]]];
        [self setBpDiastolic:[HL7VitalSignsSummaryItem createWithObservation:[organizer bpDiastolic]]];
        [self setBpSystolic:[HL7VitalSignsSummaryItem createWithObservation:[organizer bpSystolic]]];
        [self setHeartRate:[HL7VitalSignsSummaryItem createWithObservation:[organizer heartRate]]];
        [self setHeight:[HL7VitalSignsSummaryItem createWithObservation:[organizer height]]];
        [self setWeight:[HL7VitalSignsSummaryItem createWithObservation:[organizer weight]]];
        [self setTemperature:[HL7VitalSignsSummaryItem createWithObservation:[organizer temperature]]];
        [self setOrganizerEffetiveTime:[[organizer effectiveTime] valueAsNSDate]];
        if ([self organizerEffectiveTime]) {
            [self setOrganizerEffectiveTimeHumanized:[[self organizerEffectiveTime] timeAgo]];
        }
    }
    return self;
}

- (NSDate *)organizerEffectiveTime
{
    return _organizerEffetiveTime;
}

- (NSString *_Nullable)organizerEffectiveTimeHumanized
{
    return _organizerEffectiveTimeHumanized;
}

- (NSString *)narrative
{
    return [NSString stringWithFormat:@"BMI:%@ Heart Rate:%@ Systolic: %@ Diastolic: %@ Weight: %@ Height: %@", [[self bmi] description], [[self heartRate] description], [[self bpSystolic] description], [[self bpDiastolic] description], [[self weight] description], [[self height] description]];
}

#pragma mark -
- (id)copyWithZone:(nullable NSZone *)zone
{
    HL7VitalSignsSummaryEntry *clone = [super copyWithZone:zone];
    [clone setBmi:[[self bmi] copy]];
    [clone setBpDiastolic:[[self bpDiastolic] copy]];
    [clone setBpSystolic:[[self bpSystolic] copy]];
    [clone setHeartRate:[[self heartRate] copy]];
    [clone setHeight:[[self height] copy]];
    [clone setWeight:[[self weight] copy]];
    [clone setTemperature:[[self temperature] copy]];
    [clone setOrganizerEffetiveTime:[self organizerEffectiveTime]];
    return clone;
}

#pragma mark -
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder]) {
        [self setBmi:[decoder decodeObjectForKey:@"bmi"]];
        [self setBpDiastolic:[decoder decodeObjectForKey:@"bpDiastolic"]];
        [self setBpSystolic:[decoder decodeObjectForKey:@"bpSystolic"]];
        [self setHeartRate:[decoder decodeObjectForKey:@"heartRate"]];
        [self setHeight:[decoder decodeObjectForKey:@"height"]];
        [self setWeight:[decoder decodeObjectForKey:@"weight"]];
        [self setTemperature:[decoder decodeObjectForKey:@"temperature"]];
        [self setOrganizerEffetiveTime:[decoder decodeObjectForKey:@"organizerEffectiveTime"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeObject:[self bmi] forKey:@"bmi"];
    [encoder encodeObject:[self bpDiastolic] forKey:@"bpDiastolic"];
    [encoder encodeObject:[self bpSystolic] forKey:@"bpSystolic"];
    [encoder encodeObject:[self heartRate] forKey:@"heartRate"];
    [encoder encodeObject:[self height] forKey:@"height"];
    [encoder encodeObject:[self weight] forKey:@"weight"];
    [encoder encodeObject:[self temperature] forKey:@"temperature"];
    [encoder encodeObject:[self organizerEffectiveTime] forKey:@"organizerEffectiveTime"];
}
@end
