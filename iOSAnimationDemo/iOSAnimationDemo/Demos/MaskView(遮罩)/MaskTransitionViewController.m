//
//  MaskTransitionViewController.m
//  iOSAnimationDemo
//
//  Created by Raymone on 16/3/16.
//  Copyright © 2016年 Mekingo8. All rights reserved.
//

#import "MaskTransitionViewController.h"
#import "TransToViewController.h"
#import "PingTransition.h"



@interface MaskTransitionViewController ()



@end

@implementation MaskTransitionViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor orangeColor]];
    
    
    //重新定义返回按钮
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:nil
                                                                  action:nil];
    [[self navigationItem] setBackBarButtonItem:backButton];
    
    //右侧按钮按钮
    //    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MoreAbout"] style:UIBarButtonItemStylePlain target:self action:@selector(jumpNextCtl)];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]init];
    
    self.button = [[UIButton alloc]init];
    [self.button setBackgroundImage:[UIImage imageNamed:@"MoreAbout"] forState:UIControlStateNormal];
    [self.button sizeToFit];
    [self.button addTarget:self action:@selector(jumpNextCtl) forControlEvents:UIControlEventTouchUpInside];
    
    [rightButton setCustomView:self.button];
    
    [[self navigationItem] setRightBarButtonItem:rightButton];
    
}

- (void) jumpNextCtl{
    TransToViewController *transVc = [[TransToViewController alloc]init];
    [self.navigationController pushViewController:transVc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UINavigationControllerDelegate
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPush) {
        
        PingTransition *ping = [PingTransition new];
        return ping;
    }else{
        return nil;
    }
}



@end
