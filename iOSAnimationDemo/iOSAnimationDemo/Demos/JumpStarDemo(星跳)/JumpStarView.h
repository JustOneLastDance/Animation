//
//  JumpStarView.h
//  iOSAnimationDemo
//
//  Created by pb on 16/3/17.
//  Copyright © 2016年 Mekingo8. All rights reserved.
//

#import <UIKit/UIKit.h>
// 状态枚举
typedef enum {
    STAR,
    LOVE
}State;
@interface JumpStarView : UIView
// 星星图片
@property (nonatomic, strong) UIImage *starImage;
// 爱心图片
@property (nonatomic, strong) UIImage *loveImage;
// 状态枚举
@property (nonatomic, assign) State state;
// 动画方法
- (void)jump;

@end
