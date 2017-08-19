//
// MTZCommand.h
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

typedef void (^MTZCommandAction)(id context);

/**
 A class that provides actions that can be triggered from within the rows.
 */
@interface MTZCommand : NSObject

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;


/**
 This method initialises a new instance of a command.

 @param action The action to be triggered whenever this command is executed by an executor.
 @return A command instance.
 */
- (instancetype)initWithAction:(MTZCommandAction)action NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
