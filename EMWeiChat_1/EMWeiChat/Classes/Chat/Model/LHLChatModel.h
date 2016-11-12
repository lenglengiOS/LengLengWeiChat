//
//  LHLChatModel.h
//  EMWeiChat
//
//  Created by admin on 16/11/8.
//  Copyright © 2016年 冷洪林. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSInteger{
    LHLChatTypeText = eMessageBodyType_Text,
    LHLChatTypeImage = eMessageBodyType_Image,
    LHLChatTypeLocation = eMessageBodyType_Location,
    LHLChatTypeVoice = eMessageBodyType_Voice,
    LHLChatTypeVideo = eMessageBodyType_Video,
    LHLChatTypeFile = eMessageBodyType_File,
}LHLChatType;

@interface LHLChatModel : NSObject

+ (instancetype)lhl_createWith:(EMMessage *)emsg preTimestamp:(long long)preTimestamp;




/** 友盟聊天消息对象 */
@property (nonatomic, strong) EMMessage *emsg;
/** 上一条消息的时间 */
@property (nonatomic, assign) long long preTimestamp;
/** 聊天类型 */
@property (nonatomic, assign, readonly) LHLChatType chatType;




/****************** 文字聊天内容 ******************/
@property (nonatomic, copy, readonly) NSString *contentText;
/** 文字聊天的背景图 */
@property (nonatomic, strong, readonly) UIImage *contectTextBackgroundIma;
@property (nonatomic, strong, readonly) UIImage *contectTextBackgroundHLIma;




/****************** 图片聊天内容 ******************/
/** 详细大图 */
@property (nonatomic, strong, readonly) UIImage *contentIma;
/** 预览图 */
@property (nonatomic, strong, readonly) UIImage *contentThumbnailIma;
/** 详细大图url */
@property (nonatomic, strong, readonly) NSURL *contentImaUrl;
/** 预览图url */
@property (nonatomic, strong, readonly) NSURL *contentThumbnailImaUrl;
/** 是否是恒预览, 如果是YES就是横显示 */
@property (nonatomic, assign, getter=isVertical, readonly) BOOL vertical;
/** 小图的宽 */
@property (nonatomic, assign, readonly) CGFloat thumbnailW;
/** 小图的高 */
@property (nonatomic, assign, readonly) CGFloat thumbnailH;




/** 头像urlStr */
@property (nonatomic, copy, readonly) NSString *userIcon;

/** timeStr */
@property (nonatomic, copy, readonly) NSString *timeStr;
/** 是否显示时间 */
@property (nonatomic, assign, getter=isShowTime, readonly) BOOL showTime;
/** 是我还是他 */
@property (nonatomic, assign, getter=isMe, readonly) BOOL me;

@end
