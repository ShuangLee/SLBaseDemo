//
//  ViewController.m
//  SLDragToDetailPage
//
//  Created by 浮生若梦 on 2016/12/20.
//  Copyright © 2016年 Ls. All rights reserved.
//

#import "ViewController.h"
#import "TopScrollViewController.h"
#import "TopTableViewController.h"
#import "TopScrollWithMJHeaderController.h"
#import "TopTableWithMJHeaderController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self.navigationController pushViewController:[[TopScrollViewController alloc] init] animated:YES];
    } else if (indexPath.row == 1) {
        [self.navigationController pushViewController:[[TopTableViewController alloc] init] animated:YES];
    } else if (indexPath.row == 2) {
        [self.navigationController pushViewController:[[TopScrollWithMJHeaderController alloc] init] animated:YES];
    } else {
        [self.navigationController pushViewController:[[TopTableWithMJHeaderController alloc] init] animated:YES];
    }
}

@end
