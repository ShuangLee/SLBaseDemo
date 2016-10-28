//
//  SLPickerView.h
//  SLPickerViewDemo
//
//  Created by 浮生若梦 on 2016/10/28.
//  Copyright © 2016年 Ls. All rights reserved.
//  通用选择器
/*
    由子类去具体实现具体的样式的选择器
 */
#import <UIKit/UIKit.h>

@interface SLPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *toolBarView;
@property (nonatomic, strong) UIView *barTopLine;
@property (nonatomic, strong) UIView *barBottomLine;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, assign) CGFloat buttonMargin;
@property (nonatomic, assign) CGFloat barHeight;
@property (nonatomic, assign) CGFloat pickerHeight;
@property (nonatomic, assign) CGFloat bgAlpha;
@property (nonatomic, assign) CGFloat pickerMargin;

/// 是否正显示
@property (nonatomic, assign, readonly) BOOL isShowing;

/// 点击左按钮
@property (nonatomic, copy) void (^actionOnLeftButton)(SLPickerView *__weak picker);
/// 点击右按钮
@property (nonatomic, copy) void (^actionOnRightButton)(SLPickerView *__weak picker);

- (void)showInView:(UIView *)view;

- (void)hide;

- (void)onLeftButtonClick;

- (void)onRightButtonClick;
@end
