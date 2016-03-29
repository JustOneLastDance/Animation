//
//  ProgressView.m
//  iOSAnimationDemo
//
//  Created by 付晓奎 on 16/3/17.
//  Copyright © 2016年 Mekingo8. All rights reserved.
//

#import "ProgressView.h"

@implementation ProgressView{
    //    进度条宽高
    CGFloat _progressWidth;
    CGFloat _progressHeight;
    //    纪录原来视图frame
    CGRect _originframe;
    //    动画是否在进行
    BOOL _animating;
    
    
}
#pragma mark - 初试化
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //        初始化
        _animating = NO;
        _progressWidth = 200.0f;
        _progressHeight = 30.0f;
        
        // 轻触事件
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped:)];
        [self addGestureRecognizer:tap];
    }
    return self;
    
}
#pragma mark - 私有方法
//轻触事件，变更视图为进度条视样式
-(void)tapped:(UITapGestureRecognizer *)tapped{
    //纪录原始的frame
    _originframe = self.frame;
    
    //判断是否在正在尽享动画
    if (_animating == YES) {
        return;
    }
    
    //    初始化
    //移除之前的所有动画
    for ( CALayer * subLayer in self.layer.sublayers) {
        [subLayer removeFromSuperlayer];
    }
    self.backgroundColor = [UIColor colorWithRed:0.0 green:122/255.0 blue:255/255.0 alpha:1.0];
    _animating = YES;
    //    圆角
    self.layer.cornerRadius = _progressHeight / 2;
    
    //动画
    CABasicAnimation *radiusAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    radiusAnimation.duration = 0.2f;
    radiusAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    radiusAnimation.fromValue = @(_originframe.size.height/2);
    radiusAnimation.delegate = self;
    [self.layer addAnimation:radiusAnimation forKey:@"cornerRadiusShrinkAnim"];
}

//画进度白线
-(void)progressBarAnimation{
    //画线
    CAShapeLayer *progressLayer = [CAShapeLayer layer];
    //线的路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    //    线的起点 因为有个线帽，所以要加上线帽的半径
    [path moveToPoint:CGPointMake(_progressHeight/2, self.bounds.size.height/2)];
    //    终点 同理减去线帽半径
    [path addLineToPoint:CGPointMake(self.bounds.size.width -_progressHeight/2, self.bounds.size.height/2)];
    
    progressLayer.path = path.CGPath;
    progressLayer.strokeColor = [UIColor whiteColor].CGColor;
    progressLayer.lineWidth = self.frame.size.height-6;
    //线帽
    progressLayer.lineCap = kCALineCapRound;
    
    
    /**
     *  1 keyPath = strokeStart  动画的fromValue = 0，toValue = 1
     表示从路径的0位置画到1 怎么画是按照清除开始的位置也就是清除0 一直清除到1 效果就是一条路径慢慢的消失
     2 keyPath = strokeStart  动画的fromValue = 1，toValue = 0
     表示从路径的1位置画到0 怎么画是按照清除开始的位置也就是1 这样开始的路径是空的（即都被清除掉了）一直清除到0 效果就是一条路径被反方向画出来
     3 keyPath = strokeEnd  动画的fromValue = 0，toValue = 1
     表示 这里我们分3个点说明动画的顺序  strokeEnd从结尾开始清除 首先整条路径先清除后2/3，接着清除1/3 效果就是正方向画出路径
     4 keyPath = strokeEnd  动画的fromValue = 1，toValue = 0
     效果就是反方向路径慢慢消失
     */
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 2.0f;
    pathAnimation.fromValue = @(0.0f);
    pathAnimation.toValue = @(1.0f);
    pathAnimation.delegate = self;
    //KVO 键值 区分动画
    [pathAnimation setValue:@"progressBarAnimation" forKey:@"animationName"];
    
    [progressLayer addAnimation:pathAnimation forKey:nil];
    [self.layer addSublayer:progressLayer];
}

//画对号
-(void)checkAnimation{
    
    CAShapeLayer *checkLayer = [CAShapeLayer layer];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGRect rectInCircle = CGRectInset(self.bounds, self.bounds.size.width*(1-1/sqrt(2.0))/2, self.bounds.size.width*(1-1/sqrt(2.0))/2);
    [path moveToPoint:CGPointMake(rectInCircle.origin.x + rectInCircle.size.width/9, rectInCircle.origin.y + rectInCircle.size.height*2/3)];
    
    [path addLineToPoint:CGPointMake(rectInCircle.origin.x + rectInCircle.size.width/3,rectInCircle.origin.y + rectInCircle.size.height*9/10)];
    [path addLineToPoint:CGPointMake(rectInCircle.origin.x + rectInCircle.size.width*8/10, rectInCircle.origin.y + rectInCircle.size.height*2/10)];
    
    checkLayer.path = path.CGPath;
    //填充色
    checkLayer.fillColor = [UIColor clearColor].CGColor;
    //    线色
    checkLayer.strokeColor = [UIColor whiteColor].CGColor;
    checkLayer.lineWidth = 10.0;
    //    线帽
    checkLayer.lineCap = kCALineCapRound;
    //    拐角
    checkLayer.lineJoin = kCALineJoinRound;
    [self.layer addSublayer:checkLayer];
    
    CABasicAnimation *checkAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    checkAnimation.duration = 0.3f;
    checkAnimation.fromValue = @(0.0f);
    checkAnimation.toValue = @(1.0f);
    checkAnimation.delegate = self;
    [checkLayer addAnimation:checkAnimation forKey:nil];
    
}


#pragma mark - 动画代理方法
//动画开始
-(void)animationDidStart:(CAAnimation *)anim{
    if([anim isEqual:[self.layer animationForKey:@"cornerRadiusShrinkAnim"]]){
        /**
         Duration : 时间
         delay ： 延时
         usingSpringWithDamping：弹簧动画的阻尼值，也就是相当于摩擦力的大小，该属性的值从0.0到1.0之间，越靠近0，阻尼越小，弹动的幅度越大，反之阻尼越大，弹动的幅度越小，如果大道一定程度，会出现弹不动的情况。
         initialSpringVelocity：弹簧动画的速率，或者说是动力。值越小弹簧的动力越小，弹簧拉伸的幅度越小，反之动力越大，弹簧拉伸的幅度越大。这里需要注意的是，如果设置为0，表示忽略该属性，由动画持续时间和阻尼计算动画的效果。
         options
         UIViewAnimationOptionCurveEaseInOut //时间曲线函数，由慢到快
         UIViewAnimationOptionCurveEaseIn //时间曲线函数，由慢到特别快
         UIViewAnimationOptionCurveEaseOut //时间曲线函数，由快到慢
         UIViewAnimationOptionCurveLinear //时间曲线函数，匀速
         */
        [UIView animateWithDuration:0.6f delay:0.0f usingSpringWithDamping:0.6 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.bounds = CGRectMake(0, 0, _progressWidth, _progressHeight);
        } completion:^(BOOL finished) {
            [self.layer removeAllAnimations];
            [self progressBarAnimation];
        }];
        
    }
    
    if ([anim isEqual:[self.layer animationForKey:@"cornerRadiusExpandAnim"]]){
        [UIView animateWithDuration:0.6f delay:0.0f usingSpringWithDamping:0.6 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.bounds = _originframe;
            self.backgroundColor = [UIColor colorWithRed:0.1803921568627451 green:0.8 blue:0.44313725490196076 alpha:1.0];
        } completion:^(BOOL finished) {
            [self.layer removeAllAnimations];
            [self checkAnimation];
            _animating = NO;
        }];
    }
    
}
//动画结束
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if ([[anim valueForKey:@"animationName"]isEqualToString:@"progressBarAnimation"]){
        [UIView animateWithDuration:0.3 animations:^{
            //            进度条透明动画
            for (CALayer *subLayer in self.layer.sublayers) {
                subLayer.opacity = 0.0f;
            }
        } completion:^(BOOL finished) {
            if (finished) {
                //            移除图层
                for (CALayer *subLayer in self.layer.sublayers) {
                    [subLayer removeFromSuperlayer];
                }
                
                self.layer.cornerRadius = _originframe.size.height/2;
                CABasicAnimation *radiusAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
                radiusAnimation.duration = 0.2f;
                radiusAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                radiusAnimation.fromValue = @(_progressHeight /2);
                radiusAnimation.delegate = self;
                [self.layer addAnimation:radiusAnimation forKey:@"cornerRadiusExpandAnim"];
                
            }
        }];
    }
}
@end
