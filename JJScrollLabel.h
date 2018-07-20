//
//  JJScrollLabel.h
//  ProjectDemo
//
//  Created by 远方 on 2017/9/25.
//  Copyright © 2017年 远方. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJScrollLabel : UIScrollView

@property (nonatomic, assign) CGFloat scrollSpeed;//速度
@property (nonatomic, strong) UIColor *textColor;//颜色
@property (nonatomic, strong) UIFont *font;//字体
@property (nonatomic, strong) UIColor *bgroundColor;//背景色
@property (nonatomic, copy) NSString *text;//内容
@property (nonatomic, copy) NSArray *array;//多条内容

@end
