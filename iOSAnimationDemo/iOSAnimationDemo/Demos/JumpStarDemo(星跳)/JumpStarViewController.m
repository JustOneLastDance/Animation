//
//  JumpStarViewController.m
//  iOSAnimationDemo
//
//  Created by Mekingo8 on 16/3/16.
//  Copyright © 2016年 Mekingo8. All rights reserved.
//

#import "JumpStarViewController.h"
#import "JumpStarView.h"

@interface JumpStarViewController ()

@end

@implementation JumpStarViewController {
    // 图像视图
    JumpStarView *_jumpStarView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}
// MARK: - 设置界面
- (void)setupUI {
    // 设置背景颜色
    self.view.backgroundColor = [UIColor yellowColor];
    // 添加按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    // 布局
    [button setTitle:@"Jump!" forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button sizeToFit];
    button.center = CGPointMake(self.view.center.x, self.view.center.y + 50);
    // 添加监听方法
    [button addTarget:self action:@selector(clickToJump) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    // 添加视图
    _jumpStarView = [[JumpStarView alloc] init];
    
    _jumpStarView.bounds = CGRectMake(0, 0, 50, 50);
    _jumpStarView.center = self.view.center;
    // 调用布局 实例化对象
    [_jumpStarView layoutIfNeeded];
    _jumpStarView.starImage = [UIImage imageNamed:@"star"];
    _jumpStarView.loveImage = [UIImage imageNamed:@"love"];
    _jumpStarView.state = STAR;
    
    [self.view addSubview:_jumpStarView];
}
// MARK: - 监听方法
- (void)clickToJump {
    [_jumpStarView jump];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
