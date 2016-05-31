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


#import "HL7Enums.h"

@interface HL7Enumerations ()
+ (NSString *_Nullable)maritalStatusAsString:(HL7MaritalStatusCode)maritalStatusCode;
+ (NSString *_Nullable)genderAsString:(HL7AdministrativeGenderCode)genderCode;
+ (NSString *_Nullable)useAsString:(HL7UseAddressType)useCode;
+ (NSString *_Nullable)nameUseAsString:(HL7UseNameType)nameUseCode;
+ (NSString *_Nullable)statusCodeAsString:(HL7StatusCodeCode)statusCodeCode;
+ (NSString *_Nullable)moodCodeAsString:(HL7MoodCode)moodCode;
+ (NSString *_Nullable)problemSeverityAsString:(HL7ProblemSeverityCode)problemSeverityCode;

+ (HL7NullFlavor)hl7NullFlavorFromString:(NSString *_Nullable)nullFlavor;
+ (HL7UseAddressType)hl7AddressTypeUseFromString:(NSString *_Nullable)useCode;
+ (HL7UseNameType)hl7NameUseFromString:(NSString *_Nullable)useNameCode;
+ (HL7UseTelecomType)hl7TelecomUseFromString:(NSString *_Nullable)useTelecomCode;
+ (HL7ProblemSeverityCode)hl7ProblemSeverityCodeFromString:(NSString *_Nullable)problemSeverityCode;
@end
