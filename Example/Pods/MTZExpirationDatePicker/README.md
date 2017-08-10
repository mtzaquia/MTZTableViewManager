# MTZExpirationDatePicker
The `MTZExpirationDatePicker` is a simple component that subclass `UIPickerView` and provides an easy and drop-in way to use it with your project. It also allows the setup of a minimum and maximum date.

![MTZExpirationDatePicker](https://github.com/mtzaquia/MTZExpirationDatePicker/raw/assets/mtzexpirationdatepicker-pic-1.png)

# Installation
Simply drop the files `MTZExpirationDatePicker.h` and `MTZExpirationDatePicker.m` to your project and import wherever needed.

# Sample Usage
Using the picker is relatively straight forward. Most commonly as an `inputView` as such:
```objc
self.expirationDatePicker = [[MTZExpirationDatePicker alloc] init];
self.expirationDatePicker.datePickerDelegate = self; // Needed as UIPickerView doesn't inherited from UIControl.
if (minimumDate) {
    self.expirationDatePicker.minimumDate = minimumDate;
}

if (maximumDate) {
    self.expirationDatePicker.maximumDate = maximumDate;
}

[self.textField setInputView:self.expirationDatePicker];
```

Then on the delegate just implement the method to know whenever the date has been changed:
```objc
#pragma mark - MTZDatePickerDelegate
- (void)datePickerDidChangeDate:(MTZExpirationDatePicker *)datePicker {
    self.textField.text = [self.dateFormatter stringFromDate:datePicker.date];
}
```

or just access the property `date` whenever needed.
```objc
self.textField.text = [self.dateFormatter stringFromDate:self.expirationDatePicker.date];
```

You can also set a date manually, and it will respect the minimum and maximum dates, if any:
```objc
[self.expirationDatePicker setDate:[NSDate date] animated:YES];
```

If you don't fancy the separator, just disable it:
```objc
self.expirationDatePicker.showsSeparator = NO;
```

That's pretty much it. Enjoy! :)

# License
`MTZExpirationDatePicker` is released under the MIT license. See LICENSE for details.
