//
//  UIImage+JXExtension.m
//  JXUIKit
//
//  Created by 朱佳翔 on 2017/2/27.
//  Copyright © 2017年 zjx. All rights reserved.
//

#import "UIImage+JXExtension.h"

@implementation UIImage (JXExtension)

+ (instancetype)jx_imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
