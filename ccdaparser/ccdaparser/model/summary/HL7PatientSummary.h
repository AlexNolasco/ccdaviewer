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


#import <Foundation/Foundation.h>
#import "HL7Enums.h"
#import "HL7SummaryProtocol.h"

@class HL7GuardianSummary;
@class HL7Name;

@interface HL7PatientSummary : NSObject <HL7SummaryProtocol, NSCopying, NSCoding>
- (NSDate *_Nullable)dob;
- (NSNumber *_Nullable)age;
- (BOOL)ageHasValue;
- (NSString *_Nullable)gender;
- (HL7AdministrativeGenderCode)genderCode;
- (NSString *_Nullable)maritalStatus;
- (HL7MaritalStatusCode)maritalStatusCode;
- (NSString *_Nullable)fullName;
- (HL7Name * _Nullable)name;
- (NSString *_Nullable)ethnicGroup;
- (NSString *_Nullable)race;
- (NSString *_Nullable)religiousAffiliation;
/** Primary home phone number or first */
- (NSString *_Nullable)phoneNumber;
- (NSString *_Nullable)emailAddress;
- (NSString *_Nullable)preferredLanguage;
- (NSArray<HL7GuardianSummary *> *_Nullable)guardians;
@end
