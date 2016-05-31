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
#import "HL7CCDParserDelegateProtocol.h"

@class HL7CCD;
@class HL7Element;
@class HL7Section;
@class IGXMLReader;

@interface ParserContext : NSObject
@property (nullable, nonatomic, weak) HL7CCD *hl7ccd;
@property (nullable, nonatomic, weak) IGXMLReader *reader;
@property (nullable, nonatomic, weak) IGXMLReader *node;
@property (nullable, nonatomic, weak) HL7Element *element;
@property (nullable, nonatomic, weak) HL7Section *section;
@property (nullable, nonatomic, weak) id<HL7CCDParserDelegateProtocol> delegate;

- (nonnull instancetype)initWithReader:(nonnull IGXMLReader *)reader hl7ccd:(nonnull HL7CCD *)hl7ccd;
- (nonnull instancetype)initWithReader:(nonnull IGXMLReader *)reader;
- (void)stashElementReplaceWith:(HL7Element *_Nonnull)element withBlock:(void (^_Nonnull)())block;
- (void)stashElementReplaceWith:(HL7Element *_Nonnull)element;
- (void)popElement;
@end
