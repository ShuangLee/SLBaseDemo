//
//  SLDatePickerView.m
//  SLPickerViewDemo
//
//  Created by 浮生若梦 on 2016/10/28.
//  Copyright © 2016年 Ls. All rights reserved.
//

#import "SLDatePickerView.h"

@implementation SLDatePickerView {
    BOOL _didFirstLayout;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.barHeight = 80 / 2;
        self.pickerHeight = 500 / 2;
        self.buttonMargin = 30 / 2;
        self.bgAlpha = 0.3;
        self.pickerMargin = 30 / 2;
        
        [self.leftButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.rightButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.pickerView.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _didFirstLayout = YES;
}

- (void)setYearArray:(NSArray<SLDatePickerModel *> *)yearArray {
    _yearArray = yearArray;
    if (_didFirstLayout) {
        [self.pickerView reloadAllComponents];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.yearArray.count;
    }
    else if (component == 1) {
        SLDatePickerModel *yearModel = self.yearArray[[pickerView selectedRowInComponent:0]];
        return yearModel.modelArray.count;
    }
    
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 80 / 2;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return CGRectGetWidth(pickerView.frame) / 2.0;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [pickerView reloadAllComponents];
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title = nil;
    
    if (component == 0) {
        SLDatePickerModel *yearModel = self.yearArray[row];
        title = yearModel.title;
    }
    else if (component == 1) {
        SLDatePickerModel *yearModel = self.yearArray[[pickerView selectedRowInComponent:0]];
        SLDatePickerModel *monthModel = yearModel.modelArray[row];
        title = monthModel.title;
    }
    
    UIColor *color = (row == [pickerView selectedRowInComponent:component]) ? [UIColor orangeColor] : [UIColor darkGrayColor];
    NSDictionary *attr = @{NSForegroundColorAttributeName : color,
                           NSFontAttributeName : [UIFont systemFontOfSize:30 / 2]};
    return [[NSAttributedString alloc] initWithString:title attributes:attr];
}


#pragma mark - Public
- (void)fetchSelectedData:(void (^)(SLDatePickerModel *, SLDatePickerModel *))dataBlock {
    if (!self.yearArray) {
        NSLog(@"无数据源");
        dataBlock(nil, nil);
        return;
    }
    
    if ([self.pickerView numberOfComponents] < 2) {
        NSLog(@"数据不足");
        dataBlock(nil, nil);
        return;
    }
    
    SLDatePickerModel *yearModel = self.yearArray[[self.pickerView selectedRowInComponent:0]];
    SLDatePickerModel *monthModel = yearModel.modelArray[[self.pickerView selectedRowInComponent:1]];
    dataBlock(yearModel, monthModel);
}

- (void)onRightButtonClick {
    [super onRightButtonClick];
    if (self.actionOnSureButton) {
        __weak typeof(self) weakSelf = self;
        [self fetchSelectedData:^(SLDatePickerModel *yearModel, SLDatePickerModel *monthModel) {
            weakSelf.actionOnSureButton([yearModel.title integerValue], [monthModel.title integerValue]);
        }];
    }
}
@end
