//
//  UIImageView+CornerRadius.m
//  FWAVdieoPlayer
//
//  Created by zhangfuwei on 2018/7/30.
//  Copyright © 2018年 zhangfuwei. All rights reserved.
//

#import "UIImageView+CornerRadius.h"

@implementation UIImageView (CornerRadius)
//  贝塞尔曲线
- (void)fw_setCornerRadius:(CGFloat)corner image:(UIImage *)image {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 1.0);
    [[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:corner] addClip];
    
    [image drawInRect:self.bounds];
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)fw_setCircleImage:(UIImage *)image {

    // NO代表透明
    self.image = image;
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    
    // 获得上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 添加一个圆
    CGRect rect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    
//    CGContextAddEllipseInRect(ctx, rect);
    CGContextAddArc(ctx, self.bounds.size.width/2, self.bounds.size.height/2, self.bounds.size.width>self.bounds.size.height ?self.bounds.size.height/2:self.bounds.size.width/2 , 0, M_PI*2, YES);
    // 裁剪
    CGContextClip(ctx);
    
    // 将图片画上去
    [self drawRect:rect];
    
    UIImage *circleImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    self.image = circleImage;
}
@end
