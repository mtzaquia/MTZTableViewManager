//
// MTZTableRow.m
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

#import "MTZTableRow+Private.h"
#import "MTZTableData+Private.h"
#import "MTZTableManagerUtils.h"
#import "MTZTableSection+Private.h"

@implementation MTZTableRow

- (instancetype)initWithClass:(Class)clazz action:(MTZTableRowAction)action {
    return [self initWithClass:clazz model:nil action:action];
}

- (instancetype)initWithNib:(UINib *)nib action:(MTZTableRowAction)action {
    return [self initWithNib:nib model:nil action:action];
}

- (instancetype)initWithClass:(Class)clazz model:(id<MTZModel>)model action:(MTZTableRowAction)action {
    self = [super init];
    if (self) {
        _cellClass = clazz;
        _model = model;
        _action = action;
    }

    return self;
}

- (instancetype)initWithNib:(UINib *)nib model:(id<MTZModel>)model action:(MTZTableRowAction)action {
    self = [super init];
    if (self) {
        _cellNib = nib;
        _model = model;
        _action = action;
    }

    return self;
}

- (void)setHidden:(BOOL)hidden {
    if (_hidden == hidden) {
        return;
    }

    _hidden = hidden;
    [self.section setTableRow:self hidden:_hidden];
}

#pragma mark - MTZReloadable
- (void)reload {
    dispatch_async(MTZTableUpdateQueue(), ^{
        NSIndexPath *rowPath = [self.section.tableData indexPathForTableRow:self];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Only reload if the cell is visible, otherwise the table jumps.
            if ([[self.section.tableData.tableView indexPathsForVisibleRows] containsObject:rowPath]) {
                [self.section.tableData.tableView beginUpdates];
                [self.section.tableData.tableView reloadRowsAtIndexPaths:@[rowPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.section.tableData.tableView endUpdates];
            }
        });
    });
}

@end
