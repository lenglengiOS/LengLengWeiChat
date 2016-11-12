//
//  LHLLongPressButton.m
//  EMWeiChat
//
//  Created by admin on 16/11/8.
//  Copyright © 2016年 冷洪林. All rights reserved.
//

#import "LHLLongPressButton.h"

@implementation LHLLongPressButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longpress:)];
        [self addGestureRecognizer:longPress];
    }
    return self;
}

- (void)longpress:(UILongPressGestureRecognizer *)longPress
{
    if (self.longPressBlock) {
        self.longPressBlock(self);
    }
}

@end
