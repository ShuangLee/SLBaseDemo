//
//  SLDatePickerView.h
//  SLPickerViewDemo
//
//  Created by 浮生若梦 on 2016/10/28.
//  Copyright © 2016年 Ls. All rights reserved.
//

#import "SLPickerView.h"
#import "SLDatePickerModel.h"

@interface SLDatePickerView : SLPickerView
@property (nonatomic, copy) NSArray<SLDatePickerModel *> *yearArray;
// 点击确定按钮
@property (nonatomic, copy) void (^actionOnSureButton)(NSInteger year, NSInteger month);

- (void)fetchSelectedData:(void (^)(SLDatePickerModel *yearModel, SLDatePickerModel *monthModel))dataBlock;
@end
