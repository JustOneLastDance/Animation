//
//  SnowViewController.m
//  iOSAnimationDemo
//
//  Created by Mekingo8 on 16/3/16.
//  Copyright © 2016年 Mekingo8. All rights reserved.
//

#import "SnowViewController.h"

@interface SnowViewController ()

@property (nonatomic, strong) CAEmitterLayer *snowEmitter;

@end

@implementation SnowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self creatButton];
}
//设置背景图片
- (void)setupUI {
    UIImage *image = [UIImage imageNamed:@"Christmas House"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];

}

//创建底部开始动画和结束动画按钮
- (void)creatButton{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat buttonW = 80;
    CGFloat buttonH = 30;
    
    UIButton *startButton = [[UIButton alloc]initWithFrame:CGRectMake(screenSize.width-buttonW,screenSize.height - 2*buttonH - 10,buttonW , buttonH)];
    UIButton *endButton = [[UIButton alloc]initWithFrame:CGRectMake(screenSize.width-buttonW, screenSize.height - buttonH, buttonW, buttonH)];
    
    
    [startButton setTitle:@"开始动画" forState:UIControlStateNormal];
    [startButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    startButton.backgroundColor = [UIColor yellowColor];
    [startButton sizeToFit];
    
    [endButton setTitle:@"结束动画" forState:UIControlStateNormal];
    [endButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    endButton.backgroundColor = [UIColor blueColor];
    [endButton sizeToFit];
    //监听方法
    [startButton addTarget:self action:@selector(didClickStartButton:) forControlEvents:UIControlEventTouchUpInside];
    [endButton addTarget:self action:@selector(didClickStopButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:startButton];
    [self.view addSubview:endButton];
}

#pragma mark - private Method
//点击了开始动画按钮
- (void)didClickStartButton:(UIButton *)sender {
    
    if (self.snowEmitter == nil) {
        
        //创建雪花的发射源
        CAEmitterLayer *snowEmitter = [CAEmitterLayer layer];
        
        //设置发射源的位置
        snowEmitter.emitterPosition = CGPointMake(self.view.bounds.size.width / 2.0, -30);
        //设置发射源的大小
        snowEmitter.emitterSize  = CGSizeMake(self.view.bounds.size.width, 0.0);;
        //发射源的形状
        snowEmitter.emitterShape = kCAEmitterLayerLine;
        //发射模式
        snowEmitter.emitterMode  = kCAEmitterLayerOutline;
        //创建发射源单元
        CAEmitterCell *snowflake = [CAEmitterCell emitterCell];
        //生成速率
        snowflake.birthRate	= 0.7;
        //生命周期
        snowflake.lifetime	= 120.0;
        //初始速度
        snowflake.velocity	= -7;
        //初始速度的范围
        snowflake.velocityRange = 10;
        
        //各个方向的速度
        snowflake.xAcceleration = 0.2;
        snowflake.zAcceleration = 0.5;
        snowflake.yAcceleration = 0.7;
        //缩放
        snowflake.scaleRange = 0.6;
        //以锥形分布开的发射角度
        snowflake.emissionRange = 0.5 * M_PI;
        //旋转速度
        snowflake.spinRange = 0.3 * M_PI;
        //发射单元的图片
        snowflake.contents  = (id) [[UIImage imageNamed:@"snow_flake"] CGImage];
        //    snowflake.color	= [[UIColor colorWithRed:0.600 green:0.658 blue:0.743 alpha:0.4] CGColor];
        //发射单元的颜色
        snowflake.color	= [[UIColor colorWithRed:254/255.0 green:254/255.0 blue:254/255.0 alpha:1.0] CGColor];
        //    snowflake.color = [UIColor whiteColor].CGColor;
        
        //雪花的阴影
        snowEmitter.shadowOpacity = 1.0;
        snowEmitter.shadowRadius  = 2;
        snowEmitter.shadowOffset  = CGSizeMake(0.0, 1.0);
        snowEmitter.shadowColor   = [[UIColor whiteColor] CGColor];
        
        snowEmitter.emitterCells = [NSArray arrayWithObject:snowflake];
        [self.view.layer insertSublayer:snowEmitter atIndex:0];
        self.snowEmitter = snowEmitter;
        
    }
}

//点击了关闭动画按钮
- (void)didClickStopButton:(UIButton *)sender {
    
    [self.snowEmitter removeFromSuperlayer];
    self.snowEmitter = nil;
}

@end
