//
// MTZCommandExecutor.h
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

@protocol MTZCommand;

NS_ASSUME_NONNULL_BEGIN

/**
 A class that executes commands, providing them with the adequate context.
 */
@interface MTZCommandExecutor : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/**
 Asks the executor to trigger a specific action of a command instance.

 @param command The command from which the action will executed.
 */
- (void)executeCommand:(id<MTZCommand>)command;

/**
 Asks the executor to trigger a specific action of a command instance.

 @param command The command from which the action will executed.
 @param sender The entity that triggered the 
 */
- (void)executeCommand:(id<MTZCommand>)command sender:(nullable id)sender;

@end

NS_ASSUME_NONNULL_END
