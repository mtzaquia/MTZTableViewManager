//
// MTZFormValidator.h
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
 A class that provides validation rules for form objects.
 */
@interface MTZFormValidator : NSObject

/// The error message for when the validation fails.
@property (nonatomic, copy, readonly) NSString *errorMessage;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/**
 This method initialises a new instance of a validator.

 @param errorMessage The error message for when the validation fails.
 @return A validator instance.
 */
- (instancetype)initWithErrorMessage:(NSString *)errorMessage;

/**
 This method validates the provided input. It must be overridden by subclasses.

 @param value The value to be validated.
 @param error The error pointer to be populated in case of an error.
 @return A flag indicating whether the value is valid or not.
 */
- (BOOL)validate:(nullable id)value error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
