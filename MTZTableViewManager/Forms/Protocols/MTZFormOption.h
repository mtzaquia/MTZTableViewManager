//
// MTZFormOption.h
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

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

/**
 Describes an object that can be an option on a form entry that has list of available options.
 */
@protocol MTZFormOption <NSObject>

/**
 Provides the textual representation of a complex object for being displayed as an option on the form.

 @return The textual representation of the object.
 */
- (NSString *)optionDescription;
@optional
/**
 Provides a formatted, textual representation of a complex object for being displayed as an option on the form.

 @return The formatted, textual representation of the object.
 */
- (NSAttributedString *)optionAttributedDescription;

/**
 Provides a custom view for the complex object for being displayed as a picker row.

 @param reusableView The view to be reused for performance purposes.
 @return A reusable view that's going to be a row on the picker.
 */
- (UIView *)optionViewReusingView:(nullable UIView *)reusableView;
@end
NS_ASSUME_NONNULL_END
