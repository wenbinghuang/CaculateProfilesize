//
//  ProgressView.m
//  下载进度
//
//  Created by Mac on 16/10/8.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "ProgressView.h"

@implementation ProgressView



- (void)drawRect:(CGRect)rect {
    //创建路径
    CGFloat radius = rect.size.width * 0.5;
    CGPoint center = CGPointMake(radius, radius);
   
    CGFloat endA = -M_PI_2 + _progress * M_PI * 2;
   UIBezierPath *path = [UIBezierPath  bezierPathWithArcCenter:center radius:radius - 5 startAngle:-M_PI_2 endAngle:endA clockwise:YES];
    [path stroke];
}

- (void)setProgress:(float)progress
{
    _progress = progress;
    [self setNeedsDisplay];
}


@end
