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


#import <libxml/xmlreader.h>
#import "IGXMLReader+Additions.h"
#import "HelperMacros.h"

@implementation IGXMLReader (Additions)

- (instancetype)initWithXMLFilePath:(NSString *)fullPath error:(NSError *__autoreleasing *)error
{
    if (fullPath == nil) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:@"com.coladapp.hl7parser" code:HL7CCDFileNotFound userInfo:@{ NSLocalizedDescriptionKey : LOCALIZED_STRING(@"error.fileNotFound") }];
        }
        return [self init];
    }
    NSData *data = [NSData dataWithContentsOfFile:fullPath options:NSDataReadingMappedAlways error:error];

    if (error && *error) {
        return [self init];
    }
    return [self initWithXMLData:data URL:nil encoding:@"UTF-8" options:XML_PARSE_NONET];
}

- (instancetype)initWithXMLFile:(NSString *)filename fileExtension:(NSString *)extension error:(NSError *__autoreleasing *)error
{
    NSString *fullPath = [[NSBundle bundleForClass:[self class]] pathForResource:filename ofType:extension];

    return [self initWithXMLFilePath:fullPath error:error];
}

- (BOOL)isStartOfElementWithName:(NSString *)name
{
    if ([self type] == IGXMLReaderNodeTypeElement && [[self name] isEqualToString:name]) {
        return YES;
    }
    return NO;
}

- (BOOL)isEndOfElementWithName:(NSString *)name
{
    if ([self type] == IGXMLReaderNodeTypeEndElement && [[self name] isEqualToString:name]) {
        return YES;
    }
    return NO;
}
@end
