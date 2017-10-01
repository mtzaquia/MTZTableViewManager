//
// MTZTableFormOptionRow.m
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

#import "MTZTableFormOptionRow.h"

#import "MTZTableFormRow+Private.h"
#import "UIToolbar+MTZFormInputAccessoryView.h"

@interface MTZTableFormOptionRow () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic) UIPickerView *pickerView;
@property (nonatomic) id<MTZFormOption> selectedOption;
@property (nonatomic) CGFloat calculatedPickerComponentHeight;
@end

@implementation MTZTableFormOptionRow

@dynamic converter;
@dynamic masker;

- (void)setFormField:(__kindof UIControl<MTZFormField> *)formField {
    [super setFormField:formField];
    NSAssert(!formField || [formField isKindOfClass:[UITextField class]], @"MTZTableFormOptionRow can only be applied to UITextField rows.");

    self.selectedOption = [self.formObject valueForKeyPath:self.keyPath];
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.delegate = self;
    [formField setInputView:self.pickerView];
    [self updateFormFieldWithCustomValue:self.selectedOption];

    ((UITextField *)formField).inputAccessoryView = [UIToolbar inputAccessoryViewForControl:formField  delegate:self.section];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSAssert(self.availableOptions.count, @"MTZTableFormOptionRow must have at least one available option!");
    if (!self.selectedOption) {
        self.selectedOption = self.availableOptions.firstObject;
        [self updateFormFieldWithCustomValue:self.selectedOption];
    } else if (self.selectedOption) {
        NSInteger index = [self.availableOptions indexOfObject:self.selectedOption];
        NSAssert(index != NSNotFound, @"MTZFormOption objects must provide a valid isEqual: implementation.");
        [self.pickerView selectRow:index inComponent:0 animated:NO];
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
    self.selectedOption = self.availableOptions[row];
    [self updateFormFieldWithCustomValue:self.selectedOption];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    id<MTZFormOption> option = self.availableOptions[row];
    return [option optionViewReusingView:view];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    if (self.calculatedPickerComponentHeight > 0) {
        return self.calculatedPickerComponentHeight;
    }

    UIView *sampleView = [self pickerView:pickerView viewForRow:0 forComponent:component reusingView:nil];
    self.calculatedPickerComponentHeight = [sampleView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return self.calculatedPickerComponentHeight;
}

#pragma mark - Private
- (void)updateFormObject {
    id formObjectTypedValue = [self finalFormValue];
    [self.formObject setValue:formObjectTypedValue forKeyPath:self.keyPath];
}

- (id)finalFieldValueWithCustomValue:(id)customValue {
    id inputValue = customValue ?: [self.formObject valueForKeyPath:self.keyPath];
    return ((id<MTZFormOption>)inputValue).optionDescription;
}

- (id)finalFormValue {
    return self.selectedOption;
}

#pragma mark - Runtime
- (BOOL)respondsToSelector:(SEL)aSelector {
    if (aSelector == @selector(pickerView:viewForRow:forComponent:reusingView:) ||
        aSelector == @selector(pickerView:rowHeightForComponent:)) {
        return [[self.availableOptions firstObject] respondsToSelector:@selector(optionViewReusingView:)];
    }

    return [super respondsToSelector:aSelector];
}

@end
