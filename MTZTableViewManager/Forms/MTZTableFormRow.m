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
@property (nonatomic) UIPickerView *pickerView;
@property (nonatomic) NSInteger selectedPickerIndex;
@end

@implementation MTZTableFormRow

- (instancetype)initWithClazz:(Class)clazz formObject:(id<MTZFormObject>)formObject keyPath:(MTZKeyPath *)keyPath {
    return [self initWithClazz:clazz formObject:formObject keyPath:keyPath model:nil];
}

- (instancetype)initWithNib:(UINib *)nib formObject:(id<MTZFormObject>)formObject keyPath:(MTZKeyPath *)keyPath {
    return [self initWithNib:nib formObject:formObject keyPath:keyPath model:nil];
}

- (instancetype)initWithClazz:(Class)clazz formObject:(NSObject<MTZFormObject> *)formObject keyPath:(MTZKeyPath *)keyPath model:(id<MTZModel>)model {
    self = [super initWithClazz:clazz model:model action:nil];
    if (self) {
        _formObject = formObject;
        _keyPath = keyPath;
        _selectedPickerIndex = NSNotFound;
        [self checkDataTypes];
    }

    return self;
}

- (instancetype)initWithNib:(UINib *)nib formObject:(NSObject<MTZFormObject> *)formObject keyPath:(MTZKeyPath *)keyPath model:(id<MTZModel>)model {
    self = [super initWithNib:nib model:model action:nil];
    if (self) {
        _formObject = formObject;
        _keyPath = keyPath;
        _selectedPickerIndex = NSNotFound;
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
        Class finalClazz = [formFieldTypedValue class];
        while ([NSStringFromClass(finalClazz) containsString:@"Swift"]) {
            finalClazz = [finalClazz superclass];
        }

        NSAssert([[self.formField.fieldValue class] isSubclassOfClass:finalClazz] ||
                 [finalClazz isSubclassOfClass:[self.formField.fieldValue superclass]], @"Type '%@' for form field with type '%@' is incompatible without a converter.", [formFieldTypedValue class], [self.formField.fieldValue class]);
    }

    self.formField.fieldValue = formFieldTypedValue;
}

#pragma mark - Properties
- (NSObject<MTZFormObject> *)formObject {
    NSAssert(_formObject, @"Form objects are weakly held by MTZTableFormRow, so they must be strongly held by something else.");
    return _formObject;
}

- (void)setFormField:(__kindof UIControl<MTZFormField> *)formField {
    _formField = formField;
    [_formField addTarget:self action:@selector(updateFormObject) forControlEvents:UIControlEventEditingChanged];
    [_formField addTarget:self action:@selector(updateFormObject) forControlEvents:UIControlEventValueChanged];

    if (self.masker) {
        UITextField *textField = (UITextField *)_formField;
        NSAssert([textField isKindOfClass:[UITextField class]], @"Maskers can only be applied to UITextField's.");
        [textField addTarget:self.masker action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }

    if (self.availableOptions.count) {
        NSAssert([formField isKindOfClass:[UITextField class]], @"availableOptions can only be applied to UITextField rows.");
        self.pickerView = [[UIPickerView alloc] init];
        self.pickerView.delegate = self;
        [formField setInputView:self.pickerView];
        if (self.selectedPickerIndex != NSNotFound) {
            [self updateFormFieldWithCustomValue:self.availableOptions[self.selectedPickerIndex]];
        }
    } else {
        [self updateFormFieldWithCustomValue:nil];
    }

    if ([formField isKindOfClass:[UITextField class]] || [formField isKindOfClass:[UITextView class]]) {
        ((UITextField *)formField).delegate = self;
        ((UITextField *)formField).inputAccessoryView = [UIToolbar inputAccessoryViewForControl:formField  delegate:self.section];
    }
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

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.availableOptions.count && !textField.text.length) {
        [self updateFormFieldWithCustomValue:self.availableOptions.firstObject];
        self.selectedPickerIndex = 0;
    } else if (self.availableOptions.count) {
        [self.pickerView selectRow:self.selectedPickerIndex inComponent:0 animated:NO];
    }

    if ([self.formField respondsToSelector:@selector(setInvalid:)]) {
        [self.formField setInvalid:NO];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.availableOptions.count) {
        [self updateFormObject];
    }

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
    if (self.availableOptions.count) {
        return NO;
    }

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

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.availableOptions.count;
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    id<MTZFormOption> option = self.availableOptions[row];
    return option.optionDescription;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    id<MTZFormOption> option = self.availableOptions[row];
    if ([option respondsToSelector:@selector(optionAttributedDescription)]) {
        return option.optionAttributedDescription;
    }

    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedPickerIndex = row;
    [self updateFormFieldWithCustomValue:self.availableOptions[row]];
}

#pragma mark - Private
- (id)finalFieldValueWithCustomValue:(id)customValue {
    id inputValue = customValue ?: [self.formObject valueForKeyPath:self.keyPath];
    if (self.availableOptions.count) {
        return ((id<MTZFormOption>)customValue).optionDescription;
    } else if (self.converter) {
        return [self.converter toFieldValue:inputValue];
    }

    return inputValue;
}

- (id)finalFormValue {
    if (self.availableOptions.count) {
        return self.availableOptions[self.selectedPickerIndex];
    } else if (self.converter) {
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

