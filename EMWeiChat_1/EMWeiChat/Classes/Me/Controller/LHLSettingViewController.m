//
//  LHLSettingViewController.m
//  EMWeiChat
//
//  Created by admin on 16/11/6.
//  Copyright © 2016年 冷洪林. All rights reserved.
//

#import "LHLSettingViewController.h"
#import "LHLLoginViewController.h"

@interface LHLSettingViewController ()

@end

@implementation LHLSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

// 退出登录
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        
        [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
            if (!error) {
                NSLog(@"退出登录");
                // 1.记录退出的用户名(为了用户再次登录的时候不用重新输入用户名.optional)
                [[NSUserDefaults standardUserDefaults] setObject: [[EaseMob sharedInstance].chatManager loginInfo][@"username"] forKey:@"username"];
                
                // 2.切换窗口根控制器
                LHLLoginViewController *loginVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LHLLoginViewController"];
                [UIApplication sharedApplication].keyWindow.rootViewController = loginVC;
            }else
            {
                NSLog(@"error : %@", error);
            }
        } onQueue:nil];
        
    }
}



@end














