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
@class HL7Section;
@class HL7Entry;
@class ParserContext;
@class IGXMLReader;

@protocol HL7ElementSectionParserProtocol
@property (assign) BOOL enabled;
- (BOOL)supportsEntries;
- (NSString *_Nullable)templateId;
- (NSString *_Nullable)name;
- (HL7Section *_Nullable)createSectionFromSection:(HL7Section *_Nullable)section;
- (HL7Entry *_Nullable)createEntryWithNode:(IGXMLReader *_Nonnull)node;
- (void)parse:(ParserContext *_Nonnull)context node:(IGXMLReader *_Nonnull)node into:(HL7Entry *_Nonnull)entry error:(NSError *_Nullable __autoreleasing *_Nullable)error;
@end
