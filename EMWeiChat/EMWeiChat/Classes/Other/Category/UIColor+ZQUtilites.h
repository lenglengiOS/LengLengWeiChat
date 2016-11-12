//
//  UIColor+ZQUtilites.h
//  FansChat
//
//  Created by Mac on 2016/10/17.
//  Copyright © 2016年 cn.fanschat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ZQUtilites)

+ (UIColor *)colorWithRed:(int)r green:(int)g blue:(int)b;
+ (UIColor *)colorWithRed:(int)r green:(int)g blue:(int)b a:(CGFloat)a;
+ (UIColor *)colorWithString:(NSString *)stringToConvert;

@end
