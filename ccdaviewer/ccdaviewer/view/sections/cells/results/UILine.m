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

#import "UILine.h"

@implementation UILine

//! http://stackoverflow.com/a/26525466/65694
- (void)awakeFromNib
{
    const CGFloat sortaPixel = 1.0f / [UIScreen mainScreen].scale;

    // recall, the following...
    // float sortaPixel = 1.0/self.contentScaleFactor;
    // ...does NOT work when loading from storyboard!

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, sortaPixel)];

    line.userInteractionEnabled = NO;
    line.backgroundColor = self.backgroundColor;
    line.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    [self addSubview:line];

    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
}

@end
