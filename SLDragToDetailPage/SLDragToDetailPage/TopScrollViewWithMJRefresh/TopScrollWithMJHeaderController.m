//
//  TopScrollWithMJHeaderController.m
//  SLDragToDetailPage
//
//  Created by 浮生若梦 on 2016/12/20.
//  Copyright © 2016年 Ls. All rights reserved.
//

#import "TopScrollWithMJHeaderController.h"
#import "MJRefresh.h"

@interface TopScrollWithMJHeaderController ()

@property (nonatomic, strong) UIScrollView *contentView;
@property (strong, nonatomic) UIScrollView *topScrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIWebView *webView;

@end

@implementation TopScrollWithMJHeaderController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.topScrollView];
    [self.contentView addSubview:self.webView];
    [self.topScrollView addSubview:self.imageView];
    [self setTopScrollViewRefreshFooter];
    [self setWebViewRefreshHeader];
}

#pragma mark - Property
- (UIScrollView *)contentView {
    if (!_contentView) {
        _contentView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _contentView.scrollEnabled = NO;
        _contentView.backgroundColor = [UIColor lightGrayColor];
        _contentView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height * 2);
    }
    
    return _contentView;
}
- (UIScrollView *)topScrollView
{
    if (!_topScrollView) {
        _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
        _topScrollView.scrollEnabled = YES;
        
    }
    return _topScrollView;
}
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.topScrollView.bounds];
        _imageView.image = [UIImage imageNamed:@"userIcon"];
    }
    return _imageView;
}
- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-64)];
        _webView.backgroundColor = [UIColor whiteColor];
    }
    return _webView;
}
#pragma mark - SetUp
- (void)setTopScrollViewRefreshFooter
{
    _topScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height-64);
    
    __weak typeof(self) weakSelf = self;
    
    MJRefreshBackNormalFooter *refreshFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf.contentView scrollRectToVisible:CGRectMake(0, self.webView.frame.origin.y-64, self.view.frame.size.width, self.view.frame.size.height) animated:YES];
        
        [weakSelf.topScrollView.mj_footer endRefreshing];
        [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.bing.com"]]];
    }];
    
    refreshFooter.arrowView.image = nil;
    
    [refreshFooter setTitle:@"下拉去往项目信息" forState:MJRefreshStateIdle];
    [refreshFooter setTitle:@"释放到达项目信息" forState:MJRefreshStatePulling];
    [refreshFooter setTitle:@"释放到达项目信息" forState:MJRefreshStateRefreshing];
    [refreshFooter setTitle:@"释放到达项目信息" forState:MJRefreshStateWillRefresh];
    [refreshFooter setTitle:@"下拉去往项目信息" forState:MJRefreshStateNoMoreData];
    // 隐藏状态
    //    refreshFooter.stateLabel.hidden = YES;
    self.topScrollView.mj_footer = refreshFooter;
    
}
- (void)setWebViewRefreshHeader
{
    __weak typeof(self) weakSelf = self;
    
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.contentView scrollRectToVisible:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) animated:YES];
        [weakSelf.webView.scrollView.mj_header endRefreshing];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    [refreshHeader setTitle:@"下拉回到项目详情" forState:MJRefreshStateIdle];
    [refreshHeader setTitle:@"释放回到项目详情" forState:MJRefreshStatePulling];
    [refreshHeader setTitle:@"释放回到项目详情" forState:MJRefreshStateRefreshing];
    [refreshHeader setTitle:@"释放回到项目详情" forState:MJRefreshStateWillRefresh];
    [refreshHeader setTitle:@"下拉回到项目详情" forState:MJRefreshStateNoMoreData];
    
    self.webView.scrollView.mj_header = refreshHeader;
}

@end
