//
// MTZTableManager.m
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

#import "MTZTableManager.h"
#import "MTZCommandExecuting.h"
#import "MTZCommandExecutor+Private.h"
#import "MTZTableData+Private.h"
#import "MTZTableSection+Private.h"
#import "MTZTableRow+Private.h"
#import "MTZTableFormRow+Private.h"
#import "MTZModelDisplaying.h"
#import "MTZFormEditing.h"
#import "MTZFormField.h"
#import "MTZTextFieldMasker+Private.h"

static CGFloat MTZTableManagerEstimatedRowHeight = 44.0;

@interface MTZTableManager () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic) MTZTableData *tableData;
@property (nonatomic, readonly) MTZCommandExecutor *commandExecutor;
@property (nonatomic) CGFloat keyboardBaseBottomInset;
@end

@implementation MTZTableManager

- (instancetype)initWithTableView:(UITableView *)tableView tableData:(MTZTableData *)tableData {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    return [self initWithTableView:tableView tableData:tableData commandExecutor:nil];
#pragma clang diagnostic pop
}

- (instancetype)initWithTableView:(UITableView *)tableView tableData:(MTZTableData *)tableData commandExecutor:(MTZCommandExecutor *)commandExecutor {
    self = [super init];
    if (self) {
        _tableView = tableView;
        _tableView.estimatedRowHeight = _estimatedRowHeight ?: MTZTableManagerEstimatedRowHeight;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
        _tableView.sectionFooterHeight = UITableViewAutomaticDimension;

        _tableData = tableData;
        [self registerTableData:_tableData forTableView:_tableView];
        _tableData.tableView = _tableView;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (_tableData.headerView) {
            _tableView.tableHeaderView = _tableData.headerView;
        } else {
            CGRect headerFrame = (CGRect){0, 0, _tableView.bounds.size.width, CGFLOAT_MIN};
            _tableView.tableHeaderView = [[UIView alloc] initWithFrame:headerFrame];
        }

        _tableView.tableFooterView = _tableData.footerView;
        [self setupInitialHiddenStateFromTableData:_tableData forTableView:_tableView];
        _commandExecutor = commandExecutor;

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboard:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    }

    return self;
}

#pragma mark - MTZFormValidatable
- (BOOL)validate:(NSError **)error {
    return [self.tableData validate:error];
}

#pragma mark - Private
- (void)handleKeyboard:(NSNotification *)notification {
    BOOL showing = [notification.name isEqualToString:UIKeyboardWillShowNotification];
    if (self.keyboardBaseBottomInset == 0) {
        self.keyboardBaseBottomInset = self.tableView.contentInset.bottom;
    }

    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardFrame = [self.tableView convertRect:[userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:nil];
    CGRect intersect = CGRectIntersection(keyboardFrame, self.tableView.bounds);
    if (!CGRectIsNull(intersect)) {
        NSTimeInterval keyboardAnimationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        NSInteger keyboardAnimationCurve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
        [UIView animateWithDuration:keyboardAnimationDuration delay:0 options:keyboardAnimationCurve animations:^{
            self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.contentInset.top,
                                                           self.tableView.contentInset.left,
                                                           (showing ? intersect.size.height : self.keyboardBaseBottomInset),
                                                           self.tableView.contentInset.right);
            self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
        } completion:nil];
    }
}

- (UITableView *)tableView {
    NSAssert(_tableView, @"The table view is weakly held by MTZTableManager, so they must be strongly held by something else.");
    return _tableView;
}

- (void)registerTableData:(MTZTableData *)tableData forTableView:(UITableView *)tableView {
    [tableData.sections enumerateObjectsUsingBlock:^(MTZTableSection * _Nonnull section, NSUInteger idx, BOOL * _Nonnull stop) {
        section.tableData = tableData;
        section.index = idx;
        if (section.headerClazz) {
            [tableView registerClass:section.headerClazz forHeaderFooterViewReuseIdentifier:NSStringFromClass(section.headerClazz)];
        }

        if (section.footerClazz) {
            [tableView registerClass:section.footerClazz forHeaderFooterViewReuseIdentifier:NSStringFromClass(section.footerClazz)];
        }

        [section.rows enumerateObjectsUsingBlock:^(MTZTableRow * _Nonnull row, NSUInteger idx, BOOL * _Nonnull stop) {
            row.section = section;
            row.index = idx;
            if (row.clazz) {
                [tableView registerClass:row.clazz forCellReuseIdentifier:NSStringFromClass(row.clazz)];
            } else if (row.nib) {
                [tableView registerNib:row.nib forCellReuseIdentifier:row.nib.description];
            }
        }];
    }];
}

- (void)configureTableFormRow:(MTZTableFormRow *)tableFormRow forCell:(UITableViewCell *)cell {
    if ([cell conformsToProtocol:@protocol(MTZFormEditing)]) {
        id<MTZFormEditing> formCell = (id<MTZFormEditing>)cell;
        tableFormRow.formField = [formCell fieldForFormObject];
    }
}

- (void)setupInitialHiddenStateFromTableData:(MTZTableData *)tableData forTableView:(UITableView *)tableView {
    BOOL shouldReloadData = NO;
    NSMutableArray *sectionsToRemove = [NSMutableArray array];
    NSMutableArray *rowsToRemove = [NSMutableArray array];
    for (MTZTableSection *section in tableData.sections) {
        if (section.hidden) {
            [sectionsToRemove addObject:section];
            shouldReloadData = YES;
        }

        for (MTZTableRow *row in section.rows) {
            if (row.hidden) {
                [rowsToRemove addObject:row];
                shouldReloadData = YES;
            }
        }

        [section.rows removeObjectsInArray:rowsToRemove];
    }

    [tableData.sections removeObjectsInArray:sectionsToRemove];
    if (shouldReloadData) {
        [tableView reloadData];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tableData.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableData.sections[section].rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MTZTableRow *row = self.tableData.sections[indexPath.section].rows[indexPath.row];
    NSString *identifier = NSStringFromClass(row.clazz) ?: row.nib.description;
    NSAssert(identifier.length, @"Every MTZTableRow must provide a class or a nib.");
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];

    if ([cell conformsToProtocol:@protocol(MTZModelDisplaying)]) {
        [(id<MTZModelDisplaying>)cell configureWithModel:row.model];
    }

    if ([row isKindOfClass:[MTZTableFormRow class]]) {
        MTZTableFormRow *tableFormRow = (MTZTableFormRow *)row;
        [self configureTableFormRow:tableFormRow forCell:cell];
    }

    if ([cell conformsToProtocol:@protocol(MTZCommandExecuting)]) {
        NSAssert(self.commandExecutor, @"A row conforms to MTZCommandExecuting, but the table manager instance has no context. Use '-[MTZTableManager initWithTableView:tableData:context:]' instead.");
        [(id<MTZCommandExecuting>)cell setCommandExecutor:self.commandExecutor];
    }

    cell.selectionStyle = row.expandedHeight > 0 || row.expandedHeight == UITableViewAutomaticDimension || row.action ? UITableViewCellSelectionStyleDefault : UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.tableData.sections[section].headerText;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return self.tableData.sections[section].footerText;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MTZTableRow *row = self.tableData.sections[indexPath.section].rows[indexPath.row];
    if (row.action) {
        row.action(indexPath, row.model);
    }

    if (row.expandedHeight > 0 || row.expandedHeight == UITableViewAutomaticDimension) {
        row.expanded = !row.expanded;
        [tableView beginUpdates];
        [tableView endUpdates];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MTZTableRow *row = self.tableData.sections[indexPath.section].rows[indexPath.row];
    return (row.expanded ? row.expandedHeight : row.regularHeight) ?: UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MTZTableSection *tableSection = self.tableData.sections[section];
    if (!tableSection.headerClazz) {
        return nil;
    }

    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(tableSection.headerClazz)];
    if (!view) {
        view = [[tableSection.headerClazz alloc] initWithReuseIdentifier:NSStringFromClass(tableSection.headerClazz)];
    }

    if ([view conformsToProtocol:@protocol(MTZModelDisplaying)]) {
        [(id<MTZModelDisplaying>)view configureWithModel:tableSection.model];
    }

    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    MTZTableSection *tableSection = self.tableData.sections[section];
    if (!tableSection.footerClazz) {
        return nil;
    }

    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(tableSection.footerClazz)];
    if (!view) {
        view = [[tableSection.footerClazz alloc] initWithReuseIdentifier:NSStringFromClass(tableSection.footerClazz)];
    }

    if ([view conformsToProtocol:@protocol(MTZModelDisplaying)]) {
        [(id<MTZModelDisplaying>)view configureWithModel:tableSection.model];
    }

    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.tableData.sections[section].headerHeight ?: UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return self.tableData.sections[section].footerHeight ?: UITableViewAutomaticDimension;
}

@end
