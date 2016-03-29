//
//  RootTableTableViewController.m
//  iOSAnimationDemo
//
//  Created by Mekingo8 on 16/3/16.
//  Copyright © 2016年 Mekingo8. All rights reserved.
//

#import "RootTableTableViewController.h"
static NSString *cellIdentifier = @"reuseIdentifier";

@interface RootTableTableViewController ()

@property (nonatomic, strong) NSArray *demoList;

@end

@implementation RootTableTableViewController

- (void)viewWillAppear:(BOOL)animated {

    self.navigationItem.title = @"功能列表";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.demoList = @[@[@"底部菜单", @"BottomBarViewController"],
                      @[@"3D图片", @"CardImageViewController"],
                      //@[@"动态侧边栏", @"DynamicSlideController"],
                      @[@"火花按钮", @"FireworkViewController"],
                      @[@"遮罩", @"MaskViewController"],
                      @[@"加载进度", @"ProgressViewController"],
                      @[@"小皮球", @"RubberBallViewController"],
                      @[@"侧滑", @"SlideMenuViewController"],
                      @[@"平滑手势", @"SmoothGestureController"],
                      @[@"下拉刷新", @"PullDownController"],
                      @[@"星跳", @"JumpStarViewController"],
                      @[@"粒子效果", @"SnowViewController"]];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.demoList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = self.demoList[indexPath.row][0];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *vc = [[NSClassFromString(self.demoList[indexPath.row][1]) alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
