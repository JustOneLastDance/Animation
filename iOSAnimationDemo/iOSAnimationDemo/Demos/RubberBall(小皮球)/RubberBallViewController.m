//
//  RubberBallViewController.m
//  iOSAnimationDemo
//
//  Created by Mekingo8 on 16/3/16.
//  Copyright © 2016年 Mekingo8. All rights reserved.
//

#import "RubberBallViewController.h"
#import "RubbleBallView/RubberBallView.h"

@interface RubberBallViewController ()

@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UISlider *progressSlider;
@property (nonatomic, strong) UIButton *resetButton;
@property (nonatomic, strong) RubberBallView *rubberView;

@end

@implementation RubberBallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 150, 20)];
    self.progressLabel.text = [NSString stringWithFormat:@"current: %f", 0.5];
    [self.view addSubview:self.progressLabel];
    
    self.progressSlider = [[UISlider alloc] initWithFrame:CGRectMake(50, 150, 250, 20)];
    [self.view addSubview:self.progressSlider];
    [self.progressSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    self.progressSlider.value = 0.5;

    self.resetButton = [[UIButton alloc] init];
    [self.view addSubview:self.resetButton];
    [self.resetButton setTitle:@"重置皮球形状" forState:UIControlStateNormal];
    [self.resetButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.resetButton addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
    [self.resetButton sizeToFit];
    self.resetButton.center = CGPointMake(self.view.center.x, self.view.center.y + 200);

    self.rubberView = [[RubberBallView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 320/2, self.view.frame.size.height/2 - 320/2, 320, 320)];
    
//    self.rubberView = [[RubberBallView alloc] init];
    
    [self.view addSubview:self.rubberView];
    self.rubberView.rubberBallLayer.progress = self.progressSlider.value;
    
    
    
}

- (void)clickButton {
    self.rubberView.rubberBallLayer.progress = 0.5;
    self.progressSlider.value = 0.5;
}

- (void)valueChanged:(UISlider *)sender {
    NSLog(@"%f", sender.value);
    self.progressLabel.text = [NSString stringWithFormat:@"current: %f", sender.value];
    self.rubberView.rubberBallLayer.progress = sender.value;
}

@end
