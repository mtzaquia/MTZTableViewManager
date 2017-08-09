//
// MTZTableFormRow.h
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

#import "MTZTableRow.h"

@class MTZFormConverter;
@class MTZFormValidator;
@class MTZTextFieldMasker;
@protocol MTZFormObject;
@protocol MTZFormOption;

NS_ASSUME_NONNULL_BEGIN

/// This key will have the form field at @c NSError's @c userInfo that error out during validation.
extern NSErrorUserInfoKey const MTZFormFieldKey;

/**
 A row that has editing capabitilies and can modify a form object via key path, apply field masking, make conversions and perform validations.
 */
@interface MTZTableFormRow : MTZTableRow

/// An optional masker for the form row. Only works with @c UITextFields.
@property (nonatomic, strong, nullable) __kindof MTZTextFieldMasker *masker;

/// A converter between complex objects and visual representations for form fields.
@property (nonatomic, strong, nullable) __kindof MTZFormConverter *converter;

/// A list of validators for the form row. Validation is ordered and stops at first error.
@property (nonatomic, strong, nullable) NSArray<__kindof MTZFormValidator *> *validators;

/// A list of available options for the current form row. If set, the @c inputView for the row becomes a picker.
@property (nonatomic, strong, nullable) NSArray<id<MTZFormOption>> *availableOptions;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithClazz:(Class)clazz
                       action:(nullable MTZTableRowAction)action NS_UNAVAILABLE;
- (instancetype)initWithNib:(UINib *)nib
                     action:(nullable MTZTableRowAction)action NS_UNAVAILABLE;
- (instancetype)initWithClazz:(Class)clazz
                        model:(nullable id<MTZModel>)model
                       action:(nullable MTZTableRowAction)action NS_UNAVAILABLE;
- (instancetype)initWithNib:(UINib *)nib
                      model:(nullable id<MTZModel>)model
                     action:(nullable MTZTableRowAction)action NS_UNAVAILABLE;

/**
 Provides an instance of @c MTZTableFormRow that can manipulate a form object at a given key path.

 @param clazz The class of the cell.
 @param formObject The form object to be edited.
 @param keyPath The key path to be manipulated by the field on the row.
 @return A valid instance of @c MTZTableFormRow.
 */
- (instancetype)initWithClazz:(Class)clazz
                   formObject:(id<MTZFormObject>)formObject
                      keyPath:(NSString *)keyPath;

/**
 Provides an instance of @c MTZTableFormRow that can manipulate a form object at a given key path.

 @param nib The nib of the cell. Always provide the same instance for different cells for reuse optimization.
 @param formObject The form object to be edited.
 @param keyPath The key path to be manipulated by the field on the row.
 @return A valid instance of @c MTZTableFormRow.
 */
- (instancetype)initWithNib:(UINib *)nib
                 formObject:(id<MTZFormObject>)formObject
                    keyPath:(NSString *)keyPath;

/**
 Provides an instance of @c MTZTableFormRow that can manipulate a form object at a given key path.

 @param clazz The class of the cell.
 @param formObject The form object to be edited.
 @param keyPath The key path to be manipulated by the field on the row.
 @param model A model for configuring the cell's appearance.
 @return A valid instance of @c MTZTableFormRow.
 */
- (instancetype)initWithClazz:(Class)clazz
                   formObject:(id<MTZFormObject>)formObject
                      keyPath:(NSString *)keyPath
                        model:(nullable id<MTZModel>)model NS_DESIGNATED_INITIALIZER;

/**
 Provides an instance of @c MTZTableFormRow that can manipulate a form object at a given key path.

 @param nib The nib of the cell. Always provide the same instance for different cells for reuse optimization.
 @param formObject The form object to be edited.
 @param keyPath The key path to be manipulated by the field on the row.
 @param model A model for configuring the cell's appearance.
 @return A valid instance of @c MTZTableFormRow.
 */
- (instancetype)initWithNib:(UINib *)nib
                 formObject:(id<MTZFormObject>)formObject
                    keyPath:(NSString *)keyPath
                      model:(nullable id<MTZModel>)model NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
