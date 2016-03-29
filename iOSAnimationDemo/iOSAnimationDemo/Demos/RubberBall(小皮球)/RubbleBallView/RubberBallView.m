//
//  RubberBallView.m
//  iOSAnimationDemo
//
//  Created by  justinchou on 16/3/17.
//  Copyright © 2016年 Mekingo8. All rights reserved.
//

#import "RubberBallView.h"

@implementation RubberBallView

/// 重定义了自身的layer类型为RubberBallView
+ (Class)layerClass{
    return [RubbleBallLayer class];
}
/// 初始化方法
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.rubberBallLayer = [RubbleBallLayer layer];
        self.rubberBallLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.rubberBallLayer.contentsScale = [UIScreen mainScreen].scale;
        [self.layer addSublayer:self.rubberBallLayer];
    }
    return self;
}

@end
