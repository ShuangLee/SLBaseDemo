//
//  ViewController.m
//  SLPageControlHeaderView
//
//  Created by 浮生若梦 on 2016/10/28.
//  Copyright © 2016年 Ls. All rights reserved.
//

#import "ViewController.h"
#import "SLPageControlHeaderView.h"
#import "SLTotalViewController.h"
#import "SLOutputViewController.h"
#import "SLInputViewController.h"

@interface ViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) SLPageControlHeaderView *headerView;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"SLPageControlHeaderView";
    // iOS7以后,导航控制器中scollView顶部会添加64的额外滚动区域
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // Layout
    CGFloat width = CGRectGetWidth(self.view.frame);
    self.headerView.frame = CGRectMake(0, 64, width, 45);
    self.headerView.headerArray = @[@"全部", @"收入", @"支出"];
    [self.view addSubview:self.headerView];
    
    [self setupContentScrollView];
    
    // 添加所有的子控制器
    [self setupAllChildViewController];
    
    // Action
    __weak typeof(self) weakSelf = self;
    [self.headerView setActionOnTouchItem:^(NSInteger index) {
        //把对应的控制器添加上去
        [weakSelf setupOneViewController:index];
        weakSelf.contentScrollView.contentOffset = CGPointMake(width * index, 0);
    }];
    
    // 默认显示第一个
    self.headerView.selectedIndex = 0;
}

- (SLPageControlHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[SLPageControlHeaderView alloc] init];
    }
    return _headerView;
}

#pragma mark - 添加所有的子控制器
- (void)setupAllChildViewController
{
    // 全部
    SLTotalViewController *vc1 = [[SLTotalViewController alloc] init];
    [self addChildViewController:vc1];
    // 收入
    SLInputViewController *vc2 = [[SLInputViewController alloc] init];
    [self addChildViewController:vc2];
    // 支出
    SLOutputViewController *vc3 = [[SLOutputViewController alloc] init];
    [self addChildViewController:vc3];
}

#pragma mark - 添加内容滚动视图
- (void)setupContentScrollView {
    UIScrollView *contentScrollView = [[UIScrollView alloc] init];
    CGFloat y = CGRectGetMaxY(self.headerView.frame);
    contentScrollView.frame = CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height - y);
    [self.view addSubview:contentScrollView];
    _contentScrollView = contentScrollView;
    
    // 设置contentScrollView的属性
    // 分页
    self.contentScrollView.pagingEnabled = YES;
    // 弹簧
    self.contentScrollView.bounces = NO;
    // 指示器
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    
    // 设置代理.目的:监听内容滚动视图 什么时候滚动完成
    self.contentScrollView.delegate = self;
    // 设置内容的滚动范围
    self.contentScrollView.contentSize = CGSizeMake(self.headerView.headerArray.count * [UIScreen mainScreen].bounds.size.width, 0);
}

#pragma mark - 添加一个子控制器的View
- (void)setupOneViewController:(NSInteger)i
{
    UIViewController *vc = self.childViewControllers[i];
    if (vc.view.superview) {
        return;
    }
    CGFloat x = i * [UIScreen mainScreen].bounds.size.width;
    vc.view.frame = CGRectMake(x, 0, [UIScreen mainScreen].bounds.size.width, self.contentScrollView.bounds.size.height);
    [self.contentScrollView addSubview:vc.view];
}

#pragma mark - UIScrollViewDelegate
// 滚动完成的时候调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 获取当前角标
    NSInteger i = scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
    
    self.headerView.selectedIndex = i;
    
    // 2.把对应子控制器的view添加上去
    [self setupOneViewController:i];
}
@end
