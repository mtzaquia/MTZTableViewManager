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

@implementation MTZTableSection

- (instancetype)initWithTableRows:(NSArray<MTZTableRow *> *)tableRows {
    return [self initWithTableRows:tableRows model:nil];
}

- (instancetype)initWithTableRows:(NSArray<MTZTableRow *> *)tableRows model:(id<MTZModel>)model {
    self = [super init];
    if (self) {
        _rows = [tableRows mutableCopy];
    }

    return self;
}

- (void)setTableRow:(MTZTableRow *)tableRow hidden:(BOOL)hidden {
    if (hidden) {
        tableRow.index = [self.rows indexOfObject:tableRow];
        [self hideRow:tableRow];
    } else {
        [self showRow:tableRow];
    }
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

- (void)hideRow:(MTZTableRow *)tableRow {
    [self.tableData.tableView beginUpdates];
    [self.tableData.tableView deleteRowsAtIndexPaths:@[[self.tableData indexPathForTableRow:tableRow]] withRowAnimation:UITableViewRowAnimationFade];
    [self.rows removeObject:tableRow];
    [self.tableData.tableView endUpdates];
}

- (void)showRow:(MTZTableRow *)tableRow {
    [self.tableData.tableView beginUpdates];
    [self.rows insertObject:tableRow atIndex:tableRow.index];
    [self.tableData.tableView insertRowsAtIndexPaths:@[[self.tableData indexPathForTableRow:tableRow]] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableData.tableView endUpdates];
}
@end
