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



@interface MTZTableRow ()
@property (nonatomic, nullable) Class modelClass;
@property (nonatomic, nullable) id<MTZLazyModelPayload> modelPayload;
@end

@implementation MTZTableRow

@synthesize model = _model;

- (instancetype)initWithClass:(Class)clazz model:(id<MTZModel>)model action:(nullable MTZTableRowAction)action {
    self = [super init];
    if (self) {
        _cellClass = clazz;
        _model = model;
        _action = action;
    }

    return self;
}

- (instancetype)initWithNib:(UINib *)nib model:(id<MTZModel>)model action:(nullable MTZTableRowAction)action {
    self = [super init];
    if (self) {
        _cellNib = nib;
        _model = model;
        _action = action;
    }

    return self;
}

- (instancetype)initWithClass:(Class)clazz
                   modelClass:(Class)modelClass
                 modelPayload:(id<MTZLazyModelPayload>)modelPayload
                       action:(nullable MTZTableRowAction)action {
    self = [super init];
    if (self) {
        _cellClass = clazz;
        _modelClass = modelClass;
        _modelPayload = modelPayload;
        _action = action;
    }

    return self;
}

- (instancetype)initWithNib:(UINib *)nib
                 modelClass:(Class)modelClass
               modelPayload:(id<MTZLazyModelPayload>)modelPayload
                     action:(nullable MTZTableRowAction)action {
    self = [super init];
    if (self) {
        _cellNib = nib;
        _modelClass = modelClass;
        _modelPayload = modelPayload;
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

- (id<MTZModel>)model {
    if (!_model && self.modelClass) {
        NSAssert([self.modelClass respondsToSelector:@selector(initWithPayload:)], @"Only classes conforming to MTZLazyModel can be used for lazy models.");
        _model = [[[self.modelClass class] alloc] initWithPayload:self.modelPayload];
    }

    return _model;
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
