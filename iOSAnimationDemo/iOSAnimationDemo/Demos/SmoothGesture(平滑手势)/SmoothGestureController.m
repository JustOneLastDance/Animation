//
//  SmoothGestureController.m
//  iOSAnimationDemo
//
//  Created by Mekingo8 on 16/3/16.
//  Copyright © 2016年 Mekingo8. All rights reserved.
//

#define screenSize [UIScreen mainScreen].bounds.size
#import "SmoothGestureController.h"
#import "SmoothView.h"

@interface SmoothGestureController (){
    
    UIImageView * _imageView;
    
    CGPoint _tmpPoint;
}

@end

@implementation SmoothGestureController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    CGFloat x = random() % 254 + 1.0;
    //    self.view.backgroundColor = [UIColor colorWithRed:x / 255.0 green:255.0 / 255.0 blue:255.0 / 255.0 alpha:1.0];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"平滑手势效果";
    
    SmoothView * imageView = [[SmoothView alloc] initWithImage:[UIImage imageNamed:@"SmoothGesture01"]];
    imageView.center = self.view.center;
    imageView.bounds = CGRectMake(0, 0, 250, 150);
    imageView.gestureView = self.view;
    
    //设置毛玻璃效果
    UIVisualEffectView * effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    [self.view addSubview:effectView];
    effectView.frame = self.view.bounds;
    [effectView.contentView addSubview:imageView];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
