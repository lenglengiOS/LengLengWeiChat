//
//  LHLChatFrameModel.h
//  EMWeiChat
//
//  Created by admin on 16/11/8.
//  Copyright © 2016年 冷洪林. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kTimeFont [UIFont systemFontOfSize:11.0]
#define kContentTextFont [UIFont systemFontOfSize:15.0]

@class LHLChatModel;
@interface LHLChatFrameModel : NSObject

/** 注释 */
@property (nonatomic, strong) LHLChatModel *chat;

/**>>>>>下面都是布局属性>>>>>>*/
/** timeLab */
@property (nonatomic, assign, readonly) CGRect timeFrame;

/** 头像frame */
@property (nonatomic, assign, readonly) CGRect iconFrame;

/** 内容的frame */
@property (nonatomic, assign, readonly) CGRect contentFrame;

/** cell高度 */
@property (nonatomic, assign, readonly) CGFloat cellH;


@end
