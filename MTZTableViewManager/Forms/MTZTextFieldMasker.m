//
// MTZTextFieldMasker.m
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

#import "MTZTextFieldMasker+Private.h"
#import "MTZFormField.h"

@interface MTZTextFieldMasker ()
@property (nonatomic, weak) UITextField *currentTextField;
@end

@implementation MTZTextFieldMasker {
    NSInteger _currentCursor;
}

- (NSInteger)maximumInputLength {
    return NSNotFound;
}

- (NSCharacterSet *)allowedCharacterSet {
    return nil;
}

- (nullable NSString *)stringToAppendAtIndex:(NSInteger)index {
    return nil;
}

#pragma mark - Protected
- (void)textFieldDidChange:(UITextField *)textField {
    self.currentTextField = textField;
    _currentCursor = [textField offsetFromPosition:textField.beginningOfDocument
                                     toPosition:textField.selectedTextRange.start];

    if ([self maximumInputLength] != NSNotFound && (textField.text.length > [self maximumInputLength])) {
        [self inputRejected];
        return;
    }

    if ([self allowedCharacterSet]) {
        [self inputAllowedMatchingSet:[self allowedCharacterSet] cursor:&_currentCursor];
    }

    [self inputAppendedWithCursor:&_currentCursor];
    if (self.textWasPasted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UITextPosition *targetPosition = [textField positionFromPosition:textField.beginningOfDocument offset:_currentCursor];
            textField.selectedTextRange = [textField textRangeFromPosition:targetPosition toPosition:targetPosition];
        });
    } else {
        UITextPosition *targetPosition = [textField positionFromPosition:textField.beginningOfDocument offset:_currentCursor];
        textField.selectedTextRange = [textField textRangeFromPosition:targetPosition toPosition:targetPosition];
    }
}

#pragma mark - Private
- (void)inputRejected {
    self.currentTextField.text = self.previousTextFieldContent;
    self.currentTextField.selectedTextRange = self.previousSelection;
}

- (void)inputAllowedMatchingSet:(NSCharacterSet *)characterSet cursor:(NSInteger *)cursor {
    NSUInteger originalCursorPosition = *cursor;
    NSString *originalText = self.currentTextField.text;

    NSMutableString *finalString = [NSMutableString new];
    for (NSUInteger i=0; i<[originalText length]; i++) {
        unichar characterToAdd = [originalText characterAtIndex:i];
        if ([characterSet characterIsMember:characterToAdd]) {
            NSString *stringToAdd = [NSString stringWithCharacters:&characterToAdd
                                                            length:1];
            [finalString appendString:stringToAdd];
        }
        else {
            if (i < originalCursorPosition) {
                (*cursor)--;
            }
        }
    }

    self.currentTextField.text = finalString;
}

- (void)inputAppendedWithCursor:(NSInteger *)cursor {
    NSUInteger originalCursorPosition = *cursor;
    NSString *originalText = self.currentTextField.text;

    NSMutableString *finalString = [NSMutableString new];
    for (NSUInteger i=0; i<[originalText length]; i++) {
        if ([self stringToAppendAtIndex:i]) {
            [finalString appendString:[self stringToAppendAtIndex:i]];
            if (i < originalCursorPosition) {
                (*cursor) += [self stringToAppendAtIndex:i].length;
            }
        }

        unichar characterToAdd = [originalText characterAtIndex:i];
        NSString *stringToAdd = [NSString stringWithCharacters:&characterToAdd length:1];
        [finalString appendString:stringToAdd];
    }

    self.currentTextField.text = finalString;
}

@end
