//
//  ViewController.m
//  AppA
//
//  Created by 光头强 on 2016/10/25.
//  Copyright © 2016年 Ls. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (IBAction)fromAppAJumpToAppB:(id)sender {
    // 1. 获取AppB的URL Scheme
    NSURL *appBURL = [NSURL URLWithString:@"AppB://"];
    
    // 2. 判断手机是否安装了对应的应用
    if ([[UIApplication sharedApplication] canOpenURL:appBURL]) {
        // 3. 打开应用程序
        [[UIApplication sharedApplication] openURL:appBURL];
    } else {
        NSLog(@"跳转到app store去下载应用");
    }
}

- (IBAction)jumpToAppBPage1:(id)sender {
    // 1. 获取AppB的URL Scheme
    NSURL *appBURL = [NSURL URLWithString:@"AppB://Page1"];
    
    // 2. 判断手机是否安装了对应的应用
    if ([[UIApplication sharedApplication] canOpenURL:appBURL]) {
        // 3. 打开应用程序Page1页面
        [[UIApplication sharedApplication] openURL:appBURL];
    } else {
        NSLog(@"跳转到app store去下载应用");
    }

}

- (IBAction)jumpToAppBPage2:(id)sender {
    // 1. 获取AppB的URL Scheme
    NSURL *appBURL = [NSURL URLWithString:@"AppB://Page2"];
    
    // 2. 判断手机是否安装了对应的应用
    if ([[UIApplication sharedApplication] canOpenURL:appBURL]) {
        // 3. 打开应用程序Page2页面
        [[UIApplication sharedApplication] openURL:appBURL];
    } else {
        NSLog(@"跳转到app store去下载应用");
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
