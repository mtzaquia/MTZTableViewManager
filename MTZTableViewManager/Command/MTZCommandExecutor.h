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

#import "MTZCommandRegistering.h"
#import "MTZCommand.h"
#import "MTZCommandContext.h"

NS_ASSUME_NONNULL_BEGIN

/**
 A class that executes commands, providing them with the adequate context.
 */
@interface MTZCommandExecutor : NSObject <MTZCommandRegistering>

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/**
 Initialises a new executor.

 @param context The context that will be provided to all commands triggered by the instance.
 @return A valid @c MTZCommandExecutor instance.
 */
- (instancetype)initWithContext:(id<MTZCommandContext>)context;

/**
 Asks the executor to trigger a specific action of a command instance.

 @param commandClass The class of the command from which the action will executed.
 @param sender The entity that triggered the action.
 */
- (void)invokeCommandWithClass:(Class<MTZCommand>)commandClass sender:(id)sender NS_SWIFT_NAME(invokeCommand(class:sender:));

/**
 Asks the executor to trigger a specific action of a command instance.

 @param commandClass The class of the command from which the action will executed.
 @param payload A payload to support the command execution.
 @param sender The entity that triggered the action.
 */
- (void)invokeCommandWithClass:(Class<MTZCommand>)commandClass payload:(nullable id)payload sender:(id)sender NS_SWIFT_NAME(invokeCommand(class:payload:sender:));

@end

NS_ASSUME_NONNULL_END
