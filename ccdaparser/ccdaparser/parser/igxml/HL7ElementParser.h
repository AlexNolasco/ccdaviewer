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


#import "HL7ElementParserProtocol.h"

@class HL7TemplateElement;
@class HL7CCD;
@class IGXMLReader;
@class ParserPlan;

/** Abstract class */
@interface HL7ElementParser : NSObject <HL7ElementParserProtocol>
+ (void)iterate:(IGXMLReader *)reader untilEndOfElementName:(NSString *)name usingBlock:(void (^)(IGXMLReader *node, BOOL *stop))blk;
- (void)iterate:(ParserContext *)context untilEndOfElementName:(NSString *)name usingBlock:(void (^)(ParserContext *context, BOOL *stop))blk;
- (void)iterate:(ParserContext *)context usingBlock:(void (^)(ParserContext *, BOOL *))blk;
- (void)parse:(ParserContext *)context usingPlan:(ParserPlan *)plan stop:(BOOL *)stop;

#pragma mark Protocol
- (NSString *)designatedElementName;
- (BOOL)parse:(ParserContext *)context error:(NSError *__autoreleasing *)error;
@end
