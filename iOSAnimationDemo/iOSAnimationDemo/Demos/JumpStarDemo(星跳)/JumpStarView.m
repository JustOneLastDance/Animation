//
//  JumpStarView.m
//  iOSAnimationDemo
//
//  Created by pb on 16/3/17.
//  Copyright © 2016年 Mekingo8. All rights reserved.
//

#import "JumpStarView.h"

#define jumpDuration 0.125
#define downDuration 0.215
@implementation JumpStarView {
    UIImageView *_starView;
    UIImageView *_shadowView;
    BOOL _isAnimating;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
// MARK: - 布局
- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_starView == nil) {
        _starView = [[UIImageView alloc] init];
        
        CGFloat starWidth = self.bounds.size.width - 10;
        CGFloat starHeight = starWidth;
        CGFloat starX = (self.bounds.size.width - starWidth) * 0.5;
        CGFloat starY = 0;
        
        _starView.frame = CGRectMake(starX, starY, starWidth, starHeight);
        
        _starView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_starView];
    }
    
    if (_shadowView == nil) {
        _shadowView = [[UIImageView alloc] init];
        CGFloat shadowWidth = 10;
        CGFloat shadowHeight = 3;
        CGFloat shadowX = (self.bounds.size.width - shadowWidth) * 0.5;
        CGFloat shadowY = self.bounds.size.height - 3;
        
        _shadowView.frame = CGRectMake(shadowX, shadowY, shadowWidth, shadowHeight);
        _shadowView.image = [UIImage imageNamed:@"shadow"];
        _shadowView.alpha = 0.4;
        [self addSubview:_shadowView];
    }
}
// 根据状态设置图片
- (void)setState:(State)state {
    _state = state;
    
    _starView.image = (state == STAR) ? _starImage : _loveImage;
}
// MARK: - 上弹动画效果
- (void)jump {
    // 确保动画执行
    if (_isAnimating == YES) {
        return;
    }
    
    _isAnimating = YES;
    // 旋转
    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    transformAnimation.fromValue = @(0);
    transformAnimation.toValue = @(M_PI_2);
    // 动画节奏 慢进慢出
    transformAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    // 跳跃
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    
    positionAnimation.fromValue = @(_starView.center.y);
    positionAnimation.toValue = @(_starView.center.y - 15);
    positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]; // 上弹应该是减速运动
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = jumpDuration;
    // 非动画时间的当前对象处理
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.removedOnCompletion = NO;
    // 设置代理才可以实现代理方法 animationDidStop:
    animationGroup.delegate = self;
    animationGroup.animations = @[transformAnimation, positionAnimation];
    
    [_starView.layer addAnimation:animationGroup forKey:@"jumpUp"];
    
}
// 下落动画
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    // 切换图像
    // 根据layer的Key判断动画
    if ([anim isEqual:[_starView.layer animationForKey:@"jumpUp"]]) {
        self.state = (self.state == STAR) ? LOVE : STAR;
        // 旋转
        CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
        transformAnimation.fromValue = @(M_PI_2);
        transformAnimation.toValue = @(M_PI);
        
        // 动画节奏 慢进慢出
        transformAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        // 跳跃
        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
        
        positionAnimation.fromValue = @(_starView.center.y - 15);
        positionAnimation.toValue = @(_starView.center.y);
        positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]; // 下落是加速运动
        
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationGroup.duration = downDuration;
        // 非动画时间的当前对象处理
        animationGroup.fillMode = kCAFillModeForwards;
        animationGroup.removedOnCompletion = NO;
        // 设置代理才可以实现代理方法 animationDidStop:
        animationGroup.delegate = self;
        animationGroup.animations = @[transformAnimation, positionAnimation];
        
        [_starView.layer addAnimation:animationGroup forKey:@"jumpDown"];
        
    } else if ([anim isEqual:[_starView.layer animationForKey:@"jumpDown"]]) {
        // 下落的时候 移除layer层所有动画 确保图片保持正面
        [_starView.layer removeAllAnimations];
        // 重置动画判断
        _isAnimating = NO;
    }
}
// 阴影动画
- (void)animationDidStart:(CAAnimation *)anim {
    // 根据动画Key来判断
    if ([anim isEqual:[_starView.layer animationForKey:@"jumpUp"]]) {
        
        [UIView animateWithDuration:jumpDuration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            _shadowView.bounds = CGRectMake(0, 0, _shadowView.bounds.size.width * 1.6, _shadowView.bounds.size.height);
            
            _shadowView.alpha = 0.2;
            
        } completion:NULL];
        
    } else if ([anim isEqual:[_starView.layer animationForKey:@"jumpDown"]]) {
        
        [UIView animateWithDuration:downDuration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            _shadowView.bounds = CGRectMake(0, 0, _shadowView.bounds.size.width / 1.6, _shadowView.bounds.size.height);
            
            _shadowView.alpha = 0.4;
            
        } completion:NULL];
    }
}

@end
