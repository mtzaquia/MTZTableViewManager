//
// MTZTableSection.m
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

#import "MTZTableSection+Private.h"
#import "MTZTableData+Private.h"
#import "MTZTableRow+Private.h"
#import "MTZTableFormRow+Private.h"
#import "MTZTableManagerUtils.h"
#import "UIResponder+FirstResponder.h"

@interface MTZTableSection ()
@property (nonatomic) NSMutableDictionary<NSNumber *, MTZTableRow *> *updatedRows;
@end

@implementation MTZTableSection

- (instancetype)initWithTableRows:(NSArray<MTZTableRow *> *)tableRows {
    return [self initWithTableRows:tableRows model:nil];
}

- (instancetype)initWithTableRows:(NSArray<MTZTableRow *> *)tableRows model:(id<MTZModel>)model {
    self = [super init];
    if (self) {
        _rows = [tableRows mutableCopy];
        _updatedRows = [NSMutableDictionary dictionary];
    }

    return self;
}

- (void)setTableRow:(MTZTableRow *)tableRow hidden:(BOOL)hidden {
    dispatch_group_enter(MTZTableUpdateGroup());
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        dispatch_async(MTZTableUpdateQueue(), ^{
            self.updatedRows[@(tableRow.index)] = tableRow;
            dispatch_group_leave(MTZTableUpdateGroup());
        });
    });

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_notify(MTZTableUpdateGroup(), dispatch_get_main_queue(), ^{
            hidden ? [self hideRows] : [self showRows];
            dispatch_sync(MTZTableUpdateQueue(), ^{
                [self.updatedRows removeAllObjects];
                onceToken = 0;
            });
        });
    });
}

- (void)setHidden:(BOOL)hidden {
    if (_hidden == hidden) {
        return;
    }

    _hidden = hidden;
    [self.tableData setTableSection:self hidden:_hidden];
}

- (NSMutableArray<MTZTableFormRow *> *)formRows {
    NSMutableArray *formRows = [@[] mutableCopy];
    for (MTZTableRow *row in self.rows) {
        if ([row isKindOfClass:[MTZTableFormRow class]]) {
            [formRows addObject:row];
        }
    }

    return formRows;
}

#pragma mark - MTZFormValidatable
- (BOOL)validate:(NSError **)error {
    for (MTZTableFormRow *tableFormRow in self.formRows) {
        if (tableFormRow.hidden) {
            continue;
        }

        BOOL valid = [tableFormRow validate:error];
        if (!valid) {
            return NO;
        }
    }

    return YES;
}

#pragma mark - MTZInputAccessoryViewHandling
- (void)inputAccessoryDidTapPrevious:(UIToolbar *)formAccessory {
    UIControl *currentFirstResponder = (UIControl *)[UIResponder mtz_currentFirstResponder];
    NSInteger previousIndex = [[self responderFormRows] indexOfObject:currentFirstResponder] - 1;
    if (previousIndex >= 0) {
        [[self responderFormRows][previousIndex] becomeFirstResponder];
    }
}

- (void)inputAccessoryDidTapNext:(UIToolbar *)formAccessory {
    UIControl *currentFirstResponder = (UIControl *)[UIResponder mtz_currentFirstResponder];
    NSInteger nextIndex = [[self responderFormRows] indexOfObject:currentFirstResponder] + 1;
    if (nextIndex < [self responderFormRows].count) {
        [[self responderFormRows][nextIndex] becomeFirstResponder];
    }
}

- (void)inputAccessoryDidTapDone:(UIToolbar *)formAccessory {
    [[UIResponder mtz_currentFirstResponder] resignFirstResponder];
}

#pragma mark - Private
- (NSArray<UIControl *> *)responderFormRows {
    return [[self.formRows valueForKeyPath:CLASSKEY(MTZTableFormRow, formField)] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIControl * responder, NSDictionary *bindings) {
        return [responder canBecomeFirstResponder];
    }]];
}

- (void)hideRows {
    NSArray *orderedKeys = [self.updatedRows.allKeys sortedArrayUsingSelector:@selector(compare:)];
    NSMutableArray *indexPaths = [NSMutableArray array];
    NSMutableArray *deletedRows = [NSMutableArray array];
    dispatch_sync(MTZTableUpdateQueue(), ^{
        for (NSNumber *key in orderedKeys) {
            [indexPaths addObject:[self.tableData indexPathForTableRow:self.updatedRows[key]]];
            [deletedRows addObject:self.updatedRows[key]];
        }
    });

    [self.tableData.tableView beginUpdates];
    [self.tableData.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self.rows removeObjectsInArray:deletedRows];
    [self.tableData.tableView endUpdates];
}

- (void)showRows {
    NSArray *orderedKeys = [self.updatedRows.allKeys sortedArrayUsingSelector:@selector(compare:)];
    NSMutableArray *addedRows = [NSMutableArray array];
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    NSMutableArray *indexPaths = [NSMutableArray array];
    dispatch_sync(MTZTableUpdateQueue(), ^{
        for (NSNumber *key in orderedKeys) {
            [addedRows addObject:self.updatedRows[key]];
            [indexSet addIndex:[key integerValue]];
            [indexPaths addObject:[self.tableData indexPathForTableRow:self.updatedRows[key]]];
        }
    });

    [self.tableData.tableView beginUpdates];
    [self.rows insertObjects:addedRows atIndexes:indexSet];
    [self.tableData.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self.tableData.tableView endUpdates];
}
@end
