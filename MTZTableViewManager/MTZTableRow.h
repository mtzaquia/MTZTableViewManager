//
// MTZTableRow.h
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

#import "MTZModel.h"
#import "MTZReloadable.h"
#import "MTZLazyModel.h"
#import "MTZLazyModelPayload.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^MTZTableRowAction)(NSIndexPath *indexPath, id<MTZModel> _Nullable model);

/**
 A row capable of displaying models and perform actions upon selection.
 */
@interface MTZTableRow : NSObject <MTZReloadable>

/// The class of the cell to be used for this table row.
@property (nonatomic, readonly) Class cellClass;

/// The nib of the cell to be used for this table row.
@property (nonatomic, readonly) UINib *cellNib;

/// The regular height of the cell. If not set, automatic height will be used.
@property (nonatomic) CGFloat regularHeight;

/// The expanded height of the cell. If set, the cell will toggle between @c regularHeight and @c expandedHeight on touches.
@property (nonatomic) CGFloat expandedHeight;

/// A flag indicating whether the row should hide or not.
@property (nonatomic) BOOL hidden;

/// A block containing the action to be triggered once the cell is touched.
@property (nonatomic, nullable) MTZTableRowAction action;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/**
 Provides an instance of @c MTZTableRow that can be configured with a model and perform an action when selected.

 @param clazz The class of the cell.
 @param model A model for configuring the cell's appearance.
 @param action The action to be triggered while touching the cell.
 @return A valid instance of @c MTZTableFormRow.
 */
- (instancetype)initWithClass:(Class)clazz
                        model:(nullable id<MTZModel>)model
                       action:(nullable MTZTableRowAction)action NS_DESIGNATED_INITIALIZER NS_SWIFT_NAME(init(class:model:action:));

/**
 Provides an instance of @c MTZTableRow that can be configured with a model and perform an action when selected.

 @param nib The nib of the cell. Always provide the same instance for different cells for reuse optimization.
 @param model A model for configuring the cell's appearance.
 @param action The action to be triggered while touching the cell.
 @return A valid instance of @c MTZTableFormRow.
 */
- (instancetype)initWithNib:(UINib *)nib
                      model:(nullable id<MTZModel>)model
                     action:(nullable MTZTableRowAction)action NS_DESIGNATED_INITIALIZER;

/**
 Provides an instance of @c MTZTableRow that can be configured with a model and perform an action when selected.

 @param clazz The class of the cell.
 @param modelClass A model class for configuring the cell's appearance.
 @param modelPayload A model payload to generate an instance of the model class to configure the cell's appearance.
 @param action The action to be triggered while touching the cell.
 @return A valid instance of @c MTZTableFormRow.
 */
- (instancetype)initWithClass:(Class)clazz
                   modelClass:(Class)modelClass
                 modelPayload:(id<MTZLazyModelPayload>)modelPayload
                       action:(nullable MTZTableRowAction)action NS_DESIGNATED_INITIALIZER;

/**
 Provides an instance of @c MTZTableRow that can be configured with a model and perform an action when selected.

 @param nib The nib of the cell. Always provide the same instance for different cells for reuse optimization.
 @param modelClass A model class for configuring the cell's appearance.
 @param modelPayload A model payload to generate an instance of the model class to configure the cell's appearance.
 @param action The action to be triggered while touching the cell.
 @return A valid instance of @c MTZTableFormRow.
 */
- (instancetype)initWithNib:(UINib *)nib
                 modelClass:(Class)modelClass
               modelPayload:(id<MTZLazyModelPayload>)modelPayload
                     action:(nullable MTZTableRowAction)action NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
