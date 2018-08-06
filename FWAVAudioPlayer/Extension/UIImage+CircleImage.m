//
//  UIImage+CircleImage.m
//  FWAVdieoPlayer
//
//  Created by zhangfuwei on 2018/7/31.
//  Copyright © 2018年 zhangfuwei. All rights reserved.
//

#import "UIImage+CircleImage.h"

@implementation UIImage (CircleImage)

- (UIImage *)fw_circleImage {
    
    // NO代表透明
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    
    // 获得上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 添加一个圆
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    
//    CGContextAddEllipseInRect(ctx, rect);
    CGContextAddArc(ctx, self.size.width/2, self.size.height/2, self.size.width>self.size.height ?self.size.height/2:self.size.width/2 , 0, M_PI*2, YES);

    // 裁剪
    CGContextClip(ctx);
    
    // 将图片画上去
    
    [self drawInRect:rect];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    
    UIGraphicsEndImageContext();
    
    return image;
}
@end
