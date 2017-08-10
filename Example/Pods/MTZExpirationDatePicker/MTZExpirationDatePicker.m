//
// MTZExpirationDatePicker.m
// MTZExpirationDatePicker
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

#import "MTZExpirationDatePicker.h"

static NSInteger const MTZNumberOfPickerComponents = 2;
static NSInteger const MTZMonthComponent = 0;
static NSInteger const MTZYearComponent = 1;

@interface MTZExpirationDatePicker () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, readwrite) NSDate *date;
@property (nonatomic, readonly) NSArray *months;
@property (nonatomic, readonly) NSArray *years;
@property (nonatomic) UILabel *labelSeparator;
@end

@implementation MTZExpirationDatePicker

@dynamic delegate;
@dynamic dataSource;

- (instancetype)init {
    self = [super init];
    if (self) {
        super.dataSource = self;
        super.delegate = self;
        [self addSlashLabel];
        _minimumDate = [NSDate date];
        _maximumDate = [[self pickerCalendar] dateByAddingUnit:NSCalendarUnitYear value:10 toDate:_minimumDate options:0];
        [self setDate:_minimumDate animated:NO];
    }

    return self;
}

- (void)setDate:(NSDate *)date animated:(BOOL)animated {
    if (date.timeIntervalSince1970 > self.maximumDate.timeIntervalSince1970) {
        date = self.maximumDate;
    } else if (date.timeIntervalSince1970 < self.minimumDate.timeIntervalSince1970) {
        date = self.minimumDate;
    }

    _date = date;
    NSDateComponents *components = [[self pickerCalendar] components:NSCalendarUnitMonth|NSCalendarUnitYear fromDate:date];
    [self selectRow:(components.month - 1) inComponent:MTZMonthComponent animated:animated];
    [self selectRow:(components.year + [self yearOffset]) inComponent:MTZYearComponent animated:animated];
}

#pragma mark - Properties

- (void)setMinimumDate:(NSDate *)minimumDate {
    _minimumDate = minimumDate;
    if (self.maximumDate) {
        NSAssert(_minimumDate.timeIntervalSince1970 < self.maximumDate.timeIntervalSince1970, @"The minimum date cannot be equal to or later than maximum date.");
    }
    [self setDate:_minimumDate animated:NO];
}

- (void)setMaximumDate:(NSDate *)maximumDate {
    _maximumDate = maximumDate;
    if (self.minimumDate) {
        NSAssert(_maximumDate.timeIntervalSince1970 > self.minimumDate.timeIntervalSince1970, @"The maximum date cannot be equal to or earlier than minimum date.");
    }
}

- (void)setShowsSeparator:(BOOL)showsSlash {
    _showsSeparator = showsSlash;
    self.labelSeparator.hidden = !_showsSeparator;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return MTZNumberOfPickerComponents;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return component == MTZMonthComponent ? self.months.count : self.years.count;
}

#pragma mark - UIPickerViewDelegate
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    NSString *title;
    if (component == MTZMonthComponent) {
        paragraphStyle.alignment = NSTextAlignmentRight;
        title = [self.months[row] stringByAppendingString:@"   "];
    } else if (component == MTZYearComponent) {
        paragraphStyle.alignment = NSTextAlignmentLeft;
        title = [@"   " stringByAppendingString:self.years[row]];
    }

    NSDictionary *attributes = @{NSParagraphStyleAttributeName: paragraphStyle};
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == MTZMonthComponent) {
        [self updateYearComponentForMonthIfNeeded:row + 1];
    } else if (component == MTZYearComponent) {
        [self updateMonthComponentForYearIfNeeded:row + [self yearOffset]];
    }

    NSInteger month = [self selectedRowInComponent:MTZMonthComponent] + 1;
    NSInteger year = [self selectedRowInComponent:MTZYearComponent] + [self yearOffset];
    self.date = [self dateFromMonth:month year:year];
    [self.datePickerDelegate datePickerDidChangeDate:self];
}

#pragma mark - Private
- (NSCalendar *)pickerCalendar {
    return [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
}

- (NSArray *)months {
    return @[@"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", @"12"];
}

- (NSArray *)years {
    NSInteger mininumYear = [[self pickerCalendar] component:NSCalendarUnitYear fromDate:self.minimumDate];
    NSInteger maximumYear = [[self pickerCalendar] component:NSCalendarUnitYear fromDate:self.maximumDate];
    NSMutableArray *years = [@[] mutableCopy];
    for (NSInteger year=mininumYear; year<=maximumYear; year++) {
        [years addObject:[@(year) stringValue]];
    }

    return years;
}

- (NSInteger)yearOffset {
    return [[self pickerCalendar] component:NSCalendarUnitYear fromDate:self.minimumDate];
}

- (NSDate *)dateFromMonth:(NSInteger)month year:(NSInteger)year {
    NSDateComponents *components = [NSDateComponents new];
    components.month = month;
    components.year = year;
    return [[self pickerCalendar] dateFromComponents:components];
}

- (void)updateYearComponentForMonthIfNeeded:(NSInteger)month {
    NSDateComponents *mininumComponents = [[self pickerCalendar] components:NSCalendarUnitMonth|NSCalendarUnitYear fromDate:self.minimumDate];
    NSDateComponents *maximumComponents = [[self pickerCalendar] components:NSCalendarUnitMonth|NSCalendarUnitYear fromDate:self.maximumDate];
    NSInteger year = [self selectedRowInComponent:MTZYearComponent] + [self yearOffset];
    NSDate *attemptDate = [self dateFromMonth:month year:year];
    if (attemptDate.timeIntervalSince1970 > self.maximumDate.timeIntervalSince1970) {
        if (year > mininumComponents.year) {
            [self selectRow:((year - [self yearOffset]) - 1) inComponent:MTZYearComponent animated:YES];
        } else {
            [self selectRow:(maximumComponents.month - 1) inComponent:MTZMonthComponent animated:YES];
        }
    } else if (attemptDate.timeIntervalSince1970 < self.minimumDate.timeIntervalSince1970) {
        if (mininumComponents.year < maximumComponents.year) {
            [self selectRow:((year - [self yearOffset]) + 1) inComponent:MTZYearComponent animated:YES];
        } else {
            [self selectRow:(mininumComponents.month - 1) inComponent:MTZMonthComponent animated:YES];
        }
    }
}

- (void)updateMonthComponentForYearIfNeeded:(NSInteger)year {
    NSInteger mininumMonth = [[self pickerCalendar] component:NSCalendarUnitMonth fromDate:self.minimumDate];
    NSInteger maximumMonth = [[self pickerCalendar] component:NSCalendarUnitMonth fromDate:self.maximumDate];
    NSInteger month = [self selectedRowInComponent:MTZMonthComponent] + 1;
    NSDate *attemptDate = [self dateFromMonth:month year:year];
    if (attemptDate.timeIntervalSince1970 > self.maximumDate.timeIntervalSince1970) {
        [self selectRow:(maximumMonth - 1) inComponent:MTZMonthComponent animated:YES];
    } else if (attemptDate.timeIntervalSince1970 < self.minimumDate.timeIntervalSince1970) {
        [self selectRow:(mininumMonth - 1) inComponent:MTZMonthComponent animated:YES];
    }
}

- (void)addSlashLabel {
    self.showsSeparator = YES;
    self.labelSeparator = [UILabel new];
    self.labelSeparator.translatesAutoresizingMaskIntoConstraints = NO;
    self.labelSeparator.textAlignment = NSTextAlignmentCenter;
    self.labelSeparator.text = @"/";
    self.labelSeparator.font = [UIFont systemFontOfSize:21];
    self.labelSeparator.userInteractionEnabled = NO;
    [self addSubview:self.labelSeparator];
    [self.labelSeparator.centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:12].active = YES;
    [self.labelSeparator.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:-1].active = YES;
}

@end
