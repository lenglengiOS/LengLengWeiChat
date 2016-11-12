//
//  LHLChatFrameModel.m
//  EMWeiChat
//
//  Created by admin on 16/11/8.
//  Copyright © 2016年 冷洪林. All rights reserved.
//

#import "LHLChatFrameModel.h"
#import "LHLChatModel.h"

@interface LHLChatFrameModel ()

/** timeLab */
@property (nonatomic, assign) CGRect timeFrame;

/** 头像frame */
@property (nonatomic, assign) CGRect iconFrame;

/** 内容的frame */
@property (nonatomic, assign) CGRect contentFrame;

/** cell高度 */
@property (nonatomic, assign) CGFloat cellH;

@end

@implementation LHLChatFrameModel

- (void)setChat:(LHLChatModel *)chat
{
    _chat = chat;
    
    CGFloat screenW = LHLScreenW;
    CGFloat margin = 10;
    CGFloat timeX;
    CGFloat timeY = 0;
    CGFloat timeW;
    CGFloat timeH = chat.isShowTime ? 20 : 0;
    
    CGSize timeStrSize = [chat.timeStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName: kTimeFont}
                                                    context: nil].size;
    timeW = timeStrSize.width + 8;
    timeX = (screenW - timeW) * 0.5;
    self.timeFrame = CGRectMake(timeX, timeY, timeW, timeH);
    
    CGFloat iconX;
    CGFloat iconY = margin + CGRectGetMaxY(self.timeFrame);
    CGFloat iconW = 44;
    CGFloat iconH = iconW;
    CGFloat contentX;
    CGFloat contentY = iconY;
    CGFloat contentW;
    CGFloat contentH;
    
    switch (chat.chatType) {
        case LHLChatTypeText:
        {
           
            
            CGFloat contentMaxW = screenW - 2 * (margin + iconW + margin);
#warning contentMaxW写成contentW导致的错误
            CGSize contentStrSize = [chat.contentText boundingRectWithSize:CGSizeMake(contentMaxW, CGFLOAT_MAX)
                                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                                attributes:@{NSFontAttributeName: kContentTextFont}
                                                                   context:nil].size;
            
            contentW = contentStrSize.width + 30;
            contentH = contentStrSize.height + 30;
        }
            break;
        case LHLChatTypeImage:
        {
            if (chat.isVertical) { // 横屏
                contentH = 100;
                contentW = contentH / chat.thumbnailH * chat.thumbnailW;
            }else
            {
                contentH = 120;
                contentW = contentH / chat.thumbnailH * chat.thumbnailW;
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
    
    
    if (chat.isMe) {
        iconX = screenW - margin - iconW;
        contentX = iconX - margin - contentW;
    }else
    {
        iconX = margin;
        contentX = iconX + iconW + margin;
    }
    self.iconFrame = CGRectMake(iconX, iconY, iconW, iconH);
    self.contentFrame = CGRectMake(contentX, contentY, contentW, contentH);
    
    self.cellH = (contentH > iconH) ? CGRectGetMaxY(self.contentFrame) + margin: CGRectGetMaxY(self.iconFrame) + margin;
}

@end













