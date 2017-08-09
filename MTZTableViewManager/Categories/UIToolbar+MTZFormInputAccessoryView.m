//
// UIToolbar+MTZFormInputAccessoryView.m
// MTZTableManager
//
// Copyright (c) 2017 Mauricio Tremea Zaquia (@mtzaquia)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "UIToolbar+MTZFormInputAccessoryView.h"

#import "MTZInputAccessoryViewHandling.h"

@implementation UIToolbar (MTZFormInputAccessoryView)

+ (UIToolbar *)inputAccessoryViewForControl:(UIControl *)control delegate:(id<MTZInputAccessoryViewHandling>)delegate {
    BOOL shouldIncludeDoneButton = NO;
    if (control.inputView != nil) {
        shouldIncludeDoneButton = YES;
    } else if ([control respondsToSelector:@selector(keyboardType)]) {
        switch ([(id)control keyboardType]) {
            case UIKeyboardTypeNumberPad:
            case UIKeyboardTypePhonePad:
            case UIKeyboardTypeDecimalPad:
            case UIKeyboardTypeASCIICapableNumberPad:
                shouldIncludeDoneButton = YES;
            default: break;
        }
    }

    NSString *prevTitle = NSLocalizedStringWithDefaultValue(@"mtz_prev", nil, [NSBundle mainBundle], @"Prev", @"");
    NSString *nextTitle = NSLocalizedStringWithDefaultValue(@"mtz_next", nil, [NSBundle mainBundle], @"Next", @"");
    NSString *doneTitle = NSLocalizedStringWithDefaultValue(@"mtz_done", nil, [NSBundle mainBundle], @"Done", @"");

    NSMutableArray *items = [@[] mutableCopy];
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    UIBarButtonItem *previousButton = [[UIBarButtonItem alloc] initWithTitle:prevTitle style:UIBarButtonItemStylePlain target:delegate action:@selector(inputAccessoryDidTapPrevious:)];
    [items addObject:previousButton];
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:nextTitle style:UIBarButtonItemStylePlain target:delegate action:@selector(inputAccessoryDidTapNext:)];
    [items addObject:nextButton];
    if (shouldIncludeDoneButton) {
        UIBarButtonItem *spacingButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [items addObject:spacingButton];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:doneTitle style:UIBarButtonItemStyleDone target:delegate action:@selector(inputAccessoryDidTapDone:)];
        [items addObject:doneButton];
    }

    toolbar.items = items;
    return toolbar;
}

@end
