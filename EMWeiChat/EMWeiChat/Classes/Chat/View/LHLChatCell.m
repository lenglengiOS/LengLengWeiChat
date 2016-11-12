//
//  LHLChatCell.m
//  EMWeiChat
//
//  Created by admin on 16/11/8.
//  Copyright © 2016年 冷洪林. All rights reserved.
//

#import "LHLChatCell.h"
#import "LHLLongPressButton.h"
#import "LHLChatModel.h"
#import "LHLChatFrameModel.h"
#import "UIButton+WebCache.h"

@interface LHLChatCell ()

/** 消息发送时间 */
@property (nonatomic, weak) UILabel *timeLab;
/** 用户头像 */
@property (nonatomic, weak) LHLLongPressButton *userIconBtn;
/** 聊天内容 */
@property (nonatomic, weak) LHLLongPressButton *contentBtn;

@end

@implementation LHLChatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 设置背景色
        self.backgroundColor = LHLColor(235, 235, 235);
        // 添加子控件
        UILabel *timeLab = [[UILabel alloc] init];
        timeLab.backgroundColor = LHLColor(206, 206, 206);
        timeLab.textColor = [UIColor whiteColor];
        timeLab.textAlignment = NSTextAlignmentCenter;
        timeLab.font = kTimeFont;
        timeLab.layer.cornerRadius = 4;
        timeLab.layer.masksToBounds = YES;
        [self.contentView addSubview:timeLab];
        self.timeLab = timeLab;
        
        LHLLongPressButton *userIconBtn = [[LHLLongPressButton alloc] init];
        userIconBtn.longPressBlock = ^(LHLLongPressButton *btn){
            // 长按时的业务逻辑处理
            
        };
        [userIconBtn addTarget:self action:@selector(lhl_showDetailUserInfo) forControlEvents: UIControlEventTouchUpInside];
        [self.contentView addSubview: userIconBtn];
        self.userIconBtn = userIconBtn;
        
        LHLLongPressButton *contentBtn = [[LHLLongPressButton alloc] init];
        contentBtn.longPressBlock = ^(LHLLongPressButton *btn){
            // 长按时的业务逻辑处理
        };
        contentBtn.titleLabel.font = kContentTextFont;
        contentBtn.titleLabel.numberOfLines = 0;
        
        [contentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [contentBtn addTarget:self action:@selector(lhl_contentChatTouchUpInside) forControlEvents: UIControlEventTouchUpInside];
        [self.contentView addSubview: contentBtn];
        self.contentBtn = contentBtn;
        
        
    }
    return self;
}

- (void)setChatFrame:(LHLChatFrameModel *)chatFrame
{
    _chatFrame = chatFrame;
    // 给子控件赋值
    LHLChatModel *chat = chatFrame.chat;
    self.timeLab.text = chat.timeStr;
    
    // 如果是从网络获取的图片,此处应该用SDWebImage根据URL取图片
    [self.userIconBtn setImage:[UIImage imageNamed:chat.userIcon] forState:UIControlStateNormal];
    [self.contentBtn setBackgroundImage:[UIImage lhl_resizingWithIma:chat.contectTextBackgroundIma] forState:UIControlStateNormal];
    [self.contentBtn setBackgroundImage:[UIImage lhl_resizingWithIma:chat.contectTextBackgroundHLIma] forState:UIControlStateHighlighted];
    
    switch (chat.chatType) {
        case LHLChatTypeText:
        {
            self.contentBtn.contentEdgeInsets = UIEdgeInsetsMake(10, 15, 20, 15);
            [self.contentBtn setTitle:chat.contentText forState:UIControlStateNormal];
        }
            break;
        case LHLChatTypeImage:
        {
            self.contentBtn.contentEdgeInsets = UIEdgeInsetsMake(10, 15, 20, 15);
            if (chat.contentThumbnailIma) {
                [self.contentBtn setImage:chat.contentThumbnailIma forState:UIControlStateNormal];
            }else
            {
                // 用SDWebImage对图片进行赋值
                [self.contentBtn sd_setImageWithURL:chat.contentThumbnailImaUrl forState:UIControlStateNormal];
            }
        }
            break;
        case LHLChatTypeFile:
        {
            
        }
            break;
        case LHLChatTypeLocation:
        {
            
        }
            break;
        case LHLChatTypeVideo:
        {
            
        }
            break;
        case LHLChatTypeVoice:
        {
            
        }
            break;
            
        default:
            break;
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 布局子控件
    self.timeLab.frame = self.chatFrame.timeFrame;
    self.userIconBtn.frame = self.chatFrame.iconFrame;
    self.contentBtn.frame = self.chatFrame.contentFrame;
}

#pragma mark - 私有方法
- (void)lhl_showDetailUserInfo
{
    NSLog(@"点击了用户头像 %s", __func__);
}

- (void)lhl_contentChatTouchUpInside
{
    NSLog(@"点击了对话消息 %s", __func__);
    switch (self.chatFrame.chat.chatType) {
        case LHLChatTypeText:
        {
            
        }
            break;
        case LHLChatTypeImage:
        {
            if ([self.delegate respondsToSelector:@selector(lhl_chatCell:contentClickWithChatFrame:)]) {
                [self.delegate lhl_chatCell:self contentClickWithChatFrame:self.chatFrame];
            }
        }
            break;
        case LHLChatTypeVoice:
        {
            
        }
            break;
        case LHLChatTypeVideo:
        {
            
        }
            break;
        case LHLChatTypeLocation:
        {
            
        }
            break;
        case LHLChatTypeFile:
        {
            
        }
            break;
            
        default:
            break;
    }
}

@end












