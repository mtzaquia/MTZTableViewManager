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

#import "MTZCommandContext.h"
#import "MTZCommandPayload.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Defines an object that provides an action that can be triggered from within the rows.
 */
@protocol MTZCommand <NSObject>

/**
 This method executes the command passing along the sender and a valid context.

 @param payload A custom object for supporting the command execution.
 @param sender The object triggering the command action.
 @param context The context in which the command was triggered.
 */
- (void)wasInvokedWithPayload:(nullable id<MTZCommandPayload>)payload
                       sender:(nullable id)sender
                      context:(id<MTZCommandContext>)context NS_SWIFT_NAME(wasInvoked(with:sender:context:));

@end

NS_ASSUME_NONNULL_END
