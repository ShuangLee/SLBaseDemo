//
//  TopTableViewController.m
//  SLDragToDetailPage
//
//  Created by 浮生若梦 on 2016/12/20.
//  Copyright © 2016年 Ls. All rights reserved.
//

#import "TopTableViewController.h"

@interface TopTableViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) UITableView *topScrollView;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UILabel *footLabel;
@property (nonatomic, strong) UILabel *headLabel;
@property (nonatomic, assign) CGFloat maxContentOffSet;
@end

@implementation TopTableViewController

- (void)dealloc {
    [_webView.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupContentView];
}

- (void)setupContentView {
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.topScrollView];
    [self.contentView addSubview:self.webView];
    [self.webView addSubview:self.headLabel];
    [self.topScrollView addSubview:self.footLabel];
}

#pragma mark - 懒加载
- (UIScrollView *)contentView {
    if (!_contentView) {
        _contentView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _contentView.scrollEnabled = NO;
        _contentView.backgroundColor = [UIColor lightGrayColor];
        _contentView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height * 2);
    }
    
    return _contentView;
}

- (UIScrollView *)topScrollView {
    if (!_topScrollView) {
        _topScrollView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
        _topScrollView.scrollEnabled = YES;
        _topScrollView.delegate = self;
        _topScrollView.dataSource = self;
        _topScrollView.rowHeight = 40;
        _topScrollView.tableFooterView = self.footLabel;
    }
    
    return _topScrollView;
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - 64)];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.scrollView.delegate = self;
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.jianshu.com"]]];
        
        // 监听webview的scrollView的偏移量
        [_webView.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    }
    
    return _webView;
}

- (UILabel *)footLabel {
    if (!_footLabel) {
        _footLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 64, self.view.frame.size.width, 40)];
        _footLabel.textColor = [UIColor redColor];
        _footLabel.text = @"上拉，进入详情页";
        _footLabel.textAlignment = NSTextAlignmentCenter;
        _footLabel.alpha = 1;
    }
    
    return _footLabel;
}

- (UILabel *)headLabel {
    if (!_headLabel) {
        _headLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        _headLabel.textColor = [UIColor redColor];
        _headLabel.text = @"上拉，返回顶部";
        _headLabel.textAlignment = NSTextAlignmentCenter;
        _headLabel.alpha = 0;
    }
    
    return _headLabel;
}

- (CGFloat)maxContentOffSet {
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"test-%ld",indexPath.row];
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat offsetY = scrollView.contentOffset.y;
    if ([scrollView isKindOfClass:[UITableView class]]) {
        //顶部ScrollView的滚动
        CGFloat valueNum = self.topScrollView.contentSize.height - self.view.frame.size.height;
        NSLog(@"%f",offsetY);
        if (offsetY - valueNum > _maxContentOffSet) {
            [self gotoDetail];
        }
    } else if (offsetY - _maxContentOffSet) {
        
        if(offsetY<0 && -offsetY>_maxContentOffSet)
        {
            [self backtoTop]; // 返回基本详情界面的动画
        }
    }
}

#pragma mark - 事件处理
//  进入详情
- (void)gotoDetail {
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        _webView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
        _topScrollView.frame = CGRectMake(0, -self.contentView.bounds.size.height, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}

// 返回顶部
- (void)backtoTop {
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        _topScrollView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
        _webView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - 64);
    } completion:^(BOOL finished) {
        
    }];
}

// webview头部提示文本动画
- (void)headLableAnimation:(CGFloat)offsetY {
    _headLabel.alpha = -offsetY / 60;
    _headLabel.center = CGPointMake(self.view.frame.size.width / 2, -offsetY / 2);
    
    if (-offsetY > _maxContentOffSet) {
        _headLabel.text = @"释放，返回顶部";
    } else {
        _headLabel.text = @"上拉，返回顶部";
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == _webView.scrollView && [keyPath isEqualToString:@"contentOffset"]) {
        //NSLog(@"old:%@ --- new:%@",change[@"old"],change[@"new"]);
        [self headLableAnimation:[change[@"new"] CGPointValue].y];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
