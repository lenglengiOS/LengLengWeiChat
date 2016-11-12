//
//  LHLLongPressButton.h
//  EMWeiChat
//
//  Created by admin on 16/11/8.
//  Copyright © 2016年 冷洪林. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LHLLongPressButton;
typedef void(^LHLLongPressBlock)(LHLLongPressButton *btn);

@interface LHLLongPressButton : UIButton

/** 长按block */
@property (nonatomic, copy) LHLLongPressBlock longPressBlock;

@end
