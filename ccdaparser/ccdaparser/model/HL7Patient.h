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


#import "HL7Element.h"
#import "HL7Enums.h"
@class HL7Name;
@class HL7Code;
@class HL7Guardian;
@class HL7LanguageCommunication;

@interface HL7Patient : HL7Element
@property (nullable, nonatomic, copy) NSString *birthTime;
@property (nonnull, nonatomic, strong) NSMutableArray<HL7Name *> *names;
@property (nullable, nonatomic, strong) HL7Code *administrativeGenderCode;
@property (nullable, nonatomic, strong) HL7Code *maritalStatusCode;
@property (nullable, nonatomic, strong) HL7Code *ethnicGroupCode;
@property (nullable, nonatomic, strong) HL7Code *raceCode;
@property (nullable, nonatomic, strong) HL7Code *religiousAffiliationCode;
@property (nonnull, nonatomic, strong) NSMutableArray<HL7Guardian *> *guardians;
@property (nonnull, nonatomic, strong) NSMutableArray<HL7LanguageCommunication*>* languages;
- (nullable NSDate *)birthday;
- (NSUInteger)age;
- (HL7AdministrativeGenderCode)gender;
- (HL7MaritalStatusCode)maritalStatus;
- (HL7Name *_Nullable)name;
- (HL7LanguageCommunication * _Nullable)preferredLanguage;
- (NSString * _Nullable)preferredLanguageAsString;
@end
