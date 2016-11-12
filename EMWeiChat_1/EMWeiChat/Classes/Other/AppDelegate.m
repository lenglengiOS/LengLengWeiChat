//
//  AppDelegate.m
//  EMWeiChat
//
//  Created by admin on 16/11/4.
//  Copyright © 2016年 冷洪林. All rights reserved.
//

#import "AppDelegate.h"

#define kEaseMobAppKey @"lengleng#lengleng"
#import "LHLTabBarController.h"
#import "LHLLoginViewController.h"

@interface AppDelegate () <EMChatManagerDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /**
     *  @prama registerSDKWithAppKey 环信官网的appKey
     *  @prama apnsCertName 苹果官网注册的推送证书,楼主没有申请99刀,嘿嘿,这里就不用啦
     *  @prama otherConfig
     */
    // 1.注册APPKey
    [[EaseMob sharedInstance] registerSDKWithAppKey:kEaseMobAppKey
                              apnsCertName:nil
                                        otherConfig:@{kSDKConfigEnableConsoleLogger : @NO}];
    // 2.跟踪app生命周期
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    // 3.添加监听代理
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    // 4.判断是否是自动登录
    BOOL isAutoLogin = [[EaseMob sharedInstance].chatManager isAutoLoginEnabled];
    if (isAutoLogin) {
        NSLog(@"已经设置自动登录,切换根控制器");
        // 1.显示正在自动登录
        [SVProgressHUD showWithStatus:@"正在自动登录中..."];
        // 2.在 didAutoLoginWithInfo 方法中切换至主页面
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // 进入后台
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // 从后台进入前台
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // 销毁
    [[EaseMob sharedInstance] applicationWillTerminate:application];
    // 移除代理
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

#pragma mark - 自动登录
- (void)didAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
    [SVProgressHUD dismiss];
    if (error) { // 显示错误信息,不登录
        [JDStatusBarNotification showWithStatus:error.description dismissAfter:2.0];
    }else // 切换窗口根控制器
    {
        LHLTabBarController *tabBarVc = [[LHLTabBarController alloc] init];
        self.window.rootViewController = tabBarVc;
        [self.window makeKeyAndVisible];
    }
}

#pragma mark - 监听被动退出
- (void)didRemovedFromServer
{
    NSLog(@"账号被服务器删除");
    [self lhl_LogOffPassively];
}

- (void)didLoginFromOtherDevice
{
    NSLog(@"从其他设备登录");
    [self lhl_LogOffPassively];
}
#pragma mark - 被动LogOff
- (void)lhl_LogOffPassively
{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
        
        // 被动退出后回调, 切换根控制器
        LHLLoginViewController *loginVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LHLLoginViewController"];
        self.window.rootViewController = loginVC;
        
    } onQueue:nil];
}


@end
















