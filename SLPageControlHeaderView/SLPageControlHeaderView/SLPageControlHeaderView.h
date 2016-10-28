//
//  SLPageControlHeaderView.h
//  SLPageControlHeaderView
//
//  Created by 浮生若梦 on 2016/10/28.
//  Copyright © 2016年 Ls. All rights reserved.
//  页面切换标签视图

#import <UIKit/UIKit.h>

@interface SLPageControlHeaderView : UIView
/// 标签数组
@property (nonatomic, strong) NSArray <NSString *> *headerArray;

/// 字体
@property (nonatomic, strong) UIFont *font;

/// 普通状态颜色
@property (nonatomic, copy) UIColor *normalTextColor;

/// 选中状态颜色
@property (nonatomic, copy) UIColor *selectedTextColor;

/// 下划线颜色
@property (nonatomic, copy) UIColor *underLineColor;

/// 当前选中项，赋值操作会触发actionOnTouchItem
@property (nonatomic, assign, readwrite) NSUInteger selectedIndex;

/// 选中某项时回调
@property (nonatomic, copy) void (^actionOnTouchItem)(NSInteger index);

/// 刷新数据
- (void)reloadData;

/// 重建视图
- (void)reBuildViews;
@end
