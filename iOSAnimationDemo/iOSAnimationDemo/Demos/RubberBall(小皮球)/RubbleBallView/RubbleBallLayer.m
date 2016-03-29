//
//  RubbleBallLayer.m
//  iOSAnimationDemo
//
//  Created by  justinchou on 16/3/16.
//  Copyright © 2016年 Mekingo8. All rights reserved.
//

#import "RubbleBallLayer.h"
#import <UIKit/UIKit.h>

#define outsideRectSize 100

/// 判断左/右移动结构体
typedef enum {
    /// 皮球左侧点
    POINT_D,
    /// 皮球右侧点
    POINT_B
} MovePoint;

@interface RubbleBallLayer ()
/// 外接正方形范围，作为皮球的参考
@property (nonatomic, assign) CGRect outsideRect;
/// 记录上一次的形变程度(进度条数值)
@property (nonatomic, assign) CGFloat lastProgress;
/// 实时记录滑动的方向 (POINT_D左 POINT_B右)
@property (nonatomic, assign) MovePoint movePiont;
@end

@implementation RubbleBallLayer
/// 初始化方法
///
/// @return 返回一个皮球（未形变）
- (instancetype)init{
    self = [super init];
    if (self) {
        //默认设置一个值，当前值=0.5为皮球未形变的样子
        self.lastProgress = 0.5;
    }
    return self;
}

/// 绘制皮球（4段弧 每段弧有4个点 画3条贝塞尔曲线来完成一段弧）以及关键坐标点,控制点
- (void)drawInContext:(CGContextRef)ctx{
    /// AC1 BC2 BC3 CC4...两点之间的距离
    //当设置为正方形边长的1/3.6倍时，画出来的圆弧完美贴合圆形（控制点发生的变化量）
    CGFloat offset = self.outsideRect.size.width / 3.6;
    
    /// ABCD的实际移动距离 系数为progress和0.5的绝对差值的2倍，最大moveDistance为outsideRect的边长的1/6
    // 4个矩形边长中心点发生的变化量
    //double fabs(double); 取模（求绝对值）
    CGFloat moveDistance = (self.outsideRect.size.width / 6) * fabs(self.progress - 0.5)*2;

    /// 计算出矩形的中心点位置，方便之后各个点的计算（origion为rect左上角点的坐标）
    CGPoint rectCenter = CGPointMake(self.outsideRect.origin.x + self.outsideRect.size.width/2, self.outsideRect.origin.y + self.outsideRect.size.height/2);
    
#pragma mark - 计算矩形边长中点上各个点的对应坐标位置
    //相对于outsideRect的中心点的变化, A点的x相对于矩形的中心点保持不变 y相对于矩形的原点发生改变
    CGPoint pointA = CGPointMake(rectCenter.x, self.outsideRect.origin.y + moveDistance);
    //B点的y相对于矩形的中心点保持不变,当运动的点为d时，那么B点不动，停留在矩形的边长中心点；如果运动的点为b，那么b会开始移动，不停留在边长中点上，能够移动的最大值为2倍的moveDistance
    CGPoint pointB = CGPointMake(self.movePiont == POINT_D ? rectCenter.x + self.outsideRect.size.width/2 : rectCenter.x + self.outsideRect.size.width/2 + 2*moveDistance, rectCenter.y);
    //运动方式同A 变化量为负
    CGPoint pointC = CGPointMake(rectCenter.x, rectCenter.y + self.outsideRect.size.height/2 - moveDistance);
    //理由同B 变化量为负
    CGPoint pointD = CGPointMake(self.movePiont == POINT_D ? self.outsideRect.origin.x - 2*moveDistance : self.outsideRect.origin.x, rectCenter.y);
    
#pragma mark - 计算每条弧上的控制点的坐标（变化的点只有 c2，3，6，7）
    //该点固定，保持不变
    CGPoint c1 = CGPointMake(pointA.x + offset, pointA.y);
    //当D点运动时，c2的x，y保持不变，只有当B点运动时，c2的y会随着moveDistance发生改变
    CGPoint c2 = CGPointMake(pointB.x, self.movePiont == POINT_D ? pointB.y - offset : pointB.y - offset + moveDistance);
    //同c2
    CGPoint c3 = CGPointMake(pointB.x, self.movePiont == POINT_D ? pointB.y + offset : pointB.y + offset - moveDistance);
    //同c1
    CGPoint c4 = CGPointMake(pointC.x + offset, pointC.y);
    //同c1
    CGPoint c5 = CGPointMake(pointC.x - offset, pointC.y);
    //当D运动时，c6的y保持不变，x发生改变，反之都不变
    CGPoint c6 = CGPointMake(pointD.x, self.movePiont == POINT_D ? pointD.y + offset - moveDistance : pointD.y + offset);
    //同c6
    CGPoint c7 = CGPointMake(pointD.x, self.movePiont == POINT_D ? pointD.y - offset + moveDistance : pointD.y - offset);
    //同c1
    CGPoint c8 = CGPointMake(pointA.x - offset, pointA.y);
    
#pragma mark - 绘制外接矩形（虚线）
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:self.outsideRect];
    //添加路径
    CGContextAddPath(ctx, rectPath.CGPath);
    //设置渲染颜色
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGFloat dash[] = {5.0, 5.0};
    /// 绘制虚线
    ///
    /// @param c#>       图形上下文
    /// @param phase#>   当绘制第一条实线时长度要减去phase
    /// @param lengths#> 数组例如 ｛10，5｝，先绘制10个点长度的实线，接下来的5个点不绘制直接隔开，继续绘制10个点的实线，再隔开5个点不绘制直接隔开，一次类推 例｛3，2｝。。。..。。。..。。。..
    /// @param count#>   lenths数组的长度
    CGContextSetLineDash(ctx, 0, dash, 2);//1
    CGContextStrokePath(ctx);
    
#pragma mark - 绘制圆的每段弧
    UIBezierPath *ovalPath = [UIBezierPath bezierPath];
    [ovalPath moveToPoint:pointA];
    //画弧需要2个控制点
    [ovalPath addCurveToPoint:pointB controlPoint1:c1 controlPoint2:c2];
    [ovalPath addCurveToPoint:pointC controlPoint1:c3 controlPoint2:c4];
    [ovalPath addCurveToPoint:pointD controlPoint1:c5 controlPoint2:c6];
    [ovalPath addCurveToPoint:pointA controlPoint1:c7 controlPoint2:c8];
    [ovalPath closePath];
    
    CGContextAddPath(ctx, ovalPath.CGPath);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    //设置填充颜色
    CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
    //!!!!!!!!此处需要使用实线，因此重新设置
    CGContextSetLineDash(ctx, 0, NULL, 0); //2
    //同时给线条和线条包围的内部区域填充颜色
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
#pragma mark - 绘制坐标点
    //标记出每个点并连线，方便观察，给所有关键点染色 -- 白色,辅助线颜色 -- 白色
    //语法糖：字典@{}，数组@[]，基本数据类型封装成对象@234，@12.0，@YES,@(234+12.0)
    CGContextSetFillColorWithColor(ctx, [UIColor blueColor].CGColor);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    NSArray *points = @[[NSValue valueWithCGPoint:pointA],
                        [NSValue valueWithCGPoint:pointB],
                        [NSValue valueWithCGPoint:pointC],
                        [NSValue valueWithCGPoint:pointD],
                        [NSValue valueWithCGPoint:c1],
                        [NSValue valueWithCGPoint:c2],
                        [NSValue valueWithCGPoint:c3],
                        [NSValue valueWithCGPoint:c4],
                        [NSValue valueWithCGPoint:c5],
                        [NSValue valueWithCGPoint:c6],
                        [NSValue valueWithCGPoint:c7],
                        [NSValue valueWithCGPoint:c8]];
    [self drawPoints:points WithContext:ctx];
    
#pragma mark - 连接辅助线
    UIBezierPath *helpPath = [UIBezierPath bezierPath];
    [helpPath moveToPoint:pointA];
    [helpPath addLineToPoint:c1];
    [helpPath addLineToPoint:c2];
    [helpPath addLineToPoint:pointB];
    [helpPath addLineToPoint:c3];
    [helpPath addLineToPoint:c4];
    [helpPath addLineToPoint:pointC];
    [helpPath addLineToPoint:c5];
    [helpPath addLineToPoint:c6];
    [helpPath addLineToPoint:pointD];
    [helpPath addLineToPoint:c7];
    [helpPath addLineToPoint:c8];
    [helpPath closePath];
    
    CGContextAddPath(ctx, helpPath.CGPath);
    CGFloat dash2[] = {2.0, 2.0};
    CGContextSetLineDash(ctx, 0, dash2, 2);
    CGContextStrokePath(ctx);
    
}
//*********************************************************************************
//ctx字面意思是上下文，你可以理解为一块全局的画布。也就是说，一旦在某个地方改了画布的一些属性，其他任何使用画布的属性的时候都是改了之后的。比如上面在 //1 中把线条样式改成了虚线，那么在下文 //2 中如果不恢复成连续的直线，那么画出来的依然是//1中的虚线样式
//*********************************************************************************

/// 为每个坐标绘制出一个点，方便观察
///
/// @param points 坐标数组
/// @param ctx    图形上下文
- (void)drawPoints:(NSArray *)points WithContext:(CGContextRef)ctx {
    for (NSValue *pointValue in points) {
        CGPoint point = [pointValue CGPointValue];
        //为每个坐标填充一个2x2像素大小的矩形
        CGContextFillRect(ctx, CGRectMake(point.x - 2, point.y - 2, 4, 4));
    }
}

#pragma mark - setter
/// 重写progress的setter方法，每当progress发生改变时就调用该方法
- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    
    //判断左/右移
    if (progress <= 0.5){
        self.movePiont = POINT_B;
        NSLog(@"B动在矩形外移动");
    } else {
        self.movePiont = POINT_D;
        NSLog(@"D动在矩形外移动");
    }
    
    self.lastProgress = progress;

    /// 矩形的x位置
    CGFloat origion_x = self.position.x - outsideRectSize/2 + (progress - 0.5)*(self.frame.size.width - outsideRectSize);
    /// 矩形的y位置
    CGFloat origion_y = self.position.y - outsideRectSize/2;
    //设置矩形绘制区域
    self.outsideRect = CGRectMake(origion_x, origion_y, outsideRectSize, outsideRectSize);
    
    //该方法和setNeedsLayout一样，都是异步执行 调用该方法会自动调用drawInContext
    //因此每当progress改变就能执行drawInContext来重新绘制皮球
    [self setNeedsDisplay];
}

@end
