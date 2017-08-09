//
// MTZFormField.h
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

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

/**
 This protocol describes a field compatible with form objects.
 */
@protocol MTZFormField <NSObject>

/// The field to be retrieved/set on the field.
@property (nonatomic) id fieldValue;

@optional
/**
 This method defines the field as valid or invalid based on form object validators.

 @param invalid a flag indicating whether the field should be in a valid state or not.
 */
- (void)setInvalid:(BOOL)invalid;
@end

NS_ASSUME_NONNULL_END

@interface UITextField (MTZFormField) <MTZFormField>
@end

@interface UITextView (MTZFormField) <MTZFormField>
@end

@interface UISwitch (MTZFormField) <MTZFormField>
@end

@interface UIStepper (MTZFormField) <MTZFormField>
@end
