//
//  BaseModel.m
//  FWAVdieoPlayer
//
//  Created by zhangfuwei on 2018/8/4.
//  Copyright © 2018年 zhangfuwei. All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>


@implementation BaseModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        unsigned int count = 0;
        // 获取类所有属性
        Ivar *ivars = class_copyIvarList(self.class, &count);
        for (int i = 0; i<count; i++) {
            // 取出i位置对应包含属性的结构体
            Ivar ivar = ivars[i];
            
            const char *keyChar = ivar_getName(ivar);
            NSString *key = [NSString stringWithUTF8String:keyChar];
            
            NSString *value = [aDecoder decodeObjectForKey:key];
            
            [self setValue:value forKey:key];
        }
        free(ivars);
    }
    return self;
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    unsigned int count = 0;
    // 获取类所有属性
    Ivar *ivars = class_copyIvarList(self.class, &count);
    for (int i = 0; i<count; i++) {
        // 取出i位置对应包含属性的结构体
        Ivar ivar = ivars[i];
        
        const char *keyChar = ivar_getName(ivar);
        NSString *key = [NSString stringWithUTF8String:keyChar];
        
        NSString *value = [self valueForKey:key];
        [aCoder encodeObject:value forKey:key];
    }
    free(ivars);
}

@end
