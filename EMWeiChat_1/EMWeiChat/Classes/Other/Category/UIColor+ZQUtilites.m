//
//  UIColor+ZQUtilites.m
//  FansChat
//
//  Created by Mac on 2016/10/17.
//  Copyright © 2016年 cn.fanschat. All rights reserved.
//

#import "UIColor+ZQUtilites.h"

@implementation UIColor (ZQUtilites)

+ (UIColor *)colorWithRed:(int)r green:(int)g blue:(int)b
{
    return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:1.0f];
}

+ (UIColor *)colorWithRed:(int)r green:(int)g blue:(int)b a:(CGFloat)a
{
    return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a];
}


+ (UIColor *)colorWithString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1]; //去掉头
    
    NSMutableString *str = [NSMutableString stringWithCapacity:10];
    NSInteger count = 6 - cString.length;
    for (int i = 0; i < count; i++) {
        [str appendString:@"0"];
    }
    [str appendString:cString];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [str substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [str substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [str substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:r green:g blue:b];
}

@end
