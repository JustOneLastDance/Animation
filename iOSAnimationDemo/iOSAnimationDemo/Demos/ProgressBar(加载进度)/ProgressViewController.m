//
//  ProgressViewController.m
//  iOSAnimationDemo
//
//  Created by Mekingo8 on 16/3/16.
//  Copyright © 2016年 Mekingo8. All rights reserved.
//

#import "ProgressViewController.h"
#import "ProgressView.h"

@interface ProgressViewController ()

@end

@implementation ProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat x = random() % 194 + 1.0;
    self.view.backgroundColor = [UIColor colorWithRed:x / 255.0 green:255.0 / 255.0 blue:255.0 / 255.0 alpha:1.0];
    
    //加载进度视图
    ProgressView * progressView = [[ProgressView alloc]initWithFrame: CGRectMake((self.view.bounds.size.width - 200) * 0.5, (self.view.bounds.size.height - 200) * 0.5, 200, 200)];
    //圆角
    progressView.layer.cornerRadius = progressView.frame.size.height / 2;
    progressView.backgroundColor = [UIColor colorWithRed:0.0 green:122/255.0 blue:255/255.0 alpha:1.0];
    
    [self.view addSubview:progressView];
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
