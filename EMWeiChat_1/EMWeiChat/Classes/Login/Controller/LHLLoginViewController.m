//
//  ViewController.m
//  EMWeiChat
//
//  Created by admin on 16/11/4.
//  Copyright © 2016年 冷洪林. All rights reserved.
//

#import "LHLLoginViewController.h"
#import "LHLTabBarController.h"

@interface LHLLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextField *pwdLabel;

@end

@implementation LHLLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 获取到保存的用户名
    NSString *lastUser = [[NSUserDefaults standardUserDefaults] valueForKeyPath:@"username"];
    if (lastUser) {
        self.usernameLabel.text = lastUser;
    }
}

// 登录
- (IBAction)loginBtn:(id)sender {
    
    [SVProgressHUD showWithStatus:@"登录中..."];
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:self.usernameLabel.text password:self.pwdLabel.text completion:^(NSDictionary *loginInfo, EMError *error) {
        
        [SVProgressHUD dismiss];
        if (!error) {
            NSLog(@"登录成功");
            // 1.设置自动登录
            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
            [JDStatusBarNotification showWithStatus:@"登录成功!" dismissAfter:2.0 styleName:JDStatusBarStyleSuccess];
            // 2.切换至主页面
            LHLTabBarController *tabBarVc = [[LHLTabBarController alloc] init];
            [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVc;
        }else
        {
            NSLog(@"error: %@", error);
            [JDStatusBarNotification showWithStatus:[NSString stringWithFormat:@"登录失败!"] dismissAfter:2.0 styleName:JDStatusBarStyleError];
        }
    } onQueue:nil];
}

// 注册(代理回调方法注册)
- (IBAction)registerBtn:(id)sender {
    
    [SVProgressHUD showWithStatus:@"注册中..."];
    // 接口调用
    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:self.usernameLabel.text password:self.pwdLabel.text withCompletion:^(NSString *username, NSString *password, EMError *error) {
        [SVProgressHUD dismiss];
        if (!error) {
            NSLog(@"注册成功 : username = %@ password = %@", error, password);
            [JDStatusBarNotification showWithStatus:@"注册成功,请登录!" dismissAfter:2.0 styleName:JDStatusBarStyleSuccess];
        }else
        {
            NSLog(@"error : %@", error);
            [JDStatusBarNotification showWithStatus:[NSString stringWithFormat:@"注册失败!"] dismissAfter:2.0 styleName:JDStatusBarStyleError];
        }
    } onQueue:nil];

}






@end









