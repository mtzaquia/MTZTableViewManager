//
// MTZTableData.m
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

#import "MTZTableData+Private.h"
#import "MTZTableSection+Private.h"
#import "MTZTableRow+Private.h"
#import "MTZTableFormRow+Private.h"

CGFloat const MTZTableDataDefaultAnimationDuration = 0.25;

@interface MTZTableData ()
@property (nonatomic) NSMutableDictionary<NSNumber *, MTZTableSection *> *updatedSections;
@end

@implementation MTZTableData

- (instancetype)initWithTableSections:(NSArray<MTZTableSection *> *)tableSections {
    self = [super init];
    if (self) {
        _sections = [tableSections mutableCopy];
        _updatedSections = [NSMutableDictionary dictionary];
    }

    return self;
}

- (void)setTableSection:(MTZTableSection *)tableSection hidden:(BOOL)hidden {
    dispatch_group_enter(MTZTableUpdateGroup());
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        dispatch_async(MTZTableUpdateQueue(), ^{
            self.updatedSections[@(tableSection.index)] = tableSection;
            dispatch_group_leave(MTZTableUpdateGroup());
        });
    });

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_notify(MTZTableUpdateGroup(), dispatch_get_main_queue(), ^{
            hidden ? [self hideSections] : [self showSections];
            dispatch_sync(MTZTableUpdateQueue(), ^{
                [self.updatedSections removeAllObjects];
                onceToken = 0;
            });
        });
    });
}

- (NSIndexPath *)indexPathForTableRow:(MTZTableRow *)tableRow {
    return [NSIndexPath indexPathForRow:tableRow.index inSection:tableRow.section.index];
}

#pragma mark - MTZFormValidatable
- (BOOL)validate:(NSError **)error {
    NSAssert(error, @"A valid error pointer must be passed to -validate:");
    for (MTZTableSection *tableSection in self.sections) {
        if (tableSection.hidden) {
            continue;
        }

        BOOL valid = [tableSection validate:error];
        if (!valid) {
            MTZTableFormRow *tableFormRow = (*error).userInfo[MTZTableFormRowKey];
            if (tableFormRow) {
                [UIView animateWithDuration:MTZTableDataDefaultAnimationDuration animations:^{
                    [self.tableView scrollToRowAtIndexPath:[self indexPathForTableRow:tableFormRow] atScrollPosition:UITableViewScrollPositionNone animated:NO];
                }];
            }
            
            NSMutableDictionary *mutableUserInfo = [(*error).userInfo mutableCopy];
            mutableUserInfo[MTZTableFormRowKey] = nil;
            (*error) = [NSError errorWithDomain:(*error).domain code:(*error).code userInfo:mutableUserInfo];
            return NO;
        }
    }

    return YES;
}

#pragma mark - Private
- (void)hideSections {
    NSArray *orderedKeys = [self.updatedSections.allKeys sortedArrayUsingSelector:@selector(compare:)];
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    NSMutableArray *deletedSections = [NSMutableArray array];
    dispatch_sync(MTZTableUpdateQueue(), ^{
        for (NSNumber *key in orderedKeys) {
            [indexSet addIndex:[key integerValue]];
            [deletedSections addObject:self.updatedSections[key]];
        }
    });

    [self.tableView beginUpdates];
    [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    [self.sections removeObjectsInArray:deletedSections];
    [self.tableView endUpdates];
}

- (void)showSections {
    NSArray *orderedKeys = [self.updatedSections.allKeys sortedArrayUsingSelector:@selector(compare:)];
    NSMutableArray *addedSections = [NSMutableArray array];
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    dispatch_sync(MTZTableUpdateQueue(), ^{
        for (NSNumber *key in orderedKeys) {
            [addedSections addObject:self.updatedSections[key]];
            [indexSet addIndex:[key integerValue]];
        }
    });

    [self.tableView beginUpdates];
    [self.sections insertObjects:addedSections atIndexes:indexSet];
    [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

@end
