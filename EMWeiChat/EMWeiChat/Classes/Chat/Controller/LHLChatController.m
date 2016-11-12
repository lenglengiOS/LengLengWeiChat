//
//  LHLChatController.m
//  EMWeiChat
//
//  Created by admin on 16/11/7.
//  Copyright © 2016年 冷洪林. All rights reserved.
//

#import "LHLChatController.h"
#import "LHLInputView.h"

#import "LHLChatCell.h"
#import "LHLChatModel.h"
#import "LHLChatFrameModel.h"
#import "MWPhotoBrowser.h"


#define kInputViewH 44
#define kNavH 64

@interface LHLChatController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, EMChatManagerDelegate, LHLInputViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, IEMChatProgressDelegate, LHLChatCellDelegate, MWPhotoBrowserDelegate>

/** 消息界面 */
@property (nonatomic, strong) UITableView *tableView;
/** 输入界面 */
@property (nonatomic, strong) LHLInputView *inputView;
/** 聊天数据 */
@property (nonatomic, strong) NSMutableArray *chatMsgs;
/** 要展示的图片数组 */
@property (nonatomic, strong) NSMutableArray *chatImags;
@property (nonatomic, strong) NSMutableArray *chatThumbnailImags;

@end

@implementation LHLChatController

- (void)setBuddy:(EMBuddy *)buddy
{
    _buddy = buddy;
    self.title = buddy.username;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (LHLInputView *)inputView{
    if (_inputView == nil) {
        _inputView = [LHLInputView inputView];
        _inputView.frame = CGRectMake(0, self.view.bounds.size.height - kInputViewH, LHLScreenW, kInputViewH);
        _inputView.textField.delegate = self;
        _inputView.delegate = self;
    }
    return _inputView;
}

- (NSMutableArray *)chatMsgs
{
    if (_chatMsgs == nil) {
        _chatMsgs = [NSMutableArray array];
    }
    return _chatMsgs;
}

- (NSMutableArray *)chatImags
{
    if (_chatImags == nil) {
        _chatImags = [NSMutableArray array];
    }
    return _chatImags;
}

- (NSMutableArray *)chatThumbnailImags
{
    if (_chatThumbnailImags == nil) {
        _chatThumbnailImags = [NSMutableArray array];
    }
    return _chatThumbnailImags;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    // 添加聊天视图和输入视图
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.inputView];
    
    // 监听键盘弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lhl_keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // 获取聊天会话
    [self loadChatConversations];
    
    // 注册cell
//    [self.tableView registerClass:[LHLChatCell class] forCellReuseIdentifier:NSStringFromClass([self class])];
    // 取消选中效果 取消分割线 设置tableView背景色
    self.tableView.allowsSelection = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = LHLColor(235, 235, 235);
    
    // 添加代理,监听接收到消息
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 滚动到最后一行 为了解决首次加载控制器没有滚动到底部的情况
//    [self lhl_scrollToBottom];
}

#pragma mark - 监听键盘弹出
- (void)lhl_keyboardWillChangeFrame:(NSNotification *)noti
{
    [self lhl_scrollToBottom];
    CGRect keyboardFrame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    self.view.transform = CGAffineTransformMakeTranslation(0, keyboardFrame.origin.y - LHLScreenH);
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chatMsgs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"LHLChatCellID";
    LHLChatCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];

    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[LHLChatCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    else//当页面拉动的时候 当cell存在并且最后一个存在 把它进行删除就出来一个独特的cell我们在进行数据配置即可避免
    {
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    cell.chatFrame = self.chatMsgs[indexPath.row];
    cell.delegate = self;
    
    
    
    return cell;
}

#pragma mark - UITableViewDelegate
// 拖拽tableView的时候弹出键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    return [self.chatMsgs[indexPath.row] cellH];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    // 聊天对象
    EMChatText *text = [[EMChatText alloc] initWithText:self.inputView.textField.text];
    
    // 消息体列表
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:text];
    
    // 消息对象
    EMMessage *eMsg = [[EMMessage alloc] initWithReceiver:self.buddy.username bodies:@[body]];
    
    // 发送聊天消息
    [[EaseMob sharedInstance].chatManager
     asyncSendMessage:eMsg
     progress:nil
     prepare:^(EMMessage *message, EMError *error) {
        // 将要发送消息前的回调block
    }
     onQueue:nil
     completion:^(EMMessage *message, EMError *error) {
         
         textField.text = nil;
        // 发送消息完成后的回调
        // 发送成功后刷新列表
         [self loadChatConversations];
         
     }
     onQueue:nil];
    
    
    return YES;
}

#pragma mark - LHLInputViewDelegate
- (void)lhl_inputView:(LHLInputView *)inputView moreButtonWith:(NSInteger)morestyle
{
    UIImagePickerController *pickVC = [[UIImagePickerController alloc] init];
    pickVC.delegate = self;
    [self presentViewController:pickVC animated:YES completion:nil];
}

#pragma mark - LHLChatCellDelegate
// 点击图片调用该代理方法,浏览已经发送的图片
- (void)lhl_chatCell:(LHLChatCell *)chatCell contentClickWithChatFrame:(LHLChatFrameModel *)chatFrame
{
    MWPhotoBrowser *brower = [[MWPhotoBrowser alloc] initWithDelegate:self];
    NSInteger index = 0;
    
    if (chatFrame.chat.contentThumbnailIma) {
        index = [self.chatThumbnailImags indexOfObject:chatFrame.chat.contentThumbnailIma];
    }else{
        index = [self.chatThumbnailImags indexOfObject:chatFrame.chat.contentThumbnailImaUrl];
    }
    
    [brower setCurrentPhotoIndex:index];
    
    [self.navigationController pushViewController:brower animated:YES];
}

#pragma mark - MWPhotoBrowserDelegate
// 一共展示多少图片
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return self.chatThumbnailImags.count;
}
// 返回展示的详细图片MWPhoto对象
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    id image = self.chatImags[index];
    MWPhoto *photo = [image isKindOfClass:[UIImage class]] ? [MWPhoto photoWithImage:image] : [MWPhoto photoWithURL:image];
    
    return photo;
}
// 返回展示的预览图MWPhoto对象
- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index
{
    id image = self.chatThumbnailImags[index];
    MWPhoto *photo = [image isKindOfClass:[UIImage class]] ? [MWPhoto photoWithImage:image] : [MWPhoto photoWithURL:image];
    
    return photo;
}

#pragma mark - UINavigationControllerDelegate, UIImagePickerControllerDelegate
// 选择完照片后调用该代理方法发送图片信息
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    // 构造图片消息
    EMChatImage *chatImage = [[EMChatImage alloc] initWithUIImage:image displayName:@"666"];
    EMImageMessageBody *body = [[EMImageMessageBody alloc] initWithChatObject:chatImage];
    EMMessage *message = [[EMMessage alloc] initWithReceiver:self.buddy.username bodies:@[body]];
    
    // 防止循环引用
    __weak typeof(self) weakSelf = self;
    [[EaseMob sharedInstance].chatManager asyncSendMessage:message
                                                  progress:weakSelf
                                                   prepare:^(EMMessage *message, EMError *error) {
                                                       // 将要发送时回调
                                                   }
                                                   onQueue:nil
                                                completion:^(EMMessage *message, EMError *error) {
                                                    // 发送完成后回调
                                                    [self loadChatConversations];
                                                }
                                                   onQueue:nil];
}

#pragma mark - IEMChatProgressDelegate
// 设置进度 用户需实现此接口用以支持进度显示
- (void)setProgress:(float)progress forMessage:(EMMessage *)message forMessageBody:(id<IEMMessageBody>)messageBody
{
    
}

#pragma mark - 获取聊天会话
/*
 @brief 会话类型
 @constant eConversationTypeChat            单聊会话
 @constant eConversationTypeGroupChat       群聊会话
 @constant eConversationTypeChatRoom        聊天室会话
 */
- (void)loadChatConversations
{
    // 1.移除聊天数据数组中的所有对象
    [self.chatMsgs removeAllObjects];
    [self.chatImags removeAllObjects];
    [self.chatThumbnailImags removeAllObjects];
    
    // 2.获取环信服务器上的最新聊天数据
    EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:self.buddy.username conversationType:eConversationTypeChat];
    
    // 3.获取会话中的聊天信息(从数据库中加载消息)
    NSArray *msgs= [conversation loadAllMessages];
    long long preTime = 0;
    for (EMMessage *emsg in msgs) {
        
        if (self.chatMsgs.count) {
            
            LHLChatFrameModel *preChatFrame = [self.chatMsgs lastObject];
            preTime = preChatFrame.chat.emsg.timestamp;
        }
        
        LHLChatModel *chat = [LHLChatModel lhl_createWith:emsg preTimestamp:preTime];
        
        LHLChatFrameModel *chatFrame = [[LHLChatFrameModel alloc] init];
        chatFrame.chat = chat;
        [self.chatMsgs addObject:chatFrame];
        
        // 图片聊天
        if (chat.chatType == LHLChatTypeImage) {
            
            // 添加大图到数组中
            [self.chatImags addObject:(chat.contentIma ? chat.contentIma : chat.contentImaUrl)];
            
            // 添加小图到数组中
            [self.chatThumbnailImags addObject:(chat.contentThumbnailIma ? chat.contentThumbnailIma : chat.contentThumbnailImaUrl)];
        }
        
    }
    
    
    // 4.刷新表
    [self.tableView reloadData];
    
    // 5.滚到最后一行
    [self lhl_scrollToBottom];
}

#pragma mark - 监听接收消息
// 收到在线消息时的回调
- (void)didReceiveMessage:(EMMessage *)message
{
    NSLog(@"接收到的消息: %@", message);
    [self loadChatConversations];
}
// 接收到离线非透传消息的回调
- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages
{
     NSLog(@"接收到的消息: %@", offlineMessages);
    [self loadChatConversations];
}

#pragma mark - 滚到最后一行
- (void)lhl_scrollToBottom
{
    if (!self.chatMsgs.count) return;
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatMsgs.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

@end











