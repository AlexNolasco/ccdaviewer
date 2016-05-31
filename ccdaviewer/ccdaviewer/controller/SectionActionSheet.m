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

#import "SectionActionSheet.h"
#import <ccdaparser/ccdaparser.h>

@implementation SectionActionSheet
- (void)presentActionSheetUsingSectionsInArray:(HL7SectionInfoArray *)sections inView:(UIViewController *)view handler:(void (^)(NSUInteger))block;
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *button0 = [UIAlertAction actionWithTitle:NSLocalizedString(@"SectionsActionSheet.Cancel", nil)
                                                      style:UIAlertActionStyleCancel
                                                    handler:^(UIAlertAction *action){
                                                        //  UIAlertController will automatically dismiss the view
                                                    }];

    if ([sections count] > 1) {
        for (NSUInteger i = 0; i < [sections count]; i += 1) {
            HL7SectionInfo *info = [sections objectAtIndex:i];

            UIAlertAction *sectionAction = [UIAlertAction actionWithTitle:[info name]
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction *action) {
                                                                      NSUInteger actionIndex = [alert.actions indexOfObject:action];
                                                                      block(actionIndex);
                                                                  }];
            [alert addAction:sectionAction];
        }
    }
    [alert addAction:button0];
    [view presentViewController:alert animated:YES completion:nil];
}

@end
