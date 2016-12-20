//
//  TopTableWithMJHeaderController.m
//  SLDragToDetailPage
//
//  Created by 浮生若梦 on 2016/12/20.
//  Copyright © 2016年 Ls. All rights reserved.
//

#import "TopTableWithMJHeaderController.h"
#import "MJRefresh.h"

@interface TopTableWithMJHeaderController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIScrollView *contentView;
@property (strong, nonatomic) UITableView *topTableView;
@property (strong, nonatomic) UIWebView *webView;

@end
@implementation TopTableWithMJHeaderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.topTableView];
    [self.contentView addSubview:self.webView];
    
    [self setSubTableViewRefreshFooter];
    [self setWebViewRefreshHeader];
}
#pragma mark - Property
- (UIScrollView *)contentView
{
    
    if (!_contentView) {
        _contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _contentView.scrollEnabled = NO;
        _contentView.backgroundColor = [UIColor lightTextColor];
        _contentView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*2);
    }
    return _contentView;
}
- (UITableView *)topTableView
{
    if (!_topTableView) {
        _topTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
        _topTableView.delegate = self;
        _topTableView.dataSource = self;
        _topTableView.rowHeight = 60;
    }
    return _topTableView;
}
- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-64)];
        _webView.backgroundColor = [UIColor whiteColor];
    }
    return _webView;
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"我是第%ld个cell",indexPath.row];
    return cell;
}

#pragma mark - SetUp
- (void)setSubTableViewRefreshFooter
{
    __weak typeof(self) weakSelf = self;
    
    MJRefreshBackNormalFooter *refreshFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf.contentView scrollRectToVisible:CGRectMake(0, self.webView.frame.origin.y-64, self.view.frame.size.width, self.view.frame.size.height) animated:YES];
        
        [weakSelf.topTableView.mj_footer endRefreshing];
        [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
    }];
    
    refreshFooter.arrowView.image = nil;
    
    [refreshFooter setTitle:@"下拉去往项目信息" forState:MJRefreshStateIdle];
    [refreshFooter setTitle:@"释放到达项目信息" forState:MJRefreshStatePulling];
    [refreshFooter setTitle:@"释放到达项目信息" forState:MJRefreshStateRefreshing];
    [refreshFooter setTitle:@"释放到达项目信息" forState:MJRefreshStateWillRefresh];
    [refreshFooter setTitle:@"下拉去往项目信息" forState:MJRefreshStateNoMoreData];
    // 隐藏状态
    //    refreshFooter.stateLabel.hidden = YES;
    self.topTableView.mj_footer = refreshFooter;
    
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
