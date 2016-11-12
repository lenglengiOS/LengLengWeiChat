//
//  UIImage+image.m
//  百思不得姐(环境部署)
//
//  Created by admin on 16/9/13.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "UIImage+image.h"

@implementation UIImage (image)

// 不要系统自动渲染
+ (UIImage *)imageOriginalWithName:(NSString *)imageName{
    
    UIImage *image = [UIImage imageNamed:imageName];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
}


// 裁剪圆形图片(对象方法)
- (instancetype)lhl_circleImage
{
    // 1.开启上下文
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 1);
    // 2.描述裁剪区域
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    // 3.设置裁剪区域
    [path addClip];
    // 4.画图片
    [self drawAtPoint:CGPointZero];
    // 5.取出图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 6.关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}
// 裁剪圆形图片(类方法)
+ (instancetype)lhl_circleImageNamed:(NSString *)name{
    
    return [[self imageNamed:name] lhl_circleImage];
}

// 根据颜色生成图片
+ (UIImage *)lhl_imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

// 根据图片名称拉伸聊天图片
+ (UIImage *)lhl_resizingWithImaName:(NSString *)iconName
{
    return [self lhl_resizingWithIma: [UIImage imageNamed: iconName]];
}

// 根据图片拉伸聊天图片
+ (UIImage *)lhl_resizingWithIma:(UIImage *)ima
{
    CGFloat w = ima.size.width * 0.499;
    CGFloat h = ima.size.height * 0.499;
    return [ima resizableImageWithCapInsets: UIEdgeInsetsMake(h, w, h, w)];
}

@end
