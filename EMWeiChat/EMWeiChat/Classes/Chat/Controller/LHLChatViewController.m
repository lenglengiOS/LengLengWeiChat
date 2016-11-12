//
//  LHLChatViewController.m
//  EMWeiChat
//
//  Created by admin on 16/11/6.
//  Copyright © 2016年 冷洪林. All rights reserved.
//

#import "LHLChatViewController.h"
#import "LHLUserDetailsController.h"
#import "LHLChatController.h"

/**
 在微信中,它的微信界面的标题切换的是 titleView
 除了下面4种状态,还有
 听筒模式
 未读消息数量展示
 等等
 
 此处我们通过简单的模仿,来了解 连接状态改变,以及消息接收带来的对标题view的影响
 */
NSString * const LHLWeChatTitleNormal = @"微信";
NSString * const LHLWeChatTitleWillConnect = @"连接中...";
NSString * const LHLWeChatTitleDisconnect = @"微信(未连接)";
NSString * const LHLWeChatTitleWillReceiveMsg = @"收取中...";

@interface LHLChatViewController () <EMChatManagerDelegate>

@end

@implementation LHLChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = LHLWeChatTitleNormal;
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/



#pragma mark - 自动重连
/*!
 @method
 @brief 将要发起自动重连操作时发送该回调
 @discussion
 @result
 */
- (void)willAutoReconnect
{
    NSLog(@"将要自动重连");
    self.title = LHLWeChatTitleWillConnect;
}

/*!
 @method
 @brief 自动重连操作完成后的回调（成功的话，error为nil，失败的话，查看error的错误信息）
 @discussion
 @result
 */
- (void)didAutoReconnectFinishedWithError:(NSError *)error
{
    if (!error) {
        NSLog(@"自动重连成功");
        self.title = LHLWeChatTitleNormal;
    }else
    {
        NSLog(@"自动重连失败");
        self.title = LHLWeChatTitleDisconnect;
    }
}

#pragma mark - 连接状态改变
- (void)didConnectionStateChanged:(EMConnectionState)connectionState
{
    switch (connectionState) {
        case eEMConnectionConnected: // 连接成功
        {
            self.title = LHLWeChatTitleNormal;
        }
            break;
        case eEMConnectionDisconnected: // 未连接
        {
            self.title = LHLWeChatTitleDisconnect;
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - 移除代理
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[EaseMob sharedInstance].chatManager removeDelegate:self];

}




@end
