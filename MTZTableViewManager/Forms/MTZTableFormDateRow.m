//
// MTZTableFormDateRow.m
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

#import "MTZTableFormDateRow.h"

#import "MTZExpirationDatePicker.h"
#import "MTZTableFormRow+Private.h"
#import "UIToolbar+MTZFormInputAccessoryView.h"

@interface MTZTableFormDateRow () <MTZExpirationDatePickerDelegate>
@property (nonatomic) UIDatePicker *datePicker;
@property (nonatomic) MTZExpirationDatePicker *customDatePicker;
@end

@implementation MTZTableFormDateRow

@dynamic masker;
@dynamic validators;
@dynamic availableOptions;

- (instancetype)initWithNib:(UINib *)nib formObject:(id<MTZFormObject>)formObject keyPath:(MTZKeyPath *)keyPath model:(id<MTZModel>)model {
    self = [super initWithNib:nib formObject:formObject keyPath:keyPath model:model];
    if (self) {
        [self checkDataTypes];
    }

    return self;
}

- (instancetype)initWithClass:(Class)clazz formObject:(id<MTZFormObject>)formObject keyPath:(MTZKeyPath *)keyPath model:(id<MTZModel>)model {
    self = [super initWithClass:clazz formObject:formObject keyPath:keyPath model:model];
    if (self) {
        [self checkDataTypes];
    }

    return self;
}

- (void)updateFormObject {
    id formObjectTypedValue = [self finalFormValue];
    [self.formObject setValue:formObjectTypedValue forKeyPath:self.keyPath];
}

- (void)setFormField:(__kindof UIControl<MTZFormField> *)formField {
    [super setFormField:formField];
    NSAssert(!formField || [formField isKindOfClass:[UITextField class]], @"MTZTableFormDateRow can only be applied to UITextField rows.");

    if (self.datePickerMode != MTZDatePickerModeExpirationDate) {
        self.datePicker = [[UIDatePicker alloc] init];
        self.datePicker.datePickerMode = (UIDatePickerMode)self.datePickerMode;
        self.datePicker.minimumDate = self.minimumDate;
        self.datePicker.maximumDate = self.maximumDate;
        [self.datePicker addTarget:self action:@selector(datePickerDidChangeDate:) forControlEvents:UIControlEventValueChanged];
        [formField setInputView:self.datePicker];
    } else {
        self.customDatePicker = [[MTZExpirationDatePicker alloc] init];
        self.customDatePicker.datePickerDelegate = self;
        if (self.minimumDate) {
            self.customDatePicker.minimumDate = self.minimumDate;
        }

        if (self.maximumDate) {
            self.customDatePicker.maximumDate = self.maximumDate;
        }
        [formField setInputView:self.customDatePicker];
    }

    ((UITextField *)formField).inputAccessoryView = [UIToolbar inputAccessoryViewForControl:formField  delegate:self.section];
}

#pragma mark - Properties
- (void)setMinimumDate:(NSDate *)minimumDate {
    _minimumDate = minimumDate;
    if (self.maximumDate) {
        NSAssert(_minimumDate.timeIntervalSince1970 < self.maximumDate.timeIntervalSince1970, @"The minimum date cannot be equal to or later than maximum date.");
    }
}

- (void)setMaximumDate:(NSDate *)maximumDate {
    _maximumDate = maximumDate;
    if (self.minimumDate) {
        NSAssert(_maximumDate.timeIntervalSince1970 > self.minimumDate.timeIntervalSince1970, @"The maximum date cannot be equal to or earlier than minimum date.");
    }
}

#pragma mark - MTZDatePickerDelegate
- (void)datePickerDidChangeDate:(MTZExpirationDatePicker *)datePicker {
    [self updateFormFieldWithCustomValue:datePicker.date];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (!textField.text.length) {
        [self updateFormFieldWithCustomValue:(self.datePicker.date ?: self.customDatePicker.date)];
    } else {
        [self.datePicker setDate:[self finalFormValue]];
        [self.customDatePicker setDate:[self finalFormValue] animated:NO];
    }

    [super textFieldDidBeginEditing:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self updateFormObject];
    [super textFieldDidEndEditing:textField];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return NO;
}

#pragma mark - Private
- (void)checkDataTypes {
    if ([self isMemberOfClass:[MTZTableFormDateRow class]]) {
        __unused BOOL isDate = MTZFormObjectKeyPathIsOfClass(self.formObject, (MTZKeyPath *)self.keyPath, [NSDate class]);
        NSAssert(isDate, @"MTZTableFormDateRow is only compatible with NSDate (keypath '%@').", self.keyPath);
    }
}

- (id)finalFieldValueWithCustomValue:(id)customValue {
    id inputValue = customValue ?: [self.formObject valueForKeyPath:self.keyPath];
    if (self.converter) {
        return [self.converter toFieldValue:inputValue];
    }

    [self updateFormatter];
    return [MTZSharedDateFormatter() stringFromDate:inputValue];
}

- (id)finalFormValue {
    if (self.converter) {
        return [self.converter fromFieldValue:self.formField.fieldValue];
    }

    [self updateFormatter];
    return [MTZSharedDateFormatter() dateFromString:self.formField.fieldValue];
}

- (void)updateFormatter {
    if (self.datePickerMode == MTZDatePickerModeExpirationDate) {
        MTZSharedDateFormatter().dateStyle =  NSDateFormatterNoStyle;
        MTZSharedDateFormatter().dateFormat =  @"MM/yy";
    } else {
        MTZSharedDateFormatter().dateStyle =  NSDateFormatterLongStyle;
        MTZSharedDateFormatter().dateFormat = nil;
    }
}

@end
