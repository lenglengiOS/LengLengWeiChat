//
//  LHLUserDetailsController.m
//  EMWeiChat
//
//  Created by admin on 16/11/7.
//  Copyright © 2016年 冷洪林. All rights reserved.
//

#import "LHLUserDetailsController.h"
#import "LHLChatViewController.h"
#import "LHLTabBarController.h"
#import "LHLChatController.h"

@interface LHLUserDetailsController ()

@property (weak, nonatomic) IBOutlet UILabel *username;

@end

@implementation LHLUserDetailsController

+ (instancetype)userDetails
{
    return [[UIStoryboard storyboardWithName:@"LHLUserDetailsController" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置标题
    self.title = @"详细资料";
    
    // 添加发消息按钮  视频通话按钮
    [self lhl_addSendMessageBtn];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.username.text = self.buddy.username;
}

// 发消息
- (void)lhl_addSendMessageBtn
{
    // 获取tableFooterView
    UIView *footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, LHLScreenW, 200);
    self.tableView.tableFooterView = footerView;
    
    // 创建发消息按钮
    UIButton *message = [[UIButton alloc] init];
    message.frame = CGRectMake(30, 30, LHLScreenW - 60, 44);
    message = [self createButton:message backGroundImage:[UIColor colorWithRed:0 green:179 blue:37] highlightColor:[UIColor colorWithRed:0 green:160 blue:33] frame:message.frame title:@"发消息"];
    [message addTarget:self action:@selector(sendMsg) forControlEvents:UIControlEventTouchUpInside];
    
    [footerView addSubview:message];
    
    // 创建视频通话
    UIButton *facetime = [[UIButton alloc] init];
    facetime.frame = CGRectMake(30, CGRectGetMaxY(message.frame) + 20, LHLScreenW - 60, 44);
    facetime = [self createButton:facetime backGroundImage:[UIColor colorWithRed:248 green:248 blue:248] highlightColor:[UIColor colorWithRed:223 green:223 blue:223] frame:facetime.frame title:@"视频聊天"];
    [facetime setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [footerView addSubview:facetime];
}

// 点击发消息调用此方法
- (void)sendMsg
{
    // 点击发送就pop当前控制器
    [self.navigationController popViewControllerAnimated:NO];
    // 切换到微信模块
    LHLTabBarController *tabBarVC = (LHLTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tabBarVC.selectedViewController = tabBarVC.childViewControllers[0];
    
    // push到发消息界面
    LHLChatController *chatVC = [[LHLChatController alloc] init];
    chatVC.buddy = self.buddy;
    [(UINavigationController *)tabBarVC.childViewControllers[0] pushViewController:chatVC animated:YES];
}

// 创建按钮
- (UIButton *)createButton:(UIButton *)button backGroundImage:(UIColor *)imageWithColor highlightColor:(UIColor *)highlightColor frame:(CGRect)frame title:(NSString *)title
{
    button = [[UIButton alloc] init];
    button.frame = frame;
    [button setBackgroundImage:[UIImage lhl_imageWithColor:imageWithColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage lhl_imageWithColor:highlightColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5.0;
    return button;
}

@end










