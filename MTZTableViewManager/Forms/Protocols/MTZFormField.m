//
// MTZFormField.m
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

#import <objc/runtime.h>
#import "MTZFormField.h"

static void *UITextFieldOriginalTextColorKey = &UITextFieldOriginalTextColorKey;

@interface UITextField ()
@property (nonatomic, strong) UIColor *originalTextColor;
@end

@implementation UITextField (MTZFormField)
- (void)setFieldValue:(NSString *)fieldValue {
    self.text = fieldValue;
}

- (NSString *)fieldValue {
    return self.text;
}

- (void)setInvalid:(BOOL)invalid {
    if (!self.originalTextColor) {
        self.originalTextColor = self.textColor;
    }
    
    self.textColor = invalid ? [UIColor redColor] : self.originalTextColor;
}

- (UIColor *)originalTextColor {
    return objc_getAssociatedObject(self, UITextFieldOriginalTextColorKey);
}

- (void)setOriginalTextColor:(UIColor *)originalTextColor {
    objc_setAssociatedObject(self, UITextFieldOriginalTextColorKey, originalTextColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end

static void *UITextViewOriginalTextColorKey = &UITextViewOriginalTextColorKey;

@interface UITextView ()
@property (nonatomic, strong) UIColor *originalTextColor;
@end

@implementation UITextView (MTZFormField)
- (void)setFieldValue:(NSString *)fieldValue {
    self.text = fieldValue;
}

- (NSString *)fieldValue {
    return self.text;
}

- (void)setInvalid:(BOOL)invalid {
    if (!self.originalTextColor) {
        self.originalTextColor = self.textColor;
    }

    self.textColor = invalid ? [UIColor redColor] : self.originalTextColor;
}

- (UIColor *)originalTextColor {
    return objc_getAssociatedObject(self, UITextViewOriginalTextColorKey);
}

- (void)setOriginalTextColor:(UIColor *)originalTextColor {
    objc_setAssociatedObject(self, UITextViewOriginalTextColorKey, originalTextColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end

@implementation UISwitch (MTZFormField)
- (void)setFieldValue:(NSNumber *)fieldValue {
    self.on = [fieldValue boolValue];
}

- (NSNumber *)fieldValue {
    return @(self.isOn);
}
@end

@implementation UIStepper (MTZFormField)
- (void)setFieldValue:(id)fieldValue {
    self.value = [fieldValue doubleValue];
}
- (id)fieldValue {
    return @(self.value);
}
@end
