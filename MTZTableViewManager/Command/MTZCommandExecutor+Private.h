//
// MTZCommandExecutor+Private.h
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

#import "MTZCommandExecutor.h"

NS_ASSUME_NONNULL_BEGIN

/**
 A class capable of executing commands.
 */
@interface MTZCommandExecutor ()

/// A context that will be provided to all commands triggered by this executor.
@property (nonatomic, readonly, weak) id context;

/// A dictionary with the commands available for execution. Keys are the command classes.
@property (nonatomic, readonly) NSMutableDictionary *availableCommands;

/**
 Initialises a new executor.

 @param context The context that will be provided to all commands triggered by the instance.
 @return A valid @c MTZCommandExecutor instance.
 */
- (instancetype)initWithContext:(id)context;

@end

NS_ASSUME_NONNULL_END
