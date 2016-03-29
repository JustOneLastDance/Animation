//
//  MaskViewController.m
//  iOSAnimationDemo
//
//  Created by Mekingo8 on 16/3/16.
//  Copyright © 2016年 Mekingo8. All rights reserved.
//

#import "MaskViewController.h"
#import "TwitterMaskViewController.h"
#import "MaskTransitionViewController.h"

@interface MaskViewController ()

@end

@implementation MaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CGFloat x = random() % 214 + 1.0;
    self.view.backgroundColor = [UIColor colorWithRed:x / 255.0 green:x / 255.0 blue:x / 255.0 alpha:1.0];
    
    //重新定义返回按钮
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:nil
                                                                     action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];
    
    //第一组动画按钮
    UIButton *btnMaskTwitter = [[UIButton alloc]init];
    [btnMaskTwitter addTarget:self action:@selector(maskTwitter) forControlEvents:UIControlEventTouchUpInside];
    [btnMaskTwitter setTitle:@"仿Twitter启动动画" forState:UIControlStateNormal];
    [btnMaskTwitter setBackgroundColor:[UIColor orangeColor]];
    [btnMaskTwitter sizeToFit];
    [self.view addSubview:btnMaskTwitter];
    btnMaskTwitter.frame = CGRectMake(20, 100, [UIScreen mainScreen].bounds.size.width-40, 40);
    
    //第二组动画按钮
    UIButton *btnMaskTrans = [[UIButton alloc]init];
    [btnMaskTrans addTarget:self action:@selector(maskTransition) forControlEvents:UIControlEventTouchUpInside];
    [btnMaskTrans setTitle:@"Mask转场动画效果" forState:UIControlStateNormal];
    [btnMaskTrans setBackgroundColor:[UIColor orangeColor]];
    [btnMaskTrans sizeToFit];
    [self.view addSubview:btnMaskTrans];
    btnMaskTrans.frame = CGRectMake(20, 180, [UIScreen mainScreen].bounds.size.width-40, 40);
}

- (void)maskTwitter {
    [self.navigationController pushViewController:[[TwitterMaskViewController alloc]init] animated:YES];
}

- (void)maskTransition {
    [self.navigationController pushViewController:[[MaskTransitionViewController alloc]init] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
