//
//  LHLInputView.h
//  EMWeiChat
//
//  Created by admin on 16/11/7.
//  Copyright © 2016年 冷洪林. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LHLInputView;
@protocol LHLInputViewDelegate <NSObject>

- (void)lhl_inputView:(LHLInputView *)inputView moreButtonWith:(NSInteger)morestyle;

@end

@interface LHLInputView : UIView

@property (weak, nonatomic) IBOutlet UITextField *textField;
+ (instancetype)inputView;
/** 代理 */
@property (nonatomic, weak) id<LHLInputViewDelegate> delegate;

@end
