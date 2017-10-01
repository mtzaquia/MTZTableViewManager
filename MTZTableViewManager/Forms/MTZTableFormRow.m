//
// MTZTableFormRow.m
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

#import "MTZTableFormRow+Private.h"
#import "MTZTextFieldMasker+Private.h"
#import "MTZFormValidator.h"
#import "MTZFormOption.h"
#import "UIToolbar+MTZFormInputAccessoryView.h"

NSErrorUserInfoKey const MTZTableFormRowKey = @"MTZTableFormRowKey";
NSErrorUserInfoKey const MTZFormFieldKey = @"MTZFormFieldKey";

@interface MTZTableFormRow ()
@end

@implementation MTZTableFormRow

- (instancetype)initWithClass:(Class)clazz formObject:(id<MTZFormObject>)formObject keyPath:(MTZKeyPath *)keyPath {
    return [self initWithClass:clazz formObject:formObject keyPath:keyPath model:nil];
}

- (instancetype)initWithNib:(UINib *)nib formObject:(id<MTZFormObject>)formObject keyPath:(MTZKeyPath *)keyPath {
    return [self initWithNib:nib formObject:formObject keyPath:keyPath model:nil];
}

- (instancetype)initWithClass:(Class)clazz formObject:(NSObject<MTZFormObject> *)formObject keyPath:(MTZKeyPath *)keyPath model:(id<MTZModel>)model {
    self = [super initWithClass:clazz model:model action:nil];
    if (self) {
        _formObject = formObject;
        _keyPath = keyPath;
        [self checkDataTypes];
    }

    return self;
}

- (instancetype)initWithNib:(UINib *)nib formObject:(NSObject<MTZFormObject> *)formObject keyPath:(MTZKeyPath *)keyPath model:(id<MTZModel>)model {
    self = [super initWithNib:nib model:model action:nil];
    if (self) {
        _formObject = formObject;
        _keyPath = keyPath;
        [self checkDataTypes];
    }

    return self;
}

- (void)updateFormObject {
    id formObjectTypedValue = [self finalFormValue];
    if (!formObjectTypedValue) {
        NSAssert(NO, @"Obtained nil value for form object from %@", self.converter);
    }

    [self.formObject setValue:formObjectTypedValue forKeyPath:self.keyPath];
}

- (void)updateFormFieldWithCustomValue:(id)customValue {
    id formFieldTypedValue = [self finalFieldValueWithCustomValue:customValue];
    if (formFieldTypedValue) {
        Class finalClass = [formFieldTypedValue class];
        while ([NSStringFromClass(finalClass) containsString:@"Swift"] ||
               [NSStringFromClass(finalClass) containsString:@"NSTaggedPointerString"]) {
            finalClass = [finalClass superclass];
        }

        NSAssert(!self.formField || [[self.formField.fieldValue class] isSubclassOfClass:finalClass] ||
                 [finalClass isSubclassOfClass:[self.formField.fieldValue superclass]], @"Type '%@' for form field with type '%@' is incompatible without a converter.", [formFieldTypedValue class], [self.formField.fieldValue class]);
    }

    self.formField.fieldValue = formFieldTypedValue;
    if (self.masker) {
        [self.masker textFieldDidChange:self.formField];
    }
}

#pragma mark - Properties
- (NSObject<MTZFormObject> *)formObject {
    NSAssert(_formObject, @"Form objects are weakly held by MTZTableFormRow, so they must be strongly held by something else.");
    return _formObject;
}

- (void)setFormField:(__kindof UIControl<MTZFormField> *)formField {
    _formField = formField;
    [_formField removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
    [_formField addTarget:self action:@selector(updateFormObject) forControlEvents:UIControlEventEditingChanged];
    [_formField addTarget:self action:@selector(updateFormObject) forControlEvents:UIControlEventValueChanged];

    if (self.masker) {
        UITextField *textField = (UITextField *)_formField;
        NSAssert([textField isKindOfClass:[UITextField class]], @"Maskers can only be applied to UITextField's.");
        [textField addTarget:self.masker action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }

    if ([formField isKindOfClass:[UITextField class]] || [formField isKindOfClass:[UITextView class]]) {
        ((UITextField *)formField).delegate = self;
        ((UITextField *)formField).inputView = nil;
        ((UITextField *)formField).inputAccessoryView = [UIToolbar inputAccessoryViewForControl:formField  delegate:self.section];
    }

    [self updateFormFieldWithCustomValue:nil];
}

#pragma mark - MTZFormValidatable
- (BOOL)validate:(NSError **)error {
    for (MTZFormValidator *validator in self.validators) {
        BOOL valid = [validator validate:[self finalFormValue] error:error];
        if (!valid) {
            NSMutableDictionary *mutableUserInfo = [(*error).userInfo mutableCopy];
            mutableUserInfo[MTZTableFormRowKey] = self;
            mutableUserInfo[MTZFormFieldKey] = self.formField;
            mutableUserInfo[NSLocalizedDescriptionKey] = validator.errorMessage;
            (*error) = [NSError errorWithDomain:(*error).domain code:(*error).code userInfo:mutableUserInfo];
            return NO;
        }
    }

    return YES;
}

#pragma mark - MTZReloadable
- (void)reload {
    self.formField = self.formField;
    [super reload];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([self.formField respondsToSelector:@selector(setInvalid:)]) {
        [self.formField setInvalid:NO];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.formField respondsToSelector:@selector(setInvalid:)]) {
        if (textField.text.length) {
            NSError *error;
            [self.formField setInvalid:![self validate:&error]];
        } else {
            [self.formField setInvalid:NO];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    self.masker.previousTextFieldContent = textField.text;
    self.masker.previousSelection = textField.selectedTextRange;
    self.masker.textWasPasted = string.length > 1;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self textFieldDidBeginEditing:(UITextField *)textView];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self textFieldDidEndEditing:(UITextField *)textView];
}

#pragma mark - Private
- (id)finalFieldValueWithCustomValue:(id)customValue {
    id inputValue = customValue ?: [self.formObject valueForKeyPath:self.keyPath];
    if (self.converter) {
        return [self.converter toFieldValue:inputValue];
    }

    return inputValue;
}

- (id)finalFormValue {
    if (self.converter) {
        return [self.converter fromFieldValue:self.formField.fieldValue];
    }
    
    return self.formField.fieldValue;
}

- (void)checkDataTypes {
    if ([self isMemberOfClass:[MTZTableFormRow class]]) {
        __unused BOOL isDate = MTZFormObjectKeyPathIsOfClass(self.formObject, (MTZKeyPath *)self.keyPath, [NSDate class]);
        NSAssert(!isDate, @"MTZTableFormRow is not compatible with NSDate (keypath '%@'). Please use MTZTableFormDateRow instead.", self.keyPath);
    }
}

@end

