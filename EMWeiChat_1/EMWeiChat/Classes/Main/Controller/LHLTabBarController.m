//
//  LHLTabBarController.m
//  EMWeiChat
//
//  Created by admin on 16/11/6.
//  Copyright © 2016年 冷洪林. All rights reserved.
//

#import "LHLTabBarController.h"
#import "LHLChatViewController.h"
#import "LHLContactViewController.h"
#import "LHLDiscoverViewController.h"
#import "LHLMeViewController.h"
#import "LHLNavViewController.h"

@interface LHLTabBarController () <EMChatManagerDelegate>

@end

@implementation LHLTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建所有子控制器
    [self setUpChildViewControllers];
    
    // 设置tabBar按钮和标题
    [self setUpAllTitles];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

- (void)setUpChildViewControllers
{
    // 微信
    LHLChatViewController *chatVC = [[LHLChatViewController alloc] init];
    LHLNavViewController *nav = [[LHLNavViewController alloc] initWithRootViewController:chatVC];
    [self addChildViewController:nav];
    
    // 通讯录
    LHLContactViewController *contactVc = [[LHLContactViewController alloc] init];
    LHLNavViewController *nav1 = [[LHLNavViewController alloc] initWithRootViewController:contactVc];
    [self addChildViewController:nav1];
    
    // 发现
    LHLDiscoverViewController *discoverVC = [[LHLDiscoverViewController alloc] init];
    LHLNavViewController *nav2 = [[LHLNavViewController alloc] initWithRootViewController:discoverVC];
    [self addChildViewController:nav2];
    
    // 我
    LHLMeViewController *meVC = [[UIStoryboard storyboardWithName:@"LHLMeViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"LHLMeViewController"];
    LHLNavViewController *nav3 = [[LHLNavViewController alloc] initWithRootViewController:meVC];
    [self addChildViewController:nav3];
}

- (void)setUpAllTitles
{
    // 设置按钮的标题和图片
    LHLNavViewController *nav = self.childViewControllers[0];
    [nav setTabBarItemImage:@"tabbar_mainframe" selectImage:@"tabbar_mainframeHL" title:@"微信"];
    
    LHLNavViewController *nav1 = self.childViewControllers[1];
    [nav1 setTabBarItemImage:@"tabbar_contacts" selectImage:@"tabbar_contactsHL" title:@"通讯录"];
    
    LHLNavViewController *nav2 = self.childViewControllers[2];
    [nav2 setTabBarItemImage:@"tabbar_discover" selectImage:@"tabbar_discoverHL" title:@"发现"];
    
    LHLNavViewController *nav3 = self.childViewControllers[3];
    [nav3 setTabBarItemImage:@"tabbar_me" selectImage:@"tabbar_meHL" title:@"我"];
}

#pragma mark - 监听好友请求
- (void)didReceiveBuddyRequest:(NSString *)username message:(NSString *)message
{
    // 1.修改通讯录在tabBar上的badge数字
    [self lhl_changeBadgeValue];
    
    // 2.弹框显示谁添加的
    [self lhl_askForBuddyAccept:username message:message];
    
    // 3.切换到通讯录界面
    self.selectedViewController = self.childViewControllers[1];
}

- (void)lhl_changeBadgeValue
{
    //badgeValue Plus
    LHLContactViewController *contactVC = self.childViewControllers[1];
    NSString *badgeValue = contactVC.navigationController.tabBarItem.badgeValue;
    NSInteger badgeNum = badgeValue.integerValue;
    badgeNum += 1;
    contactVC.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%zd", badgeNum];
}

- (void)lhl_askForBuddyAccept:(NSString *)username message:(NSString *)message
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@想添加您为好友", username] message:[NSString stringWithFormat:@"申请理由: %@", message] preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 同意添加好友
        EMError *error = nil;
        [[EaseMob sharedInstance].chatManager acceptBuddyRequest:username error:&error];
        if (!error) {
            NSLog(@"已经同意添加好友");
            // 刷新通讯录界面,在通讯录界面中直接响应好友更新的方法,刷新好友数据,刷新表
        }
    }]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 拒绝添加好友
        EMError *error = nil;
        [[EaseMob sharedInstance].chatManager rejectBuddyRequest:username reason:@"不想加陌生人" error:&error];
        if (!error) {
            NSLog(@"已经拒绝添加好友");
        }
    }]];
    
    [self presentViewController:alertVC animated:YES completion:^{
        
    }];
}

@end










