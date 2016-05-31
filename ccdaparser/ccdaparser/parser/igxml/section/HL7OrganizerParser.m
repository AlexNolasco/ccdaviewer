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


#import "HL7OrganizerParser.h"
#import "HL7Const.h"
#import "HL7TemplateElement.h"
#import "HL7Organizer.h"
#import "ParserPlan.h"
#import "ParserContext.h"
#import "IGXMLReader.h"


@implementation HL7OrganizerParser
- (ParserPlan *)createParsePlan:(ParserContext *)context HL7Element:(HL7TemplateElement *)templateElement error:(NSError *__autoreleasing *)error
{
    ParserPlan *plan = [super createParsePlan:context HL7Element:templateElement error:error];

    if ([templateElement isKindOfClass:[HL7Organizer class]]) {
        [plan when:HL7ElementOrganizer
            parseWithBlock:^(ParserContext *context, IGXMLReader *node, BOOL *stop) {
                if ([node hasAttributes]) {
                    [((HL7Organizer *)templateElement) setClassCode:[node attributeWithName:HL7AttributeClassCode]];
                    [((HL7Organizer *)templateElement) setMoodCode:[node attributeWithName:HL7AttributeMoodCode]];
                }
            }];
    }
    return plan;
}
@end
