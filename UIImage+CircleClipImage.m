//
//  UIImage+CircleClipImage.m
//  图片裁剪
//
//  Created by Mac on 16/10/9.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "UIImage+CircleClipImage.h"

@implementation UIImage (CircleClipImage)

#pragma mark 裁减圆形图片
+(instancetype)clipImageWithOriginalImage:(UIImage *)image
{
    // 1、开启位图上下文，跟图片尺寸一样大
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    // 2、设置圆形裁剪区域，正切于图片
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    [path addClip];
    // 3，绘制图片
    [image drawAtPoint:CGPointZero];
    // 4、从上下文中获取图片
    UIImage *clipImage = UIGraphicsGetImageFromCurrentImageContext();
    // 5、关闭上下文
    UIGraphicsEndImageContext();
    
    return clipImage;
}

#pragma mark 裁减圆形带环的图片
+ (instancetype)clipBorderImageWithOrignalImage:(UIImage*)image borderWidth:(float)borderWidth borderColor:(UIColor*)borderColor
{
   
    //设置圆形的宽度
    CGFloat ovalW = image.size.width + 2 * borderWidth;
    
    // 1、开启上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(ovalW, ovalW), NO, 0);
    // 2、画大圆
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, ovalW, ovalW)];
    [borderColor set];
    [path fill];
    
    // 3、设置裁剪区域
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(borderWidth, borderWidth, image.size.width, image.size.height)];
    [clipPath addClip];
    
    // 4、绘制图片
    [image drawAtPoint:CGPointMake(borderWidth, borderWidth)];
    
    // 5、获取图片
    UIImage *clipImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 6、关闭上下文
    UIGraphicsEndImageContext();
    
    return clipImage;
}
@end
