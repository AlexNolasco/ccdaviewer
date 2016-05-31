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


#import "HL7VitalSignsOrganizerParser.h"
#import "HL7VitalSignsOrganizer.h"
#import "HL7Const.h"
#import "HL7VitalSignsEntry.h"
#import "HL7VitalSignsOrganizer.h"
#import "HL7VitalSignsObservation.h"
#import "HL7ObservationParser.h"
#import "HL7VitalSignsObservationParser.h"
#import "ParserContext.h"
#import "ParserPlan.h"
#import "IGXMLReader.h"
#import "IGXMLReader+Additions.h"

@implementation HL7VitalSignsOrganizerParser

- (NSString *)designatedElementName
{
    return HL7ElementOrganizer;
}

- (ParserPlan *)createParsePlan:(ParserContext *)context HL7Element:(HL7VitalSignsOrganizer *)templateElement error:(NSError *__autoreleasing *)error
{

    ParserPlan *parserPlan = [super createParsePlan:context HL7Element:templateElement error:error];

    [parserPlan when:HL7ElementComponent
        parseWithBlock:^(ParserContext *context, IGXMLReader *node, BOOL *stop) {
            // alternatively a vital signs observation parser could be used
            [self iterate:context
                untilEndOfElementName:HL7ElementComponent
                           usingBlock:^(ParserContext *context, BOOL *stop) {
                               if ([[context reader] isStartOfElementWithName:HL7ElementObservation]) {
                                   HL7VitalSignsOrganizer *organizer = (HL7VitalSignsOrganizer *)[context element];
                                   HL7VitalSignsObservationParser *observationParser = [[HL7VitalSignsObservationParser alloc] init];
                                   HL7VitalSignsObservation *observation = [[HL7VitalSignsObservation alloc] init];

                                   [context stashElementReplaceWith:observation
                                                          withBlock:^{
                                                              [observationParser parse:context error:error];
                                                          }];
                                   [[organizer observations] addObject:observation];
                               }
                           }];
        }];
    return parserPlan;
}

- (BOOL)parse:(ParserContext *)context error:(NSError *__autoreleasing *)error
{
    ParserPlan *parserPlan = [self createParsePlan:context HL7Element:(HL7VitalSignsOrganizer *)[context element] error:error];
    [self iterate:(ParserContext *)context
        usingBlock:^(ParserContext *context, BOOL *stop) {
            [self parse:context usingPlan:parserPlan stop:stop];
        }];
    return YES;
}
@end
