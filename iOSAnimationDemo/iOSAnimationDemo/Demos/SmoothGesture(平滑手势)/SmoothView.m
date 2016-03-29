//
//  SmoothView.m
//  iOSAnimationDemo
//
//  Created by Geeven on 16/3/17.
//  Copyright © 2016年 Mekingo8. All rights reserved.
//

#import "SmoothView.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define MAXLIMITY SCREENHEIGHT/2

@implementation SmoothView

#pragma mark - 构造函数

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        
    }
    return self;
}


-(void)setGestureView:(UIView *)gestureView {
    _gestureView = gestureView;
    
    UIPanGestureRecognizer * pangesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [_gestureView addGestureRecognizer:pangesture];
    
}

- (void)panGesture:(UIPanGestureRecognizer *) pangesture {
    
    static CGPoint currentPoint;
    CGFloat transScare = 0.0f;
    CGFloat transAngle = 0.0f;
    CGPoint transPoint = [pangesture translationInView:self.superview];
    
    if (pangesture.state == UIGestureRecognizerStateBegan) {
        currentPoint = self.center;
    }else if (pangesture.state == UIGestureRecognizerStateChanged) {
        
        self.center = CGPointMake(currentPoint.x, currentPoint.y + transPoint.y);
        //用于限定移动最远位置
        CGFloat Y = MIN(MAXLIMITY, MAX(0, ABS(transPoint.y)));
        CATransform3D trans = CATransform3DIdentity;
        
        transAngle = MAX(0,-4.0/(MAXLIMITY*MAXLIMITY)*Y*(Y-MAXLIMITY));
        transScare = MAX(0,-1.0/(MAXLIMITY*MAXLIMITY)*Y*(Y-2*MAXLIMITY));
        
        trans = CATransform3DScale(trans,1 - transScare * 0.2, 1 - transScare * 0.2, 0);
        transScare = MAX(0, (1.5 * Y - MAXLIMITY * MAXLIMITY)/(MAXLIMITY * MAXLIMITY));
        trans = CATransform3DRotate(trans, transAngle, transPoint.y > 0 ? -1 : 1, 0, 0);
        
        trans = CATransform3DScale(trans,1 - transScare*0.2, 1 - transScare*0.2, 0);
        self.layer.transform = trans;
        
        
    }else if ((pangesture.state == UIGestureRecognizerStateCancelled)||(pangesture.state == UIGestureRecognizerStateEnded)) {
        
        [UIView animateWithDuration:0.5
                              delay:0.0
             usingSpringWithDamping:0.5
              initialSpringVelocity:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             self.layer.transform = CATransform3DIdentity;
                             self.center = currentPoint;
                         } completion:nil];
        
    }
    
    
}
@end
