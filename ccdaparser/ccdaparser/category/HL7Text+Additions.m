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


#import "HL7Text+Additions.h"
#import "IGXMLReader.h"
#import "GTMNSString+HTML.h"

@implementation HL7Text (Additions)

- (NSString *)styleCodeToStyle:(NSString *)styleCode
{
    NSDictionary *mapping = @{ @"Bold" : @{@"font-weight" : @"bold"}, @"Italics" : @{@"font-style" : @"italic"}, @"Underline" : @{@"text-decoration" : @"underline"}, @"Emphasis" : @{@"font-variant" : @"small-caps"}, @"Lrule" : @{@"border-left" : @"1px"}, @"Rrule" : @{@"border-right" : @"1px"}, @"Toprule" : @{@"border-top" : @"1px"}, @"Botrule" : @{@"border-bottom" : @"1px"}, @"Circle" : @{@"list-style-type" : @"circle"}, @"Square" : @{@"list-style-type" : @"square"}, @"Disc" : @{@"list-style-type" : @"disc"}, @"Arabic" : @{@"list-style-type" : @"decimal"}, @"LittleRoman" : @{@"list-style-type" : @"lower-roman"}, @"BigRoman" : @{@"list-style-type" : @"upper-roman"}, @"LittleAlpha" : @{@"list-style-type" : @"lower-alpha"}, @"BigAlpha" : @{@"list-style-type" : @"upper-alpha "} };

    NSMutableDictionary *resultMapping = [[NSMutableDictionary alloc] initWithCapacity:2];

    for (NSString *component in [styleCode componentsSeparatedByString:@" "]) {

        NSDictionary *map = [mapping objectForKey:component];
        if (map != nil) {
            [map enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL *_Nonnull stop) {
                if ([resultMapping objectForKey:key] == nil) {
                    [resultMapping setObject:[[NSMutableArray alloc] initWithCapacity:2] forKey:key];
                    [[resultMapping objectForKey:key] addObject:obj];
                } else {
                    [[resultMapping objectForKey:key] addObject:obj];
                }
            }];
        }
    }
    if (![resultMapping count]) {
        return nil;
    }
    // style="font-weight:bold; font-style:italic"
    NSMutableString *result = [[NSMutableString alloc] initWithCapacity:10];
    [result appendString:@"style=\""];
    __block NSUInteger stylesToBeAdded = [resultMapping count];
    [resultMapping enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL *_Nonnull stop) {

        [result appendFormat:@"%@:", key];
        NSUInteger itemsToBeAdded = [obj count];
        for (NSString *style in obj) {
            [result appendString:style];
            if (--itemsToBeAdded > 0) {
                [result appendString:@","];
            }
        }

        if (--stylesToBeAdded > 0) {
            [result appendString:@";"];
        }
    }];
    [result appendString:@"\""];
    return [result copy];
}

- (NSString *)toHtml
{
    NSDictionary *mapping = @{ @"paragraph" : @"p", @"content" : @"span", @"list" : @"ol", @"item" : @"li", @"linkHTML" : @"a", @"renderMultimedia" : @"img" };

    IGXMLReader *reader = [[IGXMLReader alloc] initWithXMLString:[NSString stringWithFormat:@"<p>%@</p>", [self innerXML]]];
    NSMutableString *result = [[NSMutableString alloc] initWithCapacity:[[self innerXML] length]];
    if ([[reader errors] count]) {
        return nil;
    }
    for (IGXMLReader *node in reader) {
        if ([node type] == IGXMLReaderNodeTypeElement) {
            NSString *replacedBy = [mapping objectForKey:[node name]];

            if (![node hasAttributes]) {
                if (replacedBy != nil) {
                    [result appendFormat:@"<%@>", replacedBy];
                } else {
                    [result appendFormat:@"<%@>", [node name]];
                }
            } else {
                if (replacedBy != nil) {
                    [result appendFormat:@"<%@", replacedBy];
                } else {
                    [result appendFormat:@"<%@", [node name]];
                }
                [[node attributes] enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL *_Nonnull stop) {
                    if ([key isEqualToString:@"styleCode"]) {
                        NSString *styleCode = [self styleCodeToStyle:obj];
                        if (styleCode != nil) {
                            [result appendFormat:@" %@", styleCode];
                        }
                    } else {
                        [result appendFormat:@" %@=\"%@\"", key, [obj gtm_stringByEscapingForHTML]];
                    }
                }];
                [result appendString:@">"];
            }

            if ([[node value] length]) {
                [result appendString:[node value]];
            }
        } else if ([node type] == IGXMLReaderNodeTypeText) {
            [result appendString:[node value]];
        } else if ([node type] == IGXMLReaderNodeTypeEndElement) {
            NSString *replacedBy = [mapping objectForKey:[node name]];

            if (replacedBy != nil) {
                [result appendFormat:@"</%@>", replacedBy];
            } else {
                [result appendFormat:@"</%@>", [node name]];
            }
        }
    }
    return [result copy];
}
@end
