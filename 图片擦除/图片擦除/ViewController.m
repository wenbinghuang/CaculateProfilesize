//
//  ViewController.m
//  图片擦除
//
//  Created by Mac on 16/10/9.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imagview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2B"]];
    [self.view addSubview:imagview];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2A"]];
    [self.view addSubview:imageView1];
    self.imageView = imageView1;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
}

- (void)pan:(UIPanGestureRecognizer*)pan
{
    CGPoint currentPoint = [pan locationInView:self.view];
    float wh = 5;
    float x = currentPoint.x - wh * 0.5;
    float y = currentPoint.y - wh * 0.5;
    CGRect eraseRect = CGRectMake(x, y, wh, wh);
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO,0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
//    [_imageView.layer renderInContext:ctx];
   
    
    [_imageView.image drawInRect:self.view.frame];

    CGContextClearRect(ctx, eraseRect);
    
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.imageView.image = image;
 
    
}

@end
