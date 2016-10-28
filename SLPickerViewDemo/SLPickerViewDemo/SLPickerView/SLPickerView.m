//
//  SLPickerView.m
//  SLPickerViewDemo
//
//  Created by 浮生若梦 on 2016/10/28.
//  Copyright © 2016年 Ls. All rights reserved.
//  通用选择器

#import "SLPickerView.h"

@interface SLPickerView ()

@end

@implementation SLPickerView

#pragma mark - LifeStyle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.backgroundView];
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.toolBarView];
        [self.toolBarView addSubview:self.leftButton];
        [self.toolBarView addSubview:self.rightButton];
        [self.toolBarView addSubview:self.barTopLine];
        [self.toolBarView addSubview:self.barBottomLine];
        [self.contentView addSubview:self.pickerView];
        
        self.barHeight = 84 / 2;
        self.pickerHeight = 530 / 2;
        self.buttonMargin = 24 / 2;
        self.bgAlpha = 0.3;
    }
    
    return self;
}

#pragma mark - 懒加载
- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [UIColor blackColor];
        _backgroundView.alpha = self.bgAlpha;
        
        _backgroundView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBackgroundViewTouch)];
        [_backgroundView addGestureRecognizer:tap];
    
    }
    
    return _backgroundView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    
    return _contentView;
}

- (UIView *)toolBarView {
    if (!_toolBarView) {
        _toolBarView = [[UIView alloc] init];
        _toolBarView.backgroundColor = [UIColor whiteColor];
    }
    
    return _toolBarView;
}

- (UIView *)barTopLine {
    if (!_barTopLine) {
        _barTopLine = [[UIView alloc] init];
        _barTopLine.backgroundColor = [UIColor lightGrayColor];
    }
    
    return _barTopLine;
}

- (UIView *)barBottomLine {
    if (!_barBottomLine) {
        _barBottomLine = [[UIView alloc] init];
        _barBottomLine.backgroundColor = [UIColor lightGrayColor];
    }
    
    return _barBottomLine;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [self createButtonWithTitle:@"取消"];
        [_leftButton addTarget:self action:@selector(onLeftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _leftButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [self createButtonWithTitle:@"确定"];
        [_rightButton addTarget:self action:@selector(onRightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _rightButton;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    
    return _pickerView;
}

- (UIButton *)createButtonWithTitle:(NSString *)title {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    return btn;
}

#pragma mark - UI
- (void)layoutSubviews {
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    self.backgroundView.frame = self.bounds;
    
    CGFloat contentHeight = self.barHeight + self.pickerHeight;
    self.contentView.frame = CGRectMake(0, height - contentHeight, width, contentHeight);
    
    self.toolBarView.frame = CGRectMake(0, 0, width, self.barHeight);
    
    [self.leftButton sizeToFit];
    CGFloat leftButtonWidth = CGRectGetWidth(self.leftButton.frame) + self.buttonMargin * 2;
    self.leftButton.frame = CGRectMake(0, 0, leftButtonWidth, self.barHeight);
    
    [self.rightButton sizeToFit];
    CGFloat rightButtonWidth = CGRectGetWidth(self.rightButton.frame) + self.buttonMargin * 2;
    self.rightButton.frame = CGRectMake(width - rightButtonWidth, 0, rightButtonWidth, self.barHeight);
    
    self.barTopLine.frame = CGRectMake(0, 0, width, 0.5);
    self.barBottomLine.frame = CGRectMake(0, self.barHeight - 0.5, width, 0.5);
    
    self.pickerView.frame = CGRectMake(self.pickerMargin, self.barHeight, width - self.pickerMargin * 2, self.pickerHeight);
    [self.pickerView setNeedsLayout];
    [self.pickerView setNeedsDisplay];
}

#pragma mark - public method
- (BOOL)isShowing {
    return CGRectGetMinY(self.contentView.frame) < CGRectGetHeight(self.frame);
}

- (void)showInView:(UIView *)view {
    self.frame =  view.bounds;
    [view addSubview:self];//调用layoutSubviews计算布局
    
    CGRect contentFrame = self.contentView.frame;
    contentFrame.origin.y = CGRectGetHeight(self.frame);
    self.contentView.frame = contentFrame;
    self.backgroundView.alpha = 0;
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.contentView.frame;
        frame.origin.y = CGRectGetHeight(self.frame) - (self.barHeight + self.pickerHeight);
        self.contentView.frame = frame;
        
        self.backgroundView.alpha = self.bgAlpha;
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.25 animations:^{
        CGRect contentFrame = self.contentView.frame;
        contentFrame.origin.y = CGRectGetHeight(self.frame);
        self.contentView.frame = contentFrame;
        self.backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Action
- (void)onBackgroundViewTouch {
    [self hide];
}

- (void)onLeftButtonClick {
    [self hide];
    if (self.actionOnLeftButton) {
        self.actionOnLeftButton(self);
    }
}

- (void)onRightButtonClick {
    [self hide];
    if (self.actionOnRightButton) {
        self.actionOnRightButton(self);
    }
}

// 由子类实现具体数据源
#pragma mark - <UIPickerViewDataSource>
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 0;
}

#pragma mark - <UIPickerViewDelegate>
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return nil;
}
@end
