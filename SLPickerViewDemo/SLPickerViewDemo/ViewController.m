//
//  ViewController.m
//  SLPickerViewDemo
//
//  Created by 浮生若梦 on 2016/10/28.
//  Copyright © 2016年 Ls. All rights reserved.
//

#import "ViewController.h"
#import "SLDatePickerView.h"

@interface ViewController ()
@property (nonatomic, strong) SLDatePickerView *picker;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onRightItem)];
    self.picker = [[SLDatePickerView alloc] init];
    self.picker.yearArray = [self generateYearArray];
    self.picker.actionOnSureButton = ^(NSInteger year, NSInteger month){
        NSLog(@"%ld,%ld",year,month);
    };
}

- (void)onRightItem {
    if (self.picker.isShowing) {
        [self.picker hide];
    }
    else {
        UIWindow *keyWin = [UIApplication sharedApplication].keyWindow;
        [self.picker showInView:keyWin];
    }
}

- (NSArray<SLDatePickerModel *> *)generateYearArray {
    NSMutableArray *array = [NSMutableArray array];
    SLDatePickerModel *year2014 = [self generateModelWithTitle:@"2014年" modelArray:[self generateMonthArrayFrom:1 to:12]];
    [array addObject:year2014];
    SLDatePickerModel *year2015 = [self generateModelWithTitle:@"2015年" modelArray:[self generateMonthArrayFrom:6 to:12]];
    [array addObject:year2015];
    SLDatePickerModel *year2016 = [self generateModelWithTitle:@"2016年" modelArray:[self generateMonthArrayFrom:1 to:8]];
    [array addObject:year2016];
    return array;
}

- (NSArray<SLDatePickerModel *> *)generateMonthArrayFrom:(NSInteger)from to:(NSInteger)to {
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger index = from; index <= to; index ++) {
        SLDatePickerModel *model = [self generateModelWithTitle:[NSString stringWithFormat:@"%@月", @(index)] modelArray:nil];
        [array addObject:model];
    }
    return array;
}

- (SLDatePickerModel *)generateModelWithTitle:(NSString *)title modelArray:(NSArray *)modelArray {
    SLDatePickerModel *model = [[SLDatePickerModel alloc] init];
    model.title = title;
    model.modelArray = modelArray;
    return model;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
