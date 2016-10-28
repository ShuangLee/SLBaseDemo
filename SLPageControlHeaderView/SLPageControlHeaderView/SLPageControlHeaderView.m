//
//  SLPageControlHeaderView.m
//  SLPageControlHeaderView
//
//  Created by 浮生若梦 on 2016/10/28.
//  Copyright © 2016年 Ls. All rights reserved.
//

#import "SLPageControlHeaderView.h"

@interface SLPageControlHeaderView ()
@property (nonatomic, strong) NSMutableArray<UILabel *> *itemArray;
@property (nonatomic, strong) UIView *underLine;
@property (atomic, assign) BOOL didFirstLayout;
@end

@implementation SLPageControlHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.font = [UIFont systemFontOfSize:15];
        self.normalTextColor = [UIColor colorWithWhite:0.33 alpha:1.0];
        self.selectedTextColor = [UIColor orangeColor];
        self.underLineColor = [UIColor orangeColor];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!self.didFirstLayout) {
        self.didFirstLayout = YES;
        [self reBuildViews];
    }
}

- (void)reBuildViews {
    [self.itemArray enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.itemArray removeAllObjects];
    
    // 项数
    NSInteger numberOfItems = self.headerArray.count;
    if (numberOfItems == 0) {
        return;
    }
    
    // 项
    CGFloat selfWidth = CGRectGetWidth(self.bounds);
    CGFloat selfHeight = CGRectGetHeight(self.bounds);
    CGFloat itemWidth = selfWidth / numberOfItems;
    for (NSInteger index = 0; index < numberOfItems; index ++) {
        CGFloat x = index * itemWidth;
        UILabel *item = [self generateItemWithIndex:index];
        item.frame = CGRectMake(x, 0, itemWidth, selfHeight);
        [self addSubview:item];
        [self.itemArray addObject:item];
    }
    
    // 下划线
    self.underLine.backgroundColor = self.underLineColor;
    [self addSubview:self.underLine];
    
    [self reloadData];
}

- (void)reloadData {
    if (self.itemArray.count == 0) {
        return;
    }
    
    // 项
    for (NSInteger index = 0; index < self.itemArray.count; index ++) {
        UILabel *item = self.itemArray[index];
        item.textColor = (index == self.selectedIndex) ? self.selectedTextColor : self.normalTextColor;
    }
    
    if (self.selectedIndex > self.itemArray.count - 1) {
        return;
    }
    
    // 下划线
    UILabel *selectedItem = self.itemArray[self.selectedIndex];
    CGFloat underLineHeight = 3;
    self.underLine.frame = CGRectMake(CGRectGetMinX(selectedItem.frame),
                                      CGRectGetMaxY(selectedItem.frame) - underLineHeight,
                                      CGRectGetWidth(selectedItem.frame),
                                      underLineHeight);
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    
    if (self.actionOnTouchItem) {
        self.actionOnTouchItem(selectedIndex);
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self reloadData];
    }];
}

- (UILabel *)generateItemWithIndex:(NSInteger)index {
    UILabel *item = [[UILabel alloc] init];
    item.backgroundColor = self.backgroundColor;
    item.textAlignment = NSTextAlignmentCenter;
    item.text = self.headerArray[index];
    item.font = self.font;
    item.tag = index;
    
    item.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onItem:)];
    [item addGestureRecognizer:tap];
    return item;
}

- (void)onItem:(UITapGestureRecognizer *)tap {
    NSInteger index = tap.view.tag;
    self.selectedIndex = index;
    
    if (self.actionOnTouchItem) {
        self.actionOnTouchItem(index);
    }
}

- (UIView *)underLine {
    if (!_underLine) {
        _underLine = [[UIView alloc] init];
    }
    return _underLine;
}

- (NSMutableArray<UILabel *> *)itemArray {
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}

@end
