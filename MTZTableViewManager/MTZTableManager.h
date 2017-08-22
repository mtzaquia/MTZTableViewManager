//
// MTZTableManager.h
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

@import UIKit;

#import "MTZCommandRegistering.h"

@class MTZTableData;

NS_ASSUME_NONNULL_BEGIN

@interface MTZTableManager : NSObject <MTZCommandRegistering>

@property (nonatomic) CGFloat estimatedRowHeight;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/**
 This method provides a new instance of @c MTZTableManager.

 @warning  This instance must be held strongly along with the tableView that's going to be used.
 @param tableView The @c UITableView that's going to be managed by this entity.
 @param tableData The @c MTZTableData that's going to populated the managed table view.
 @return A valid instance of @c MTZTableManager.
 */
- (instancetype)initWithTableView:(UITableView *)tableView
                        tableData:(MTZTableData *)tableData;

/**
 This method provides a new instance of @c MTZTableManager compatible with commands.

 @warning  This instance must be held strongly along with the tableView that's going to be used.
 @param tableView The @c UITableView that's going to be managed by this entity.
 @param tableData The @c MTZTableData that's going to populated the managed table view.
 @param context The context to be provided for commands triggered from within the rows.
 @return A valid instance of @c MTZTableManager.
 */
- (instancetype)initWithTableView:(UITableView *)tableView
                        tableData:(MTZTableData *)tableData
                          context:(id)context;

/**
 This method validates the **visible** fields on the form. Upon a validation error, the offending line is highlighted and the field becomes the first responder.

 @param error The error object that will be populated with the appropriate @c localizedDescription coming from the validator.
 @return A flag indicating whether validation is successful or not.
 */
- (BOOL)validate:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
