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


#import "HL7ProcedureActivityActParser.h"
#import "HL7Const.h"
#import "HL7ElementParser+Additions.h"
#import "IGXMLReader.h"
#import "IGXMLReader+Additions.h"
#import "HL7ProcedureActivityAct.h"
#import "ParserContext.h"
#import "ParserPlan.h"

@implementation HL7ProcedureActivityActParser
- (ParserPlan *)createParsePlan:(ParserContext *)context HL7Element:(HL7ProcedureActivityAct *)act error:(NSError *__autoreleasing *)error
{
    ParserPlan *parserPlan = [super createParsePlan:context HL7Element:act error:error];

    // priority code
    [parserPlan when:HL7ElementPriorityCode
        parseWithBlock:^(ParserContext *context, IGXMLReader *node, BOOL *stop) {
            [act setPriorityCode:[HL7ElementParser priorityCodeFromReader:node]];
        }];
    return parserPlan;
}

- (BOOL)parse:(ParserContext *)context error:(NSError *__autoreleasing *)error
{
    NSAssert([[context element] isKindOfClass:[HL7ProcedureActivityAct class]], @"element must be HL7ProcedureActivityAct");

    ParserPlan *parserPlan = [self createParsePlan:context HL7Element:(HL7ProcedureActivityAct *)[context element] error:error];
    [self iterate:(ParserContext *)context
        usingBlock:^(ParserContext *context, BOOL *stop) {
            [self parse:context usingPlan:parserPlan stop:stop];
        }];
    return YES;
}
@end
