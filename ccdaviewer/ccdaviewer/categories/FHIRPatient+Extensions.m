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


#import "FHIRPatient+Extensions.h"
#import "FHIRName.h"
#import "NSDate+ISOParsing.h"
#import "FHIRLink.h"

@implementation FHIRPatient (Extensions)
- (NSString *)fullName
{
    if (![[self name] count]) {
        return NSLocalizedString(@"Common.UnknownName", nil);
    }

    FHIRName *compositeName = [[self name] firstObject];
    NSString *given = nil;
    NSString *family = nil;

    if ([[compositeName given] count]) {
        given = [[[compositeName given] firstObject] capitalizedString];
    }

    if ([[compositeName family] count]) {
        family = [[[compositeName family] firstObject] capitalizedString];
    }

    NSString *result = nil;

    if ([given length]) {
        if ([family length]) {
            result = [NSString stringWithFormat:@"%@ %@", given, family];
        } else {
            result = [NSString stringWithFormat:@"%@", given];
        }
    } else if ([family length]) {
        result = [NSString stringWithFormat:@"%@", family];
    }

    return result;
}

- (NSNumber *)age
{
    if (![[self birthDate] length]) {
        return nil;
    }

    NSDate *parsed = [NSDate fromFHIRISO8601String:[self birthDate]];
    if (!parsed) {
        return nil;
    }

    NSDate *now = [NSDate date];
    NSDateComponents *ageComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:parsed toDate:now options:0];

    return [NSNumber numberWithInteger:[ageComponents year]];
}

- (HL7AdministrativeGenderCode)genderCode
{
    if ([[self gender] isEqualToString:@"male"] || [[self gender] isEqualToString:@"M"]) {
        return HL7AdministrativeGenderCodeMale;
    } else if ([[self gender] isEqualToString:@"female"] || [[self gender] isEqualToString:@"F"]) {
        return HL7AdministrativeGenderCodeFemale;
    } else if ([[self gender] isEqualToString:@"other"] || [[self gender] isEqualToString:@"O"]) {
        return HL7AdministrativeGenderCodeUndifferentiated;
    } else {
        return HL7AdministrativeGenderCodeUnknown;
    }
}

- (NSString *)summary
{
    NSNumber *age = [self age];
    NSString *gender = [self gender];
    if (age && [gender length]) {
        return [NSString stringWithFormat:@"%@ %@ years old", [gender capitalizedString], age];
    } else if (age) {
        return [NSString stringWithFormat:@"%@ years old", age];
    } else if (gender) {
        return [gender capitalizedString];
    }
    return NSLocalizedString(@"Patient.NoInformation", nil);
}

- (NSString *)ccdaLink
{
    if (![[self link] count]) {
        return nil;
    }
    FHIRLink *link = [[self link] firstObject];
    if (![[link url] length]) {
        return nil;
    }
    return [link url];
}
@end
