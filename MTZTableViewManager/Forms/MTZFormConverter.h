//
// MTZFormConverter.h
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

NS_ASSUME_NONNULL_BEGIN
/**
 A class that provides conversion rules between form objects and form fields.
 */
@interface MTZFormConverter : NSObject
/**
 Provides a complex object to populate the form object with input from the field.

 @param fieldValue The value on the form field that requires conversion.
 @return The complex object to be set on the form object.
 */
- (nullable id)fromFieldValue:(id)fieldValue;

/**
 Provides a form field friendly object out of a complex object. If this method returns @c nil, an assertion is raised.

 @param complexValue The complex value on the form object that requires conversion.
 @return The form field friendly object. @c nil for conversion failure.
 */
- (nullable id)toFieldValue:(id)complexValue;
@end

NS_ASSUME_NONNULL_END
