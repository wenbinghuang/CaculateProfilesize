//
//  UIImage+CircleClipImage.h
//  图片裁剪
//
//  Created by Mac on 16/10/9.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CircleClipImage)
+ (instancetype)clipImageWithOriginalImage:(UIImage*)image;

+ (instancetype)clipBorderImageWithOrignalImage:(UIImage*)image borderWidth:(float)borderWidth borderColor:(UIColor*)borderColor;
@end
