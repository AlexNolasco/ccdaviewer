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


#import "ParserPlan.h"
#import "ParserContext.h"
#import "HL7ElementParser+Additions.h"
#import "HL7Const.h"
#import "HL7ActParser.h"
#import "HL7Act.h"


@implementation HL7ActParser
- (NSString *)designatedElementName
{
    return HL7ElementAct;
}

- (void)didFindEntryRelationship:(ParserContext *)context reader:(IGXMLReader *)reader error:(NSError *__autoreleasing *)error
{
    // nothing
}

- (ParserPlan *)createParsePlan:(ParserContext *)context HL7Element:(HL7Act *)element error:(NSError *__autoreleasing *)error
{

    ParserPlan *plan = [super createParsePlan:context HL7Element:element error:error];

    // Value
    [plan when:HL7ElementValue
        parseWithBlock:^(ParserContext *context, IGXMLReader *node, BOOL *stop) {
            [element setValue:[HL7ElementParser valueFromReader:[context reader]]];
        }];

    // Author
    [plan when:HL7ElementAuthor
        parseWithBlock:^(ParserContext *context, IGXMLReader *node, BOOL *stop) {
            [element setAuthor:[HL7ElementParser authorFromReader:[context reader]]];
        }];

    // Text
    [plan when:HL7ElementText
        parseWithBlock:^(ParserContext *context, IGXMLReader *node, BOOL *stop) {
            [element setText:[HL7ElementParser textFromReader:[context reader]]];
        }];

    // entry relationship
    [plan when:HL7ElementEntryRelationship
        parseWithBlock:^(ParserContext *context, IGXMLReader *node, BOOL *stop) {
            [self didFindEntryRelationship:context reader:node error:error];
        }];

    return plan;
}

- (BOOL)parse:(ParserContext *)context error:(NSError *__autoreleasing *)error
{
    ParserPlan *parserPlan = [self createParsePlan:context HL7Element:(HL7Act *)[context element] error:error];
    [self iterate:(ParserContext *)context
        usingBlock:^(ParserContext *context, BOOL *stop) {
            [self parse:context usingPlan:parserPlan stop:stop];
        }];
    return YES;
}
@end
