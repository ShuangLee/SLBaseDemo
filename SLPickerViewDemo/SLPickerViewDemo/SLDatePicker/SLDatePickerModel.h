//
//  SLDatePickerModel.h
//  SLPickerViewDemo
//
//  Created by 浮生若梦 on 2016/10/28.
//  Copyright © 2016年 Ls. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLDatePickerModel : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, copy) NSArray<SLDatePickerModel *> *modelArray;
@end
