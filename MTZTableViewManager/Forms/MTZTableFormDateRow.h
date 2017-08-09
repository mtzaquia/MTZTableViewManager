//
// MTZTableFormDateRow.h
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

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MTZDatePickerMode) {
    MTZDatePickerModeTime = UIDatePickerModeTime,
    MTZDatePickerModeDate = UIDatePickerModeDate,
    MTZDatePickerModeDateAndTime = UIDatePickerModeDateAndTime,
    MTZDatePickerModeCountDownTimer = UIDatePickerModeCountDownTimer,
    MTZDatePickerModeExpirationDate = 27 // avoid collision.
};

/**
 A table form row that is only compatible with dates.
 */
@interface MTZTableFormDateRow : MTZTableFormRow

@property (nonatomic, strong, nullable) __kindof MTZTextFieldMasker *masker NS_UNAVAILABLE;
@property (nonatomic, strong, nullable) NSArray<__kindof MTZFormValidator *> *validators NS_UNAVAILABLE;
@property (nonatomic, strong, nullable) NSArray<id<MTZFormOption>> *availableOptions NS_UNAVAILABLE;

/// The date picker mode to be used on the form provided date picker.
@property (nonatomic) MTZDatePickerMode datePickerMode;

/// The mininum date that should be available on the form provided date picker.
@property (nonatomic, nullable) NSDate *minimumDate;

/// The maximum date that should be available on the form provided date picker.
@property (nonatomic, nullable) NSDate *maximumDate;

@end

NS_ASSUME_NONNULL_END
