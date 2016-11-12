//
//  LHLMeViewController.m
//  EMWeiChat
//
//  Created by admin on 16/11/6.
//  Copyright © 2016年 冷洪林. All rights reserved.
//

#import "LHLMeViewController.h"
#import "LHLSettingViewController.h"

@interface LHLMeViewController ()

@property (weak, nonatomic) IBOutlet UILabel *username;

@end

@implementation LHLMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我";
    self.username.text = [[EaseMob sharedInstance].chatManager loginInfo][@"username"];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        LHLSettingViewController *settingVC = [[UIStoryboard storyboardWithName:@"LHLSettingViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"LHLSettingViewController"];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:settingVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}

@end








