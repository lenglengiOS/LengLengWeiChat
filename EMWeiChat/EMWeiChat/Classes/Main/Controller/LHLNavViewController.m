//
//  LHLNavViewController.m
//  EMWeiChat
//
//  Created by admin on 16/11/6.
//  Copyright © 2016年 冷洪林. All rights reserved.
//

#import "LHLNavViewController.h"

@interface LHLNavViewController ()

@end

@implementation LHLNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航栏背景颜色
    [self.navigationBar lhl_setBackgroundColor:[UIColor blackColor]];
    // 修改左右UIBarButtonItem主题色
    self.navigationBar.tintColor = [UIColor whiteColor];
    // 修改标题颜色
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
}

// 设置状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTabBarItemImage:(NSString *)image selectImage:(NSString *)selectImage title:(NSString *)title
{
    self.tabBarItem.image = [UIImage imageOriginalWithName:image];
    self.tabBarItem.selectedImage = [UIImage imageOriginalWithName:selectImage];
    self.title = title;
    [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:9 green:187 blue:7]} forState:UIControlStateSelected];
}

@end
