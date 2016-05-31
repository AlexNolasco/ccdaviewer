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


#import "HL7ResultOrganizerParser.h"
#import "HL7Const.h"
#import "HL7ResultOrganizer.h"
#import "HL7ResultObservation.h"
#import "HL7ResultObservationParser.h"
#import "IGXMLReader.h"
#import "IGXMLReader+Additions.h"
#import "ParserContext.h"
#import "ParserPlan.h"

@implementation HL7ResultOrganizerParser
- (NSString *)designatedElementName
{
    return HL7ElementOrganizer;
}

- (ParserPlan *)createParsePlan:(ParserContext *)context HL7Element:(HL7ResultOrganizer *)organizer error:(NSError *__autoreleasing *)error
{

    ParserPlan *plan = [super createParsePlan:context HL7Element:organizer error:error];

    // component
    [plan when:HL7ElementComponent
        parseWithBlock:^(ParserContext *context, IGXMLReader *node, BOOL *stop) {
            [self iterate:context
                untilEndOfElementName:HL7ElementComponent
                           usingBlock:^(ParserContext *context, BOOL *stop) {
                               if ([node isStartOfElementWithName:HL7ElementObservation]) { // observation
                                   HL7ResultObservation *observation = [[HL7ResultObservation alloc] init];
                                   HL7ResultObservationParser *observationParser = [[HL7ResultObservationParser alloc] init];
                                   [context setElement:observation];
                                   [observationParser parse:context error:error];
                                   [[organizer observations] addObject:observation];
                               }
                           }];
        }];

    return plan;
}

- (BOOL)parse:(ParserContext *)context error:(NSError *__autoreleasing *)error
{

    ParserPlan *parserPlan = [self createParsePlan:context HL7Element:(HL7ResultOrganizer *)[context element] error:error];
    [self iterate:(ParserContext *)context
        usingBlock:^(ParserContext *context, BOOL *stop) {
            [self parse:context usingPlan:parserPlan stop:stop];
        }];
    return YES;
}

@end
