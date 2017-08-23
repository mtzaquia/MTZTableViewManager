//
// MTZCommandExecutor.m
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

#import "MTZCommandExecutor+Private.h"
#import "MTZCommand.h"
#import "MTZCommandContext.h"

@implementation MTZCommandExecutor

- (instancetype)initWithContext:(id<MTZCommandContext>)context {
    self = [super init];
    if (self) {
        _context = context;
        _availableCommands = [@{} mutableCopy];
    }
    
    return self;
}

- (void)registerCommand:(id<MTZCommand>)command {
    self.availableCommands[NSStringFromClass(command.class)] = command;
}

- (void)invokeCommandWithClass:(Class<MTZCommand>)commandClass sender:(id)sender {
    [self invokeCommandWithClass:commandClass payload:nil sender:sender];
}

- (void)invokeCommandWithClass:(Class<MTZCommand>)commandClass payload:(id)payload sender:(id)sender {
    id<MTZCommand> command = self.availableCommands[NSStringFromClass(commandClass)];
    NSAssert(command, @"All commands must be added to the invoker using -[MTZCommandInvoker addCommand:] prior to being executed.");
    [command wasInvokedWithPayload:nil sender:sender context:self.context];
}

@end
