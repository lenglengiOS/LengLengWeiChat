//
//  LHLInputView.m
//  EMWeiChat
//
//  Created by admin on 16/11/7.
//  Copyright © 2016年 冷洪林. All rights reserved.
//

#import "LHLInputView.h"

@interface LHLInputView ()


@end

@implementation LHLInputView

+ (instancetype)inputView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

// 点击了声音按钮
- (IBAction)typeChangeBtn:(id)sender {
    
}

// 点击了加号按钮
- (IBAction)sendMoreBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(lhl_inputView:moreButtonWith:)]) {
        [self.delegate lhl_inputView:self moreButtonWith:0];
    }
}

// 点击了表情按钮
- (IBAction)expressionBtn:(id)sender {
    
}

@end










