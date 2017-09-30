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

static inline NSDateFormatter *MTZSharedDateFormatter() {
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [NSDateFormatter new];
        formatter.dateStyle = NSDateFormatterLongStyle;
    });

    return formatter;
}

static inline dispatch_queue_t MTZTableUpdateQueue() {
    static dispatch_queue_t tableUpdateQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tableUpdateQueue = dispatch_queue_create("com.zaquia.MTZTableViewManager.queue.tableupdate", 0);
    });

    return tableUpdateQueue;
}

static inline dispatch_group_t MTZTableUpdateGroup() {
    static dispatch_group_t tableUpdateGroup;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tableUpdateGroup = dispatch_group_create();
    });

    return tableUpdateGroup;
}
