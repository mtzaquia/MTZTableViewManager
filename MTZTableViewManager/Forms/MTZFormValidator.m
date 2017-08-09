//
// MTZFormValidator.m
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

#import "MTZFormValidator.h"

@implementation MTZFormValidator

@synthesize errorMessage = _errorMessage;

- (instancetype)initWithErrorMessage:(NSString *)errorMessage {
    self = [super init];
    if (self) {
        _errorMessage = errorMessage;
    }
    
    return self;
}

- (BOOL)validate:(id)value error:(NSError **)error {
    NSAssert(NO, @"Subclasses of MTZFormValidator must override -validate:error:");
    return NO;
}

- (NSString *)errorMessage {
    NSAssert(_errorMessage.length, @"Subclasses of MTZFormValidator must provide an error message as an initialization parameter.");
    return _errorMessage;
}

@end
