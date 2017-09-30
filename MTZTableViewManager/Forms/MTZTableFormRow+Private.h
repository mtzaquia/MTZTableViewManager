//
// MTZTableFormRow+Private.h
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

#import "MTZTableFormRow.h"
#import "MTZFormConverter.h"
#import "MTZFormField.h"
#import "MTZFormValidatable.h"
#import "MTZTableManagerUtils.h"
#import "MTZTableRow+Private.h"
#import "MTZTableSection+Private.h"
#import "MTZFormObject.h"

NS_ASSUME_NONNULL_BEGIN

/// This key will have the form row at @c NSError @c userInfo that errored out during a validation.
extern NSErrorUserInfoKey const MTZTableFormRowKey;

@interface MTZTableFormRow () <UITextFieldDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, MTZFormValidatable>
@property (nonatomic, weak) NSObject<MTZFormObject> *formObject;
@property (nonatomic, weak) __kindof UIControl<MTZFormField> *formField;
@property (nonatomic) MTZKeyPath *keyPath;

- (id)finalFieldValueWithCustomValue:(id)customValue;
- (id)finalFormValue;
@end

NS_ASSUME_NONNULL_END
