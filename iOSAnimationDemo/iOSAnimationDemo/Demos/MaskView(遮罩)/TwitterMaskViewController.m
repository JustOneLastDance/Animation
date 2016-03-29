//
//  TwitterMaskViewController.m
//  iOSAnimationDemo
//
//  Created by Raymone on 16/3/16.
//  Copyright © 2016年 Mekingo8. All rights reserved.
//

#import "TwitterMaskViewController.h"

@interface TwitterMaskViewController ()

@property(nonatomic, weak) UIView *whiteView;
@property(nonatomic, weak) UIView *bgImageView;

@end

@implementation TwitterMaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    1.1View中添加一个imageView模拟界面
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    bgImageView.image = [UIImage imageNamed:@"girl.jpg"];
    self.bgImageView = bgImageView;
    [self.view addSubview:bgImageView];
    
    
    //1.2在bgimageView家上一层白色的View，让mask显示白色View
    UIView *whiteView = [[UIView alloc]initWithFrame:self.view.frame];
    [whiteView setBackgroundColor:[UIColor whiteColor]];
    [self.bgImageView addSubview:whiteView];
    [self.view bringSubviewToFront:whiteView];
    self.whiteView = whiteView;
    
    //    2.透过遮罩显示的背景色的View
    [self.view setBackgroundColor:[UIColor orangeColor]];
    
    //    3.设置mask图片
    self.bgImageView.layer.mask = [[CALayer alloc]init];
    self.bgImageView.layer.mask.contents = (__bridge id _Nullable)([UIImage imageNamed:@"apple"].CGImage);
    
    //    4.添加遮罩层
    self.bgImageView.layer.mask.position = self.view.center;
    self.bgImageView.layer.mask.bounds = CGRectMake( 0, 0, 100,100);
    //    6.延迟执行动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self animation];
    });
    
    
    
}

// 5.动画方法
- (void)animation{
    //    5.1创建关键动画
    CAKeyframeAnimation *transformAnimation = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    transformAnimation.delegate  =self;
    
    //5.2遮罩层执行时间
    transformAnimation.duration = 2;
    
    //5.3设置所有延时的地方统一时间
    CGFloat delayTime = 0.8;
    
    //5.4mask缩放后等待时间
    transformAnimation.beginTime = CACurrentMediaTime() + delayTime;
    
    //5.5设置初始大小 ，过渡大小 ，最终大小
    NSValue *initalBounds = [NSValue valueWithCGRect:self.bgImageView.layer.mask.bounds];
    NSValue *secondBounds = [NSValue valueWithCGRect:CGRectMake(0, 0, 75, 75)];
    NSValue *finalBounds = [NSValue valueWithCGRect:CGRectMake(0, 0, 1800, 1800)];
    
    transformAnimation.values = @[initalBounds,secondBounds,finalBounds];
    
    transformAnimation.keyTimes = @[@0,@0.5,@1];     //可选方法，没看懂是什么意思，参数如左则没有太大变化
    //    5.6动画样式
    transformAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    
    //5.7动画结束后是否移除，缺省为YES
    //注意：此处一定要设置NO，否则动画执行完毕后会变成开始时的样子
    transformAnimation.removedOnCompletion = NO;
    
    //5.8配合上面的使用，如果用kCAFillModeBackwards，或者不设置（缺省为remove）也会变成开始的样子
    //可以用kCAFillModeBoth和kCAFillModeForwards
    transformAnimation.fillMode = kCAFillModeBoth;
    //5.9把动画添加到layer上
    [self.bgImageView.layer.mask addAnimation:transformAnimation forKey:@"maskAnimation"];
    
    /** 5.10底部view的放大 还原动画
     *  animateWithDuration : 执行时间
     *  delay :执行前的延迟时间
     */
    [UIView animateWithDuration:0.5 delay:delayTime options:UIViewAnimationOptionTransitionNone animations:^{
        self.bgImageView.transform = CGAffineTransformMakeScale(1.05, 1.05);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.bgImageView.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
    
    //    5.11中间背景View的淡出动画
    [UIView animateWithDuration:2 delay:delayTime options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.whiteView.alpha = 0.0;
    } completion:^(BOOL finished){
        [self.whiteView removeFromSuperview];
        self.bgImageView.layer.mask = nil;
    }];
    
}


@end
