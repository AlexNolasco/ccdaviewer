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


#import "HL7ProblemEntryRelationshipParser.h"
#import "HL7Const.h"
#import "HL7Element_Private.h"
#import "HL7ProblemActParser.h"
#import "HL7ProblemEntryRelationship.h"
#import "HL7ProblemObservation.h"
#import "HL7ProblemObservationParser.h"
#import "HL7EntryRelationship.h"
#import "ParserContext.h"
#import "ParserPlan.h"
#import "IGXMlReader.h"

@implementation HL7ProblemEntryRelationshipParser
- (NSString *)designatedElementName
{
    return HL7ElementEntryRelationship;
}

- (ParserPlan *)createParsePlan:(ParserContext *)context HL7Element:(HL7ProblemEntryRelationship *)entryRelationship error:(NSError *__autoreleasing *)error
{

    ParserPlan *plan = [super createParsePlan:context HL7Element:entryRelationship error:error];

    // Entry relationship
    [plan when:HL7ElementEntryRelationship
        parseWithBlock:^(ParserContext *context, IGXMLReader *node, BOOL *stop) {
            HL7ProblemEntryRelationship *entryRelationship = [[HL7ProblemEntryRelationship alloc] init];
            [context setElement:entryRelationship];
            [[[HL7EntryRelationshipParser alloc] init] parse:context error:error];
            [entryRelationship addChildElement:entryRelationship];
        }];

    // Observation
    [plan when:HL7ElementObservation
        parseWithBlock:^(ParserContext *context, IGXMLReader *node, BOOL *stop) {
            HL7ProblemObservation *problemObservation = [[HL7ProblemObservation alloc] init];
            [problemObservation setParent:entryRelationship];
            [context setElement:problemObservation];
            [[[HL7ProblemObservationParser alloc] init] parse:context error:error];
            [entryRelationship addChildElement:problemObservation];
        }];

    return plan;
}

- (BOOL)parse:(ParserContext *)context error:(NSError *__autoreleasing *)error
{
    HL7ProblemEntryRelationship *entryRelationship = (HL7ProblemEntryRelationship *)[context element];
    ParserPlan *parserPlan = [self createParsePlan:context HL7Element:entryRelationship error:error];

    [self iterate:(ParserContext *)context
        usingBlock:^(ParserContext *context, BOOL *stop) {
            [self parse:context usingPlan:parserPlan stop:stop];
        }];
    return YES;
}
@end
