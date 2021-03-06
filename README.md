# MTZTableViewManager
MTZTableViewManager is a powerful framework that allows you to create table views in a descriptive way, by specifying rows and sections without having to bother with indexes. It also provides a set of tools for creating forms and handling their input, applying masks, performing validations and converting to and from complex objects.

![MTZTableViewManager](https://github.com/mtzaquia/MTZTableViewManager/raw/assets/example.gif)

# Installation

## Manual
- Make sure to pick the right tag (`1.2.0` at the moment).
- Drop the file `MTZTableViewManager.xcodeproj` inside your Xcode project. 
- Make sure your submodules are up-to-date.
- Drag the `MTZTableViewManager.framework` (under `Products`) to your target `Linked Frameworks and Libraries` area.

## CocoaPods
You can also declare the following on your `Podfile`:
```ruby
pod 'MTZTableViewManager', '~> 1.2.0'
```
*Note that this will also add `MTZExpirationDatePicker` as a pod dependency.*

# Sample Usage

## Rows, sections and data
Getting started is fairly simple. Just declare a strongly-held `MTZTableManager` somewhere:
```objc
@property (nonatomic) MTZTableManager *tableManager;
```
Then declare your rows, sections and finally the data. Using a custom `UITableViewCell` subclass is recommended.
```objc
MTZTableRow *row = [[MTZTableRow alloc] initWithClass:[MyCustomCell class] 
					       action:^(NSIndexPath * _Nonnull indexPath, id<MTZModel> model) {
					           NSLog(@"Tap!");
	                                       }];
MTZTableSection *section = [[MTZTableSection alloc] initWithTableRows:@[row]];
MTZTableData *data = [[MTZTableData alloc] initWithTableSections:@[section]];
self.tableManager = [[MTZTableManager alloc] initWithTableView:self.tableView tableData:data];
```
And you're good to go! Please note you cannot be the `tableView`s delegate or data source while using `MTZTableManager`. 

* You can also provide a regular and/or expanded height to a row, and it will toggle between them upon selection.
* You can also hide rows or sections dinamically, just set the `hidden` property.
* You can instantiate cells using `nib`s as well. Likewise you can provide custom headers and footers classes for every section.

### Models
To declare an object as a possible model, just conform it to `MTZModel`:
```objc
@interface MyCustomCellModel: NSObject <MTZModel>
@property (nonatomic) NSString *text;
@end
```

Cells can then be configured to display information. Simply conform the cell you want to `MTZModelDisplaying` and implement the required method:
```objc
@interface MyCustomCell: UITableViewCell <MTZModelDisplaying>
@end

@implementation MyCustomCell
- (void)configureWithModel:(id<MTZModel>)model {
    self.textLabel.text = ((MyCustomCellModel *)model).text;
}
@end
```

* Sections can also have models, and they're provided to custom headers/footers, if any, as long as their classes also conform to `MTZModelDisplaying`.

## Forms
### Form objects
Form objects are objects that can be manipulated by a form generated by `MTZTableViewManager`. Ideally, you want to make all of its properties read-only to avoid external mutation, since the form elements will modify the values directly via `KVO`. If you're using Swift. Don't forget the `dynamic` keyword for that! Make sure the object conforms to `MTZFormObject`:
```objc
@interface MyCustomFormObject: NSObject <MTZFormObject>
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSDate *date;
@property (nonatomic, readonly) MyCustomUser *user;
@end
```

### Form rows
For a cell to be compatible with a form, it needs to conform with `MTZFormEditing` and implement the required method:
```objc
@interface MyCustomTextFieldCell: UITableViewCell <MTZFormEditing>
@property (nonatomic) UITextField *textField;
@end

@implementation MyCustomTextFieldCell
// ...
- (UIControl<MTZFormField> *)fieldForFormObject {
    return self.textField;
}
@end
```

* Note that the form fields must conform to `MTZFormField`. The framework already provides a default implementation for `UITextField`, `UITextView`, `UISwitch` and `UIStepper`.

### Form fields input accessory view
Form fields automatically provide you with `inputAccessoryView` for jumping between other fields within the same section. To localise the buttons on the framework-provided input accessory view, simply add the following entries to your  `Localizable.strings`, replacing the translations to whatever fits your needs:
```objc
"mtz_prev" = "Prev";
"mtz_next" = "Next";
"mtz_done" = "Done";
```

* If the keyboard provides a return button, the "Done" button is ommitted.

### Form date rows
Dates are a special topic. Due to that, if you want to interact with a `NSDate` key path, use `MTZTableFormDateRow` instead:
```objc
MTZTableFormDateRow *dateRow = [[MTZTableFormDateRow alloc] initWithClass:[MyCustomTextFieldCell class] 
                                                               formObject:self.formObject 
							          keyPath:CLASSKEY(MyCustomFormObject, date)];
dateRow.minimumDate = [NSDate date];
dateRow.maximumDate = [[NSDate date] dateByAddingTimeInterval:60*60*24*15];
dateRow.datePickerMode = MTZDatePickerModeDateAndTime;
```

* `MTZTableFormDateRow` must also use `UITextField` as a form field, as we replace the `inputView` with the adequate picker. 
* You can also use `MTZDatePickerModeExpirationDate` as a picker mode, and it will use the `MTZExpirationDatePicker` as `inputView`.

### Form options
If you want to provide a set of options, do so by conforming the type of object you want to provide as an option to `MTZFormOption`:
```objc
@interface MyCustomUser: NSObject <MTZFormOption>
@property (nonatomic) NSInteger ID;
@property (nonatomic) NSString *email;
- (instancetype)initWithID:(NSInteger)ID email:(NSString *)email;
@end

@implementation MyCustomUser
// ...
- (NSString *)optionDescription {
    return self.email;
}

- (BOOL)isEqual:(MyCustomUser *)object {
    return self.ID == object.ID;
}
@end
```

Then set the `availableOptions` property on the `MTZTableFormOptionRow`:
```objc
NSArray *allUsers = @[[[MyCustomUser alloc] initWithID:1 email:@"a@b.com"],
                      [[MyCustomUser alloc] initWithID:2 email:@"b@c.com"],
                      [[MyCustomUser alloc] initWithID:3 email:@"c@d.com"]];
MTZTableFormOptionRow *userRow = [[MTZTableFormOptionRow alloc] initWithClass:[MyCustomTextFieldCell class] 
                                                                   formObject:self.formObject 
								      keyPath:CLASSKEY(MyCustomFormObject, user)];
userRow.availableOptions = allUsers;
```

* If you set available options, you must also use `UITextField` as a form field, as we replace the `inputView` with the adequate picker.
* Make sure you provide a valid implementation of `isEqual:` to your `MTZFormOption` object.

### Converters
TBA

### Validators
TBA

### Maskers
Maskers allow `UITextFields` to have their input:
* limited to an specific amount of characters;
* limited to an specific set of characters;
* appended with placeholders in specific indexes (i.e.: Dots every 4 digits: 1234.1234.1234.1234).

Simply subclass `MTZTextFieldMasker` and implement the desired methods:
```objc
@interface MyMasker : MTZTextFieldMasker
@end

// .m

@implementation MyMasker

- (NSCharacterSet *)allowedCharacterSet {
    return [NSCharacterSet decimalDigitCharacterSet]; // only digits
}

- (NSInteger)maximumInputLength {
    return 21; // i.e.: card number + spaces
}

- (NSString *)stringToAppendAtIndex:(NSInteger)index 
                           ofString:(NSString *)currentString {
    if (index % 4 == 0) {
        return @" "; // add space every 4 digits.
    }

    return nil;
}

@end
```

Then set the `masker` property to a `MTZTableFormRow` that uses an `UITextField`:
```objc
MTZTableFormRow *cardNumberRow = [[MTZTableFormRow alloc] initWithNib:myTextFieldCellNib 
                                                           formObject:myFormObject 
							      keyPath:CLASSKEY(MyFormObjectClass, cardNumber)];
cardNumberRow.masker = [MyMasker new];
```

* All masker methods are optional.
* As mentioned, this requires an `UITextField` to work properly.

## Commands
TBA

# License
`MTZTableViewManager` is released under the MIT license. See LICENSE for details.
