//
//  LHLContactViewController.m
//  EMWeiChat
//
//  Created by admin on 16/11/6.
//  Copyright © 2016年 冷洪林. All rights reserved.
//

#import "LHLContactViewController.h"
#import "LHLFriendCell.h"
#import "LHLUserDetailsController.h"

@interface LHLContactViewController () <EMChatManagerDelegate>

/** 本地的好友列表 */
@property (nonatomic, strong) NSMutableArray *friends;
/** 服务器获取的好友列表 */
@property (nonatomic, strong) NSArray *buddies;

@end

@implementation LHLContactViewController

static NSString *cellID = @"UITableViewCell";
- (NSMutableArray *)friends
{
    // 好友列表(由EMBuddy对象组成)
    if (_friends == nil) {
        
        _friends = [NSMutableArray array];
        _buddies = [[EaseMob sharedInstance].chatManager buddyList];
        if (_buddies.count) {
            [_friends addObjectsFromArray:_buddies];
        }
    }
    return _friends;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置标题
    self.navigationItem.title = @"通讯录";
    
    // 设置添加好友按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"contacts_add_friend"] style:UIBarButtonItemStylePlain target:self action:@selector(addFriend)];
    
    // 去除自带的cell分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 设置行高
    self.tableView.rowHeight = 50;
    
    // 监听好友列表的刷新
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];;
}

- (void)addFriend
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"添加好友" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入账号";
    }];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入理由";
    }];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"发送" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        EMError *error = nil;
        BOOL isSuccess = [[EaseMob sharedInstance].chatManager addBuddy:alertVC.textFields.firstObject.text message:alertVC.textFields.lastObject.text error:&error];
        if (!error) {
            NSLog(@"发送好友请求成功 - %d", isSuccess);
        }
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        // 取消添加
    }]];
    [self presentViewController:alertVC animated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.friends.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LHLFriendCell *cell = [LHLFriendCell friendCell:tableView];
    
    EMBuddy *buddy = self.friends[indexPath.row];
    cell.buddy = buddy;
    
    return cell;
}

#pragma mark - Table view delegate
// 开启tableView编辑模式,左滑删除好友
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) { // 删除好友
        EMBuddy *buddy = self.friends[indexPath.row];
        EMError *error = nil;
        [[EaseMob sharedInstance].chatManager removeBuddy:buddy.username removeFromRemote:YES error:&error];
        if (!error) {
            NSLog(@"删除好友成功!");
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LHLUserDetailsController *userDetails = [LHLUserDetailsController userDetails];
    EMBuddy *buddy = self.friends[indexPath.row];
    userDetails.buddy = buddy;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userDetails animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - 监听好友列表刷新
- (void)didUpdateBuddyList:(NSArray *)buddyList changedBuddies:(NSArray *)changedBuddies isAdd:(BOOL)isAdd
{
    // 改变模型数组
    [self.friends removeAllObjects];
    [self.friends addObjectsFromArray:buddyList];
    // 刷新表
    [self.tableView reloadData];
}


@end
