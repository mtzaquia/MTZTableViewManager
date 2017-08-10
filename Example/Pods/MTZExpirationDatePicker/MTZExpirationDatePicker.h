//
// MTZExpirationDatePicker.h
// MTZExpirationDatePicker
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

@class MTZExpirationDatePicker;

/**
 A protocol that describes an object capable of receiving events related to the date being changed on a given @c MTZExpirationDatePicker.
 */
@protocol MTZExpirationDatePickerDelegate <NSObject>
/**
 Triggered when the date on an @c MTZExpirationDatePicker has changed.

 @param datePicker The instance of @c MTZExpirationDatePicker that was changed.
 */
- (void)datePickerDidChangeDate:(MTZExpirationDatePicker *)datePicker;
@end

/**
 A picker that allows the selection of a month and a year. Suitable for card expiration dates.
 */
@interface MTZExpirationDatePicker : UIPickerView

@property(nullable,nonatomic,weak) id<UIPickerViewDataSource> dataSource NS_UNAVAILABLE;
@property(nullable,nonatomic,weak) id<UIPickerViewDelegate> delegate NS_UNAVAILABLE;

/// The object that will receive events related to the date being changed on the picker.
@property (nonatomic, weak) id<MTZExpirationDatePickerDelegate> datePickerDelegate;

/// The mininum date that can be selected on the picker. Must be earlier than @c maximumDate.
@property (nonatomic, nullable) NSDate *minimumDate;

/// The maximum date that can be selected on the picker. Must be later than @c minimumDate.
@property (nonatomic, nullable) NSDate *maximumDate;

/// The current date selected on the picker.
@property (nonatomic, readonly) NSDate *date;

/// A flag indicating whether the component should display a slash on the center or not. Defauls to @c YES.
@property (nonatomic, assign) BOOL showsSeparator;

/**
 Sets the date on the picker. If the date is later than @c maximumDate or earlier than @c minimumDate, it is adjusted accordingly.

 @param date The date to be set on the picker.
 @param animated A flag indicating whether the change should happen with animation or not.
 */
- (void)setDate:(NSDate *)date animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
