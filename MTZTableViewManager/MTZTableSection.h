//
// MTZTableSection.h
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

@class MTZTableRow;

NS_ASSUME_NONNULL_BEGIN

@interface MTZTableSection : NSObject <MTZReloadable>

/// The model to configure the header and footer of the section, if applicable.
@property (nonatomic, nullable) id<MTZModel> model;

/// The height of the header. If not set, automatic height will be used.
@property (nonatomic) CGFloat headerHeight;

/// The class of the header. Has preference over @c headerText.
@property (nonatomic, nullable) Class headerClass;

/// The text to be displayed on the header.
@property (nonatomic, nullable) NSString *headerText;

/// The height of the footer. If not set, automatic height will be used.
@property (nonatomic) CGFloat footerHeight;

/// The class of the footer. Has preference over @c footerText.
@property (nonatomic, nullable) Class footerClass;

/// The text to be displayed on the footer.
@property (nonatomic, nullable) NSString *footerText;

/// A flag indicating whether the section should hide or not.
@property (nonatomic) BOOL hidden;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/**
 Provides an instance of @c MTZTableSection with a set of cells.

 @param tableRows A list of @c MTZTableRow objects to be displayed.
 @return A valid instance of @c MTZTableSection.
 */
- (instancetype)initWithTableRows:(NSArray<MTZTableRow *> *)tableRows;

/**
 Provides an instance of @c MTZTableSection with a set of cells and a model for headers and footers setup.

 @param tableRows A list of @c MTZTableRow objects to be displayed.
 @param model A model that can configure the section header and footer.
 @return A valid instance of @c MTZTableSection.
 */
- (instancetype)initWithTableRows:(NSArray<MTZTableRow *> *)tableRows model:(nullable id<MTZModel>)model NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
