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

@implementation MTZTableData

- (instancetype)initWithTableSections:(NSArray<MTZTableSection *> *)tableSections {
    self = [super init];
    if (self) {
        _sections = [tableSections mutableCopy];
        _hiddenSections = [NSMutableDictionary dictionary];
    }

    return self;
}

- (void)setTableSection:(MTZTableSection *)tableSection hidden:(BOOL)hidden {
    dispatch_sync(MTZTableUpdateQueue(), ^{
        if (hidden) {
            self.hiddenSections[@(tableSection.index)] = tableSection;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideSection:tableSection];
            });
        } else {
            MTZTableSection *finalTableSection = self.hiddenSections[@(tableSection.index)];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showSection:finalTableSection];
            });
            self.hiddenSections[@(tableSection.index)] = nil;
        }
    });
}

- (NSIndexPath *)indexPathForTableRow:(MTZTableRow *)tableRow {
    return [NSIndexPath indexPathForRow:[tableRow.section.rows indexOfObject:tableRow] inSection:[self.sections indexOfObject:tableRow.section]];
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
- (void)hideSection:(MTZTableSection *)tableSection {
    [self.tableView beginUpdates];
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:tableSection.index] withRowAnimation:UITableViewRowAnimationFade];
    [self.sections removeObject:tableSection];
    [self.tableView endUpdates];
}

- (void)showSection:(MTZTableSection *)tableSection {
    [self.tableView beginUpdates];
    [self.sections insertObject:tableSection atIndex:tableSection.index];
    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:tableSection.index] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

@end
