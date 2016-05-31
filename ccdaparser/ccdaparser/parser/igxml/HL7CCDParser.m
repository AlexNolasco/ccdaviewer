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


#import "HL7CCDParser.h"
#import "HL7Const.h"
#import "HL7CCD.h"
#import "HL7ClinicalDocumentElementParser.h"
#import "HL7SectionMapper.h"
#import "IGXMLReader.h"
#import "IGXMLReader+Additions.h"
#import "ParserContext.h"
#import "HelperMacros.h"

@interface HL7CCDParser ()
@property (nonnull, nonatomic, readonly) HL7SectionMapper *sectionMapper;
@property (nullable, nonatomic, strong) NSSet<NSString *> *templateIds;
@end

@implementation HL7CCDParser
- (HL7SectionMapper *)mapper
{
    if (_sectionMapper == nil) {
        _sectionMapper = [[HL7SectionMapper alloc] init];
    }
    return _sectionMapper;
}

- (void)didFinishParsing:(NSError **)error
{
    if ([[self delegate] respondsToSelector:@selector(didFinishParsing:)]) {
        [[self delegate] didFinishParsing:error];
    }
}

- (BOOL)parse:(ParserContext *)context error:(NSError *__autoreleasing *)error
{
    NSError *elementParserError;
    IGXMLReader *reader = [context reader];

    HL7ClinicalDocumentElementParser *documentParser = [[HL7ClinicalDocumentElementParser alloc] initWithMapper:[self mapper]];

    if ([[self delegate] respondsToSelector:@selector(willParseSectionsWithMapping:)]) {
        [[self delegate] willParseSectionsWithMapping:[self mapper]];
    } else if ([[self templateIds] count]) {
        [[self mapper] enableParsers:[self templateIds]];
    }

    [documentParser parse:context error:&elementParserError];
    if (error && elementParserError != nil) {
        *error = elementParserError;
        [self didFinishParsing:error];
        return NO;
    }

    if ([[reader errors] count] > 0 && error) {

        *error = [NSError errorWithDomain:@"com.coladapp.hl7parser" code:HL7CCDParserErrorParserFailed userInfo:@{ NSLocalizedDescriptionKey : LOCALIZED_STRING(@"error.parsing"), @"errors" : [reader errors] }];
    }
    [self didFinishParsing:error];
    return YES;
}

- (HL7CCD *)startParsing:(IGXMLReader *)reader error:(NSError *__autoreleasing *)error
{
    HL7CCD *hl7ccd = [[HL7CCD alloc] init];

    if (error && *error) {
        return hl7ccd;
    }
    ParserContext *context = [[ParserContext alloc] initWithReader:reader hl7ccd:hl7ccd];
    [context setDelegate:[self delegate]];
    [self parse:context error:error];
    return hl7ccd;
}

- (void)parseTemplateIds:(NSSet<NSString *> *)templateIds
{
    [self setTemplateIds:[templateIds copy]];
}

#pragma mark - parse

- (HL7CCD *)parseXMLString:(NSString *)xmlString error:(NSError *__autoreleasing *)error
{
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:xmlString];
    return [self startParsing:reader error:error];
}

- (HL7CCD *)parseXMLFile:(NSString *)filename error:(NSError *__autoreleasing *)error
{
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLFile:filename fileExtension:nil error:error];
    return [self startParsing:reader error:error];
}

- (HL7CCD *)parseXMLFilePath:(NSString *)fullPath error:(NSError *__autoreleasing *)error
{
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLFilePath:fullPath error:error];
    return [self startParsing:reader error:error];
}

- (HL7CCD *)parseXMLNSData:(NSData *)nsdata encoding:(NSString *)encoding error:(NSError *__autoreleasing *)error;
{
    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLData:nsdata URL:nil encoding:encoding];
    return [self startParsing:reader error:error];
}
@end
