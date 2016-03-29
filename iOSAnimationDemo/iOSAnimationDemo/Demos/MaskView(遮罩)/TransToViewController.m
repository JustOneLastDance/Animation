//
//  TransToViewController.m
//  iOSAnimationDemo
//
//  Created by Raymone on 16/3/17.
//  Copyright © 2016年 Mekingo8. All rights reserved.
//

#import "TransToViewController.h"
#import "MaskTransitionViewController.h"
#import "PingInvertTransition.h"
@interface TransToViewController ()

@end

@implementation TransToViewController{
    UIPercentDrivenInteractiveTransition *percentTransition;
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor greenColor]];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] init];
    
    self.button  = [[UIButton alloc]init];
    [self.button setBackgroundImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];
    
    [self.button addTarget:self action:@selector(popCtl) forControlEvents:UIControlEventTouchUpInside];
    [self.button sizeToFit];
    
    [backButton setCustomView:self.button];
    
    
    [[self navigationItem] setLeftBarButtonItem:backButton];
    
    
    UIScreenEdgePanGestureRecognizer *edgeGes = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(edgePan:)];
    edgeGes.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgeGes];
}

- (void)popCtl{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    return percentTransition;
}

- (IBAction)clickToPop:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)edgePan:(UIPanGestureRecognizer *)recognizer{
    CGFloat per = [recognizer translationInView:self.view].x / (self.view.bounds.size.width);
    per = MIN(1.0,(MAX(0.0, per)));
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        percentTransition = [[UIPercentDrivenInteractiveTransition alloc]init];
        [self.navigationController popViewControllerAnimated:YES];
    }else if (recognizer.state == UIGestureRecognizerStateChanged){
        [percentTransition updateInteractiveTransition:per];
    }else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled){
        if (per > 0.3) {
            [percentTransition finishInteractiveTransition];
        }else{
            [percentTransition cancelInteractiveTransition];
        }
        percentTransition = nil;
    }
}


- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPop) {
        PingInvertTransition *pingInvert = [PingInvertTransition new];
        return pingInvert;
    }else{
        return nil;
    }
}


@end
