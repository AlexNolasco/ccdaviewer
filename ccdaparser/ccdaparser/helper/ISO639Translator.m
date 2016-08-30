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

#import "ISO639Translator.h"

@implementation ISO639Translator
+ (NSString *)codeToString:(NSString *)code
{
    if ([code caseInsensitiveCompare:@"eng"] == NSOrderedSame ) {
        return @"English";
    }
    else if ([code caseInsensitiveCompare:@"esp"] == NSOrderedSame ) {
        return @"Spanish";
    }
    else if ([code caseInsensitiveCompare:@"chi"] == NSOrderedSame || [code caseInsensitiveCompare:@"zhx"] == NSOrderedSame) {
        return @"Chinese";
    }    
    else if ([code caseInsensitiveCompare:@"fra"] == NSOrderedSame ) {
        return @"French";
    }
    else if ([code caseInsensitiveCompare:@"eng"] == NSOrderedSame ) {
        return @"Italian";
    }
    else if ([code caseInsensitiveCompare:@"rus"] == NSOrderedSame ) {
        return @"Russian";
    }
    else if ([code caseInsensitiveCompare:@"por"] == NSOrderedSame ) {
        return @"Portuguese";
    }
    else if ([code caseInsensitiveCompare:@"ger"] == NSOrderedSame ) {
        return @"German";
    }
    else {
        return nil;
    }
}
@end
