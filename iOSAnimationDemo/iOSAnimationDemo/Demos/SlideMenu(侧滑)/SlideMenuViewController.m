//
//  SlideMenuViewController.m
//  iOSAnimationDemo
//
//  Created by Mekingo8 on 16/3/16.
//  Copyright © 2016年 Mekingo8. All rights reserved.
//

#import "SlideMenuViewController.h"

@interface SlideMenuViewController ()

@end

@implementation SlideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CGFloat x = random() % 254 + 1.0;
    self.view.backgroundColor = [UIColor colorWithRed:x / 255.0 green:x / 255.0 blue:x / 255.0 alpha:1.0];
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
