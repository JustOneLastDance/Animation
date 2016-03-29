//
//  3DCardImageViewController.m
//  iOSAnimationDemo
//
//  Created by Mekingo8 on 16/3/16.
//  Copyright © 2016年 Mekingo8. All rights reserved.
//

#import "CardImageViewController.h"
#import "ThreeDView.h"

@interface CardImageViewController ()

@end

@implementation CardImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CGFloat x = random() % 254 + 1.0;
    self.view.backgroundColor = [UIColor colorWithRed:x / 255.0 green:255.0 / 255.0 blue:255.0 / 255.0 alpha:1.0];
    
    ThreeDView *threeDView = [[ThreeDView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width/2, self.view.bounds.size.height/2)];
    threeDView.center = self.view.center;
    [self.view addSubview:threeDView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
