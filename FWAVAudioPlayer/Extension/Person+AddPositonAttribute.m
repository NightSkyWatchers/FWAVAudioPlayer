//
//  Person+AddPositonAttribute.m
//  FWAVdieoPlayer
//
//  Created by zhangfuwei on 2018/8/3.
//  Copyright © 2018年 zhangfuwei. All rights reserved.
//

#import "Person+AddPositonAttribute.h"
#import <objc/runtime.h>
@implementation Person (AddPositonAttribute)

- (void)setPosition:(NSString *)position {
    objc_setAssociatedObject(self, @"position", position, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


- (NSString *)position {
    return (NSString *)objc_getAssociatedObject(self, @"position");
}
@end
