//
//  ThreeDView.m
//  iOSAnimationDemo
//
//  Created by Mekingo8 on 16/3/16.
//  Copyright © 2016年 Mekingo8. All rights reserved.
//
//  详解CALayer 和 UIView的区别和联系 http://www.jianshu.com/p/079e5cf0f014

#import "ThreeDView.h"

@interface ThreeDView()

// 图片视图
@property(nonatomic, strong) UIImageView *cardImageView;
// 表层遮盖视图
@property(nonatomic, strong) UIImageView *cardParallaxView;

@end

@implementation ThreeDView

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    
    [self setupUI];
    
    return self;
}

- (void)setupUI {

//    CALayer 的一些重要属性:
//    shadowPath : 设置 CALayer 阴影(shodow)的位置
//    shadowOffset : shadow 在 X 和 Y 轴 上延伸的方向，即 shadow 的大小
//    shadowOpacity : shadow 的透明效果
//    shadowRadius : shadow 的渐变距离，从外围开始，往里渐变 shadowRadius 距离
//    masksToBounds : 很重要的属性，可以用此属性来防止子元素大小溢出父元素，如若防止溢出，请设为 true
//    borderWidth 和 boarderColor : 边框颜色和宽度，很常用
//    bounds : 对于我来说比较难的一个属性，测了半天也没完全了解，只知道可以用来控制 UIView 的大小，但是不能控制 位置
//    opacity : UIView 的透明效果
//    cornerRadius : UIView 的圆角
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 10);
    self.layer.shadowRadius = 10.0f;
    self.layer.shadowOpacity = 0.3f;
    //防溢出代码，建议看一下效果
//    self.layer.masksToBounds = YES;
    
    self.cardImageView = [[UIImageView alloc]initWithFrame:self.bounds];
    self.cardImageView.image = [UIImage imageNamed:@"3DCardImage"];
    self.cardImageView.layer.cornerRadius = 5.0f;
    self.cardImageView.clipsToBounds = YES;
    [self addSubview:self.cardImageView];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panImage:)];
    [self addGestureRecognizer:panGesture];
}

// 拖动图片
- (void)panImage:(UIPanGestureRecognizer *)panGesture {

    // 获取在相对该视图的触摸点位置（注意：触摸点超出视图时，仍能计算位置）
    CGPoint touchPoint = [panGesture locationInView:self];
    
    // 一旦开始拖拽
    if (panGesture.state == UIGestureRecognizerStateChanged) {
        
        // 获取触摸点相对中心点的位置比例，并取值范围控制在[-1,1]
        CGFloat x_factor = MIN(1, MAX(-1, (touchPoint.x - self.bounds.size.width/2) / (self.bounds.size.width/2)));
        CGFloat y_factor = MIN(1, MAX(-1, (touchPoint.y - self.bounds.size.height/2) / (self.bounds.size.height/2)));
        
        // 对比代码
//        CGFloat x_factor = (touchPoint.x - self.bounds.size.width/2) / (self.bounds.size.width/2);
//        CGFloat y_factor = (touchPoint.y - self.bounds.size.height/2) / (self.bounds.size.height/2);
        
        NSLog(@"x:%f y:%f", x_factor, y_factor);
        [UIView animateWithDuration:0.1 animations:^{
            self.cardImageView.layer.transform = [self transformWithM34:1.0/-500 xf:x_factor yf:y_factor];
        }];
        
    } else if(panGesture.state == UIGestureRecognizerStateEnded){
        NSLog(@"拖动结束");
        [UIView animateWithDuration:0.3 animations:^{
            self.cardImageView.layer.transform = CATransform3DIdentity;
        }];
    }
}

- (CATransform3D )transformWithM34:(CGFloat)m34 xf:(CGFloat)xf yf:(CGFloat)yf {
    
    //CATransform3DIdentity 是单位矩阵，该矩阵没有缩放，旋转，歪斜，透视。该矩阵应用到图层上，就是设置默认值.
    CATransform3D t = CATransform3DIdentity;
    
    // m34 = -1/z中，当z为正的时候，是我们人眼观察现实世界的效果，即在投影平面上表现出近大远小的效果，z越靠近原点则这种效果越明显，越远离原点则越来越不明显，当z为正无穷大的时候，则失去了近大远小的效果，此时投影线垂直于投影平面，也就是视点在无穷远处，CATransform3D中m34的默认值为0，即视点在无穷远处
    // 可以想象为，一本书在眼前很近处前后旋转，或在一定距离处前后旋转的 -> 视觉效果
    t.m34 = m34;
    
    //    CATransform3DRotate(CATransform3D t, CGFloat angle, CGFloat x, CGFloat y, CGFloat z);
    //    t：就是上一个函数。其他的都一样。就可以理解为：函数的叠加，效果的叠加
    //    angle：旋转的弧度，所以要把角度转换成弧度：角度 * M_PI / 180。
    //    x：向X轴方向旋转。值范围-1 --- 1之间
    //    y：向Y轴方向旋转。值范围-1 --- 1之间
    //    z：向Z轴方向旋转。值范围-1 --- 1之间
    t = CATransform3DRotate(t, M_PI/9 * xf, 0, 1, 0);
    t = CATransform3DRotate(t, M_PI/9 * yf, -1, 0, 0);
    
    return t;
}

@end
