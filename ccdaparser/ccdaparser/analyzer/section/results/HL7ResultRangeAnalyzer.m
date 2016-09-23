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


#import "HL7ResultRangeAnalyzer.h"
#import "HL7ResultObservation.h"
#import "HL7Code.h"
#import "HL7ResultReferenceRange.h"
#import "HL7ResultObservationRange.h"
#import "HL7Value.h"

const static NSString* kHL7ResultRangeAnalyzerClassType = @"classType";
const static NSString* kHL7ResultRangeAnalyzerUnits = @"units";
const static NSString* kHL7ResultRangeAnalyzerRanges = @"ranges";
const static NSString* kHL7ResultRangeAnalyzerBoth = @"both";
const static NSString* kHL7ResultRangeAnalyzerFemale = @"female";
const static NSString* kHL7ResultRangeAnalyzerMale = @"male";
const static NSString* kHL7ResultRangeAnalyzerMinimum = @"min";
const static NSString* kHL7ResultRangeAnalyzerMaximum = @"max";

@interface HL7ResultRangeAnalyzer()
@property (nonatomic, strong) NSDictionary * loincCodes;
@end

@implementation HL7ResultRangeAnalyzer

- (NSDictionary *) loadDictionaryFromBundleWithName: (NSString *) name
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *plistPath = [bundle pathForResource:name ofType:@"plist"];
        return [NSDictionary dictionaryWithContentsOfFile:plistPath];
}

- (NSDictionary *) loincCodes
{
    if (_loincCodes == nil) {
        _loincCodes = [self loadDictionaryFromBundleWithName:@"ResultRanges"];
    }
    return _loincCodes;
}


- (HL7ResultRange) resultRangeForSummaryEntry: (HL7ResultObservation *)resultObservation forGender:(HL7AdministrativeGenderCode) genderCode
{
    HL7Value * resultValue = resultObservation.value;
    
    
    if (!resultValue || (genderCode!=HL7AdministrativeGenderCodeFemale && genderCode!=HL7AdministrativeGenderCodeMale)) { // no value
        return HL7ResultRangeUnknown;
    }
    
    if (![resultValue.value length]) {
        return HL7ResultRangeUnknown;
    }
    
    NSDictionary * codeInfo = [self.loincCodes objectForKey:resultObservation.code.code];
    if (!codeInfo) { // no matching code in info file
        return HL7ResultRangeUnknown;
    }
    
    NSDictionary * ranges = [codeInfo objectForKey:kHL7ResultRangeAnalyzerRanges];
    if (ranges == nil) { // no ranges found, bad info file
        return HL7ResultRangeUnknown;
    }
    
    // See if it is gender specific
    NSDictionary * genderRange = [ranges objectForKey:kHL7ResultRangeAnalyzerBoth];
    if (genderRange == nil && genderCode == HL7AdministrativeGenderCodeFemale) {
        genderRange = [ranges objectForKey:kHL7ResultRangeAnalyzerFemale];
    }
    else if (genderRange == nil && genderCode == HL7AdministrativeGenderCodeMale) {
        genderRange = [ranges objectForKey:kHL7ResultRangeAnalyzerMale];
    }
    
    if (genderRange == nil) {
        return HL7ResultRangeUnknown;
    }
    
    // See if the units match
    if (![resultValue.unit isEqualToString:[codeInfo objectForKey:kHL7ResultRangeAnalyzerUnits] ]) {
        return HL7ResultRangeUnknown;
    }
    
    NSNumber * minimum = [genderRange objectForKey:kHL7ResultRangeAnalyzerMinimum];
    NSNumber * maximum = [genderRange objectForKey:kHL7ResultRangeAnalyzerMaximum];
    
    
    if (maximum == nil || minimum == nil) {
        return HL7ResultRangeUnknown;
    }
    
    if ([resultValue.valueAsDecimalNumber floatValue] < [minimum floatValue]) {
        return HL7ResultRangeBelowNormal;
    }

    if ([resultValue.valueAsDecimalNumber floatValue] > [maximum floatValue]) {
        return HL7ResultRangeAboveNormal;
    }
    
    return HL7ResultRangeNormal;
}
@end
