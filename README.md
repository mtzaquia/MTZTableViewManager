# MTZTableViewManager
MTZTableViewManager is a powerful framework that allows you to create table views in a descriptive way, by specifying rows and sections without having to bother with indexes. It also provides a set of tools for creating forms and handling their input, applying masks, performing validations and converting to and from complex objects.

# Installation

## Manual
- Drop the file `MTZTableViewManager.xcodeproj` inside your Xcode project. 
- Make sure your submodules are up-to-date.
- Drag the `MTZTableViewManager.framework` (under `Products`) to your target `Linked Frameworks and Libraries` area.

## CocoaPods
You can also declare the following on your `Podfile`:
```ruby
pod 'MTZTableViewManager', '~> 1.0.1'
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
MTZTableRow *row = [[MTZTableRow alloc] initWithClazz:[MyCustomCell class] action:^(NSIndexPath * _Nonnull indexPath, id<MTZModel>  _Nonnull model) {
        NSLog(@"Tap!");
    }];
MTZTableSection *section = [[MTZTableSection alloc] initWithTableRows:@[row]];
MTZTableData *data = [[MTZTableData alloc] initWithTableSections:@[section]];
self.tableManager = [[MTZTableManager alloc] initWithTableView:self.tableManager tableData:data];
```
And you're good to go! Please note you cannot be the `tableView`s delegate or data source while using `MTZTableManager`. 

* You can also provide a regular and/or expanded height to a row, and it will toggle between them upon selection.
* You can also hide rows or sections dinamically, just set the `hidden` property.
* You can instantiate cells using `nib`s as well. Likewise you can provide custom headers and footers classes for every section.

### Models
To declare an object as a possible model, just conform it to `MTZModel`:
```objc
@interface MyCustomCellModel: NSObject<MTZModel>
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

Sections can also have models, and they're provided to custom headers/footers, if any.

## Forms
### Form objects

### Form rows, Form date rows, Form options

### Converters

### Validators

### Masker


# License
`MTZTableViewManager` is released under the MIT license. See LICENSE for details.
