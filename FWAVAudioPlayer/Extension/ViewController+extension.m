//
//  ViewController+extension.m
//  FWAVdieoPlayer
//
//  Created by zhangfuwei on 2018/7/30.
//  Copyright © 2018年 zhangfuwei. All rights reserved.
//

#import "ViewController+extension.h"


@implementation UIViewController (extension)

-(void)setRandomBackgroundColor {
     self.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1];
}

@end
