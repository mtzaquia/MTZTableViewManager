//
// MTZTableManagerUtils.h
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

#import <objc/runtime.h>

@protocol MTZKeyPath <NSObject>
@end
typedef NSString<MTZKeyPath> MTZKeyPath;

static inline MTZKeyPath *GetMTZKeyPath(__unused unsigned long val, NSString *str) {
    return (MTZKeyPath *)str;
}

#define KEYPATH(obj, key) GetMTZKeyPath(sizeof(obj.key), @#key)
#define CLASSKEY(cls, key) KEYPATH(((cls*)nil), key)

static inline BOOL MTZFormObjectKeyPathIsOfClass(NSObject<MTZFormObject> *formObject, MTZKeyPath *keyPath, Class clazz) {
    objc_property_t theProperty = class_getProperty([formObject class], keyPath.UTF8String);
    const char *propertyAttributesRaw = property_getAttributes(theProperty);
    NSString *propertyAttributes = [NSString stringWithUTF8String:propertyAttributesRaw];
    return [propertyAttributes containsString:NSStringFromClass(clazz)];
}

static inline NSDateFormatter *MTZSharedDateFormatter() {
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [NSDateFormatter new];
        formatter.dateStyle = NSDateFormatterLongStyle;
    });

    return formatter;
}
