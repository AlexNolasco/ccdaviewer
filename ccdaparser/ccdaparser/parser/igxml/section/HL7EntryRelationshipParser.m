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


#import "HL7EntryRelationshipParser.h"
#import "HL7EntryRelationship.h"
#import "HL7Const.h"
#import "ParserContext.h"
#import "ParserPlan.h"
#import "IGXMLReader.h"

@implementation HL7EntryRelationshipParser

- (NSString *)designatedElementName
{
    return HL7ElementEntryRelationship;
}

- (ParserPlan *)createParsePlan:(ParserContext *)context HL7Element:(HL7EntryRelationship *)entryRelationship error:(NSError *__autoreleasing *)error
{
    ParserPlan *plan = [ParserPlan planAtDepth:[[context reader] depth]];

    // Entry relationship
    [plan when:HL7ElementEntryRelationship
        parseWithBlock:^(ParserContext *context, IGXMLReader *node, BOOL *stop) {
            if ([node hasAttributes]) {
                [entryRelationship setTypeCode:[node attributeWithName:HL7AttributeTypeCode]];
                [entryRelationship setInversionInd:[node attributeWithName:HL7AttributeInversionInd]];
            }
        }];
    return plan;
}
@end
