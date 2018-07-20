//
//  JJScrollLabel.m
//  ProjectDemo
//
//  Created by 远方 on 2017/9/25.
//  Copyright © 2017年 远方. All rights reserved.
//

#import "JJScrollLabel.h"
#define ScrollSpeed 20
#define LabelSpace 100

@interface JJScrollLabel () <UIScrollViewDelegate> {
    UILabel *_contentText[2];//显示label
    bool _isScrolling;//是否在滚动
    float _labelSpace;//两label间距
}

@end

@implementation JJScrollLabel

#pragma mark - 初始化
- (id)init {
    self = [super init];
    if (self) {
        [self initUIView];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initUIView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUIView];
    }
    return self;
}

//初始化
- (void)initUIView {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scroll) name:UIApplicationDidBecomeActiveNotification object:nil];

    for (int i = 0; i < 2; i++) {
        _contentText[i] = [[UILabel alloc] init];
        _contentText[i].textColor = [UIColor whiteColor];
        _contentText[i].backgroundColor = [UIColor clearColor];
        [self addSubview:_contentText[i]];
    }
    
    _scrollSpeed = ScrollSpeed;
    _labelSpace = self.frame.size.width > 0 ? self.frame.size.width : LabelSpace;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.scrollEnabled = NO;
}

#pragma mark - 滚动相关配置
//滚动结束
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    _isScrolling = NO;
    if ([finished intValue] == 1 && _contentText[0].frame.size.width > self.frame.size.width) {
        [self scroll];
    }
}

//开始滚动
- (void)scroll {
    _isScrolling = YES;
    self.contentOffset = CGPointMake(0, 0);
    [UIView beginAnimations:@"scroll" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView setAnimationDuration:_contentText[0].frame.size.width / (float)self.scrollSpeed];
    self.contentOffset = CGPointMake(_contentText[0].frame.size.width + _labelSpace, 0);
    [UIView commitAnimations];
}

//根据内容等属性重置尺寸
- (void)readjustLabels {
    float offset = 0.0f;
    for (int i = 0; i < 2; i++){
        [_contentText[i] sizeToFit];
        CGPoint center = _contentText[i].center;
        center.y = self.center.y - self.frame.origin.y;
        _contentText[i].center = center;
        
        CGRect frame = _contentText[i].frame;
        frame.origin.x = offset;
        _contentText[i].frame = frame;
        
        offset += _contentText[i].frame.size.width + _labelSpace;
    }
    
    CGSize size;
    size.width = _contentText[0].frame.size.width + self.frame.size.width + _labelSpace;
    size.height = self.frame.size.height;
    self.contentSize = size;
    [self setContentOffset:CGPointMake(0,0) animated:NO];
    
    if (_contentText[0].frame.size.width > self.frame.size.width) {
        _contentText[1].hidden = NO;
        [self scroll];
    } else {
        _contentText[1].hidden = YES;
    }
}

#pragma mark - 属性的set、get方法
//设置滚动内容
- (void)setText:(NSString *)text {
    if (text.length == 0) {
        return;
    }
    if ([text isEqualToString:_contentText[0].text]){
        if (_contentText[0].frame.size.width > self.frame.size.width){
            [self scroll];
        }
    } else {
        for (int i = 0; i < 2; i++){
            _contentText[i].text = text;
        }
        [self readjustLabels];
    }
}

//设置字体颜色
- (void)setTextColor:(UIColor *)textColor {
    for (int i = 0; i < 2; i++){
        _contentText[i].textColor = textColor;
    }
}

//设置字体大小
- (void)setFont:(UIFont *)font {
    for (int i = 0; i < 2; i++){
        _contentText[i].font = font;
    }
    [self readjustLabels];
}

//设置滚动速度
- (void)setScrollSpeed:(CGFloat)scrollSpeed {
    _scrollSpeed = scrollSpeed;
    [self readjustLabels];
}

//设置背景颜色
- (void)setBgroundColor:(UIColor *)bgroundColor {
    for (int i = 0; i < 2; i++){
        _contentText[i].backgroundColor = bgroundColor;
    }
    self.backgroundColor = bgroundColor;
}

//设置多条滚动内容
- (void)setArray:(NSArray *)array {
    NSString *string;
    for (int i = 0; i < [array count]; i++) {
        if (string.length > 0) {
            string = [NSString stringWithFormat:@"%@%@%@",string,[self getString],[array objectAtIndex:i]];
        } else {
            string = [array objectAtIndex:i];
        }
    }
    self.text = string;
}

- (NSString *)getString {
    return @"               ";
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
