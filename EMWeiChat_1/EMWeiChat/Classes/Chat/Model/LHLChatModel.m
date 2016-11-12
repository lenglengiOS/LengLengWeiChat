//
//  LHLChatModel.m
//  EMWeiChat
//
//  Created by admin on 16/11/8.
//  Copyright © 2016年 冷洪林. All rights reserved.
//

#import "LHLChatModel.h"
#import "NSString+LHLTimestamp.h"

@interface LHLChatModel ()




/*************** 文字聊天内容 ***************/
@property (nonatomic, copy) NSString *contentText;




/*************** 图片聊天内容 ***************/
/** 详细大图 */
@property (nonatomic, strong) UIImage *contentIma;
/** 小图 */
@property (nonatomic, strong) UIImage *contentThumbnailIma;
/** 详细大图url */
@property (nonatomic, strong) NSURL *contentImaUrl;
/** 小图url */
@property (nonatomic, strong) NSURL *contentThumbnailImaUrl;
/** 是否是恒预览, 如果是YES就是横显示 */
@property (nonatomic, assign, getter=isVertical) BOOL vertical;
/** 小图的宽 */
@property (nonatomic, assign) CGFloat thumbnailW;
/** 小图的高 */
@property (nonatomic, assign) CGFloat thumbnailH;




/** 文字聊天的背景图 */
@property (nonatomic, strong) UIImage *contectTextBackgroundIma;
@property (nonatomic, strong) UIImage *contectTextBackgroundHLIma;
/** 头像urlStr */
@property (nonatomic, copy) NSString *userIcon;
/** timeStr */
@property (nonatomic, copy) NSString *timeStr;
/** 是否显示时间 */
@property (nonatomic, assign, getter=isShowTime) BOOL showTime;
/** 是我还是他 */
@property (nonatomic, assign, getter=isMe) BOOL me;
/** 聊天类型 */
@property (nonatomic, assign) LHLChatType chatType;




@end

@implementation LHLChatModel

+ (instancetype)lhl_createWith:(EMMessage *)emsg preTimestamp:(long long)preTimestamp
{
    
    LHLChatModel *chat = [[LHLChatModel alloc] init];
    chat.preTimestamp = preTimestamp;
    chat.emsg = emsg;
    return chat;
}


- (void)setEmsg:(EMMessage *)emsg
{
    _emsg = emsg;
    
    NSString *loginUser = [[EaseMob sharedInstance].chatManager loginInfo][@"username"];
    if ([loginUser isEqualToString:emsg.from]) {
        self.me = YES;
        self.userIcon = @"xhr";
        self.contectTextBackgroundIma = [UIImage imageNamed: @"SenderTextNodeBkg"];
        self.contectTextBackgroundHLIma = [UIImage imageNamed: @"SenderTextNodeBkgHL"];
    }else
    {
        self.me = NO;
        self.userIcon = @"add_friend_icon_offical";
        self.contectTextBackgroundIma = [UIImage imageNamed: @"ReceiverTextNodeBkg"];
        self.contectTextBackgroundHLIma = [UIImage imageNamed: @"ReceiverTextNodeBkgHL"];
    }
    
    self.showTime = ABS(emsg.timestamp - self.preTimestamp) > 6000;
    self.timeStr = [NSString lhl_convastionTimeStr: emsg.timestamp];

    
    // 解析消息内容
    id<IEMMessageBody> msgBody = emsg.messageBodies.firstObject;
    // 直接为聊天类型赋值
    self.chatType = (LHLChatType)msgBody.messageBodyType;
    switch (msgBody.messageBodyType) {
        case eMessageBodyType_Text:
        {
            // 收到的文字消息
            NSString *txt = ((EMTextMessageBody *)msgBody).text;
            NSLog(@"收到的文字是 txt -- %@",txt);
            
            self.contentText = txt;
        }
            break;
        case eMessageBodyType_Image:
        {
            // 得到一个图片消息body
            EMImageMessageBody *body = ((EMImageMessageBody *)msgBody);
            NSLog(@"大图remote路径 -- %@"   ,body.remotePath);
            NSLog(@"大图local路径 -- %@"    ,body.localPath); // // 需要使用SDK提供的下载方法后才会存在
            NSLog(@"大图的secret -- %@"    ,body.secretKey);
            NSLog(@"大图的W -- %f ,大图的H -- %f",body.size.width,body.size.height);
            NSLog(@"大图的下载状态 -- %lu",body.attachmentDownloadStatus);
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:body.localPath]) {
                
                self.contentIma = [UIImage imageWithContentsOfFile:body.localPath];
            }
            self.contentImaUrl = [NSURL URLWithString:body.remotePath];
            
            // 缩略图sdk会自动下载
            NSLog(@"小图remote路径 -- %@"   ,body.thumbnailRemotePath);
            NSLog(@"小图local路径 -- %@"    ,body.thumbnailLocalPath);
            NSLog(@"小图的secret -- %@"    ,body.thumbnailSecretKey);
            NSLog(@"小图的W -- %f ,小图的H -- %f",body.thumbnailSize.width,body.thumbnailSize.height);
            NSLog(@"小图的下载状态 -- %lu",body.thumbnailDownloadStatus);
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:body.thumbnailLocalPath]) {
                
                self.contentThumbnailIma = [UIImage imageWithContentsOfFile:body.thumbnailLocalPath];
            }
            self.contentThumbnailImaUrl = [NSURL URLWithString:body.thumbnailRemotePath];
            // 如果小图的宽大于高 那么就是横屏幕
            self.vertical = body.thumbnailSize.width > body.thumbnailSize.height;
            self.thumbnailW = body.thumbnailSize.width;
            self.thumbnailH = body.thumbnailSize.height;
            
        }
            break;
        case eMessageBodyType_Location:
        {
            EMLocationMessageBody *body = (EMLocationMessageBody *)msgBody;
            NSLog(@"纬度-- %f",body.latitude);
            NSLog(@"经度-- %f",body.longitude);
            NSLog(@"地址-- %@",body.address);
        }
            break;
        case eMessageBodyType_Voice:
        {
            // 音频SDK会自动下载
            EMVoiceMessageBody *body = (EMVoiceMessageBody *)msgBody;
            NSLog(@"音频remote路径 -- %@"      ,body.remotePath);
            NSLog(@"音频local路径 -- %@"       ,body.localPath); // 需要使用SDK提供的下载方法后才会存在（音频会自动调用）
            NSLog(@"音频的secret -- %@"        ,body.secretKey);
            NSLog(@"音频文件大小 -- %lld"       ,body.fileLength);
            NSLog(@"音频文件的下载状态 -- %lu"   ,body.attachmentDownloadStatus);
            NSLog(@"音频的时间长度 -- %lu"      ,body.duration);
        }
            break;
        case eMessageBodyType_Video:
        {
            EMVideoMessageBody *body = (EMVideoMessageBody *)msgBody;
            
            NSLog(@"视频remote路径 -- %@"      ,body.remotePath);
            NSLog(@"视频local路径 -- %@"       ,body.localPath); // 需要使用SDK提供的下载方法后才会存在
            NSLog(@"视频的secret -- %@"        ,body.secretKey);
            NSLog(@"视频文件大小 -- %lld"       ,body.fileLength);
            NSLog(@"视频文件的下载状态 -- %lu"   ,body.attachmentDownloadStatus);
            NSLog(@"视频的时间长度 -- %lu"      ,body.duration);
            NSLog(@"视频的W -- %f ,视频的H -- %f", body.size.width, body.size.height);
            
            // 缩略图sdk会自动下载
            NSLog(@"缩略图的remote路径 -- %@"     ,body.thumbnailRemotePath);
            NSLog(@"缩略图的local路径 -- %@"      ,body.thumbnailRemotePath);
            NSLog(@"缩略图的secret -- %@"        ,body.thumbnailSecretKey);
            NSLog(@"缩略图的下载状态 -- %lu"      ,body.thumbnailDownloadStatus);
        }
            break;
        case eMessageBodyType_File:
        {
            EMFileMessageBody *body = (EMFileMessageBody *)msgBody;
            NSLog(@"文件remote路径 -- %@"      ,body.remotePath);
            NSLog(@"文件local路径 -- %@"       ,body.localPath); // 需要使用SDK提供的下载方法后才会存在
            NSLog(@"文件的secret -- %@"        ,body.secretKey);
            NSLog(@"文件文件大小 -- %lld"       ,body.fileLength);
            NSLog(@"文件文件的下载状态 -- %lu"   ,body.attachmentDownloadStatus);
        }
            break;
            
        default:
            break;
    }

}

@end
