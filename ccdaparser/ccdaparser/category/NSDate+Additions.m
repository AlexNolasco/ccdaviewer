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


#import "NSDate+Additions.h"

@implementation NSDate (Additions)
+ (NSDate *)fromISO8601String:(NSString *)isoString
{
    if (![isoString length]) {
        return nil;
    }

    NSArray *formats = @[ @"yyyyMMddHHmmssZ", @"yyyyMMddHHmmZ", @"yyyyMMddHHmmss", @"yyyyMMddHHmm", @"yyyyMMdd", @"yyyy" ];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:posix];

    for (NSString *format in formats) {
        [dateFormatter setDateFormat:format];
        NSDate *result = [dateFormatter dateFromString:isoString];
        if (result != nil) {
            return result;
        }
    }
    return nil;
}

- (BOOL)isEqualToISO8601String:(NSString *)isoString
{
    NSDate *compareTo = [NSDate fromISO8601String:isoString];
    return [self compare:compareTo] == NSOrderedSame;
}

- (NSString *)toShortDateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    return [dateFormatter stringFromDate:self];
}

@end
