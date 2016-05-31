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


#import "HL7ProblemActParser.h"
#import "HL7ProblemConcernAct.h"
#import "HL7EntryRelationship.h"
#import "HL7ProblemEntryRelationshipParser.h"
#import "IGXMLReader.h"
#import "IGXMLReader+Additions.h"
#import "ParserContext.h"
#import "ParserPlan.h"

@implementation HL7ProblemActParser
- (ParserPlan *)createParsePlan:(ParserContext *)context HL7Element:(HL7ProblemConcernAct *)problemsConcernAct error:(NSError *__autoreleasing *)error
{
    NSAssert([[context element] isKindOfClass:[HL7ProblemConcernAct class]], @"element must be HL7ProblemConcernAct");

    ParserPlan *parserPlan = [super createParsePlan:context HL7Element:problemsConcernAct error:error];

    // entry relationship
    [parserPlan when:HL7ElementEntryRelationship
        parseWithBlock:^(ParserContext *context, IGXMLReader *node, BOOL *stop) {
            HL7EntryRelationship *entryRelationship = [[HL7EntryRelationship alloc] init];
            [context setElement:entryRelationship];

            [[[HL7ProblemEntryRelationshipParser alloc] init] parse:context error:error];

            [[problemsConcernAct descendants] addObject:entryRelationship];

        }];
    return parserPlan;
}

- (BOOL)parse:(ParserContext *)context error:(NSError *__autoreleasing *)error
{
    NSAssert([[context element] isKindOfClass:[HL7ProblemConcernAct class]], @"element must be HL7AllergyConcernAct");

    ParserPlan *parserPlan = [self createParsePlan:context HL7Element:(HL7ProblemConcernAct *)[context element] error:error];
    [self iterate:(ParserContext *)context
        usingBlock:^(ParserContext *context, BOOL *stop) {
            [self parse:context usingPlan:parserPlan stop:stop];
        }];
    return YES;
}
@end
