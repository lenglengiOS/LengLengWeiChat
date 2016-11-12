//
//  LHLChatCell.h
//  EMWeiChat
//
//  Created by admin on 16/11/8.
//  Copyright © 2016年 冷洪林. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LHLChatCell, LHLChatFrameModel;
@protocol LHLChatCellDelegate <NSObject>

- (void)lhl_chatCell:(LHLChatCell *)chatCell contentClickWithChatFrame:(LHLChatFrameModel *)chatFrame;

@end

@class LHLChatFrameModel;
@interface LHLChatCell : UITableViewCell

/** chatFrame */
@property (nonatomic, strong) LHLChatFrameModel *chatFrame;
/** 代理 */
@property (nonatomic, weak) id<LHLChatCellDelegate> delegate;

@end
