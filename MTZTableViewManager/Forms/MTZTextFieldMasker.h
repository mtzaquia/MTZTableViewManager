//
// MTZTextFieldMasker.h
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
 A class that provides masking for @c UITextField's.
 */
@interface MTZTextFieldMasker : NSObject

/**
 A method indicating which characters should be accepted on the field.

 @return A NSCharacterSet with the allowed characters to be input on the field or @c nil no check.
 */
- (nullable NSCharacterSet *)allowedCharacterSet;

/**
 A method indicating the maximum length the input can have.

 @return A NSInteger indicating the maximum allowed length for the field or @c NSNotFound for no limit.
 */
- (NSInteger)maximumInputLength;

/**
 A method that asks for text to be inserted into an specific index on the current string.

 @param index The index to be verified against.
 @param currentString The string currently being displayed, before the masker appending.
 @return The string to be added at the given index.
 */
- (nullable NSString *)stringToAppendAtIndex:(NSInteger)index ofString:(NSString *)currentString;

@end

NS_ASSUME_NONNULL_END
