//
//  FireworkButton.m
//  iOSAnimationDemo
//
//  Created by BrianLee on 16/3/17.
//  Copyright © 2016年 Mekingo8. All rights reserved.
//

#import "FireworkButton.h"

@interface FireworkButton()
//粒子效果器
@property (nonatomic, strong) CAEmitterLayer *fireworkLayer;

@end

@implementation FireworkButton{
    BOOL _selected;
}
-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    [self popInsideWithDuration:0.4];
    [self setImage:[UIImage imageNamed:@"Like"] forState:UIControlStateNormal];
    _selected = NO;
    self.clipsToBounds = NO;
    [self addTarget:self action:@selector(handleButtonPress:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)handleButtonPress:(id)sender {
    _selected = !_selected;
    if (_selected) {
        [self popOutsideWithDuration:0.5];
        [self setImage:[UIImage imageNamed:@"Like-Blue"] forState:UIControlStateNormal];
        [self animate];
    }
    else {
        [self popInsideWithDuration:0.4];
        [self setImage:[UIImage imageNamed:@"Like"] forState:UIControlStateNormal];
    }
}
-(void)didMoveToWindow{
    [super didMoveToWindow];
    if (_fireworkLayer == nil){
        [self setupEmitter];
        //      [self testImageDraw];
    }
}

///** `emitterShape' values. **/ 发射源形状
//CA_EXTERN NSString * const kCAEmitterLayerPoint 点状
//CA_EXTERN NSString * const kCAEmitterLayerLine  现状
//CA_EXTERN NSString * const kCAEmitterLayerRectangle
//CA_EXTERN NSString * const kCAEmitterLayerCuboid
//CA_EXTERN NSString * const kCAEmitterLayerCircle
//CA_EXTERN NSString * const kCAEmitterLayerSphere

///** `emitterMode' values. **/  发射模式
//CA_EXTERN NSString * const kCAEmitterLayerPoints
//CA_EXTERN NSString * const kCAEmitterLayerOutline
//CA_EXTERN NSString * const kCAEmitterLayerSurface
//CA_EXTERN NSString * const kCAEmitterLayerVolume

///** `renderMode' values. **/    渲染模式
//CA_EXTERN NSString * const kCAEmitterLayerUnordered
//CA_EXTERN NSString * const kCAEmitterLayerOldestFirst
//CA_EXTERN NSString * const kCAEmitterLayerOldestLast
//CA_EXTERN NSString * const kCAEmitterLayerBackToFront
//CA_EXTERN NSString * const kCAEmitterLayerAdditive

-(void)setupEmitter{
    
    // 实例化粒子器
    _fireworkLayer = [CAEmitterLayer layer];
    // 设置名称
    _fireworkLayer.name = @"FireworkLayer";
    
    _fireworkLayer.emitterShape = kCAEmitterLayerCircle;
    _fireworkLayer.emitterMode = kCAEmitterLayerOutline;
    _fireworkLayer.renderMode = kCAEmitterLayerOldestFirst;
    // 发射点
    _fireworkLayer.emitterPosition = CGPointMake(CGRectGetMidX(self.bounds), self.bounds.size.height*0.5);
    // 发射点Z 3D
    _fireworkLayer.emitterZPosition = -1;
    // 发射点尺寸
    _fireworkLayer.emitterSize = CGSizeMake(self.bounds.size.width*0.25, self.bounds.size.height*0.25);
    // 默认就是NO 可以不设
    //    _fireworkLayer.masksToBounds = NO;
    
    NSMutableArray <CAEmitterCell *> *emitterCells = [NSMutableArray array];
    for (int i = 0; i < 10; ++i) {
        CAEmitterCell *fireworkCell = [CAEmitterCell emitterCell];
        fireworkCell.name = @"Spark";     //名称
        fireworkCell.alphaRange = 0.2;  //alpha 发射 时cell间 的初始aplha值差异区间
        fireworkCell.alphaSpeed = -0.8; //alpha递减速度 每秒 即每秒alpha值减一
        fireworkCell.lifetime = 0.8;        //生命时间即从出现到消失有多久
        fireworkCell.lifetimeRange = 0.3; //发射时 cell个体间的差异区间
        fireworkCell.birthRate = 500;       //每秒钟产生的个数
        fireworkCell.velocity = 40.00;    //移动速度
        fireworkCell.velocityRange = 10.00;//移动速度差异区间
        //不用256 因为白的没效果
        fireworkCell.contents = (id)[[self getACircleImageWith:[UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]] CGImage];//cell显示的内容 CGImageRef
        //        fireworkCell.scale = 0.2;  //缩放
        //        fireworkCell.scaleRange = 0.01;  //缩放差异度
        [emitterCells addObject:fireworkCell];
    }
    
    // 添加粒子cells
    _fireworkLayer.emitterCells = emitterCells.copy;
    _fireworkLayer.birthRate = 0;
    
    [self.layer addSublayer:_fireworkLayer];
    
}
// 图像绘制测试方法
-(void)testImageDraw{
    self.backgroundColor = [UIColor blackColor];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[self getACircleImageWith:[UIColor redColor]]];
    [self addSubview:imageView];
}
/// 根据颜色 生成一个有圆心向外渐变淡的圆形图片
///
/// @param color 图片颜色
///
/// @return 图片实例
-(UIImage *)getACircleImageWith:(UIColor *) color{
    
    //    [color setFill];
    //    UIRectFill(rect);
    
    
    // 取得button的短边 以计算绘制的圆图大小
    CGFloat imageWH = MIN(self.bounds.size.width, self.bounds.size.height)*0.05;
    // 计算图片大小
    CGRect rect = CGRectMake(0, 0, imageWH, imageWH);
    // 开启图片上下文
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    // 裁圆
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    [path addClip];
    
    //    NSArray *colors = [NSArray arrayWithObjects:(id)color.CGColor, nil];
    //
    //    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef) colors, locations);
    //
    
    
    /// CGContextDrawRadialGradient
    ///
    /// @param CGContextRef  context
    /// @param gradient#>    gradient       //先创造一个CGGradientRef,颜色是白,黑,location分别是0,1
    /// @param startCenter#> startCenter    //白色的起点(中心圆点)
    /// @param startRadius#> startRadius    // 起点的半径,这个值多大,中心就是多大一块纯色的白圈
    /// @param endCenter#>   endCenter      // 白色的终点(可以和起点一样,不一样的话就像探照灯一样从起点投影到这个终点,按照你的意图应该和startCenter一样
    /// @param endRadius#>   endRadius      //终点的半径, 按照你的意图应该就是从中心到周边的长
    /// @param options#>     options        //应该是 kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation
    ///
    /// @return
    // 做一个上下文引用
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 暂存上下文
    CGContextSaveGState(context);
    
    // 渐变要使用的色彩空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // 渐变点个数
    size_t num_locations = 5;
    // 渐变位置 即在渐变区域内要渐变的部分
    CGFloat locations[] = { 0.0, 0.25, 0.5, 0.75, 1.0 };
    
    //    2016-03-17 16:51:22.579 iOSAnimationDemo[12620:202151] color components 0: 0.650980
    //    2016-03-17 16:51:22.579 iOSAnimationDemo[12620:202151] color components 1: 0.764706
    //    2016-03-17 16:51:22.579 iOSAnimationDemo[12620:202151] color components 2: 0.117647
    //    2016-03-17 16:51:22.579 iOSAnimationDemo[12620:202151] color components 3: 1.000000
    //    每一个颜色都可以有一个颜色空间 可以取得RGB 和alpha?
    // 取得颜色的组件个数 对于灰度 有两个 对于RGB有四个
    NSUInteger num =CGColorGetNumberOfComponents(color.CGColor);
    // 取得颜色组件
    const CGFloat *colorComponents =CGColorGetComponents(color.CGColor);
    //        for(int i = 0; i < num; ++i) {
    //            NSLog(@"color components %d: %f", i, colorComponents[i]);
    //        }
    // 处理颜色组件下标
    int index[4] = {0, 1, 2, 3};
    if (num == 2) {
        index[1] = 0;
        index[2] = 0;
        index[3] = 1;
    }
    // 建立渐变点颜色数组
    CGFloat components[20] = {
        colorComponents[index[0]],colorComponents[index[1]],colorComponents[index[2]], colorComponents[index[3]]*0.95, // Start color
        colorComponents[index[0]],colorComponents[index[1]],colorComponents[index[2]], colorComponents[index[3]]*0.8, // Middle color
        colorComponents[index[0]],colorComponents[index[1]],colorComponents[index[2]], colorComponents[index[3]]*0.6,
        colorComponents[index[0]],colorComponents[index[1]],colorComponents[index[2]], colorComponents[index[3]]*0.3, // Start color
        colorComponents[index[0]],colorComponents[index[1]],colorComponents[index[2]], colorComponents[index[3]]*0.0, // Start color
    }; // End color
    // 建立渐变对象
    CGGradientRef gradient = CGGradientCreateWithColorComponents (colorSpace, components,
                                                                  locations, num_locations);
    // 渐变开始点 即圆心
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    // 渐变开始圆心半径 结束半径  .->)->)
    CGFloat startRadius=0, endRadius=imageWH;
    // 绘制渐变
    CGContextDrawRadialGradient (context,
                                 gradient,
                                 startPoint,
                                 startRadius,
                                 startPoint,
                                 endRadius,
                                 kCGGradientDrawsAfterEndLocation);
    
    // 恢复上下文
    CGContextRestoreGState(context);
    // 关闭颜色空间
    CGColorSpaceRelease(colorSpace);
    // 释放渐变渲染
    CGGradientRelease(gradient);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭图片上下文
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)popOutsideWithDuration:(NSTimeInterval)duration {
    __weak typeof(self) weakSelf = self;
    self.transform = CGAffineTransformIdentity;
    [UIView animateKeyframesWithDuration:duration delay:0 options:0 animations: ^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 / 3.0 animations: ^{
            typeof(self) strongSelf = weakSelf;
            strongSelf.transform = CGAffineTransformMakeScale(1.5, 1.5);
        }];
        [UIView addKeyframeWithRelativeStartTime:1/3.0 relativeDuration:1/3.0 animations: ^{
            typeof(self) strongSelf = weakSelf;
            strongSelf.transform = CGAffineTransformMakeScale(0.8, 0.8);
        }];
        [UIView addKeyframeWithRelativeStartTime:2/3.0 relativeDuration:1/3.0 animations: ^{
            typeof(self) strongSelf = weakSelf;
            strongSelf.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    } completion:nil];
}

- (void)popInsideWithDuration:(NSTimeInterval)duration {
    __weak typeof(self) weakSelf = self;
    self.transform = CGAffineTransformIdentity;
    [UIView animateKeyframesWithDuration:duration delay:0 options:0 animations: ^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 / 2.0 animations: ^{
            typeof(self) strongSelf = weakSelf;
            strongSelf.transform = CGAffineTransformMakeScale(0.8, 0.8);
        }];
        [UIView addKeyframeWithRelativeStartTime:1/2.0 relativeDuration:1/2.0 animations: ^{
            typeof(self) strongSelf = weakSelf;
            strongSelf.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    } completion:nil];
}

- (void)animate {
    //    self.chargeLayer.beginTime = CACurrentMediaTime();
    //    [self.chargeLayer setValue:@80 forKeyPath:@"emitterCells.charge.birthRate"];
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, .2 * NSEC_PER_SEC);
    dispatch_after(delay, dispatch_get_main_queue(), ^{
        [self explode];
    });
}

- (void)explode {
    self.fireworkLayer.beginTime = CACurrentMediaTime();
    [self.fireworkLayer setValue:@1 forKeyPath:@"birthRate"];
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);
    dispatch_after(delay, dispatch_get_main_queue(), ^{
        [self stop];
    });
}

- (void)stop {
    [self.fireworkLayer setValue:@0 forKeyPath:@"birthRate"];
}

@end