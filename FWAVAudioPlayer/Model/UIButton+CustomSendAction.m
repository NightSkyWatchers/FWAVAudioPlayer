//
//  UIButton+CustomSendAction.m
//  FWAVdieoPlayer
//
//  Created by zhangfuwei on 2018/8/4.
//  Copyright © 2018年 zhangfuwei. All rights reserved.
//

#import "UIButton+CustomSendAction.h"
#import <objc/runtime.h>


@implementation UIButton (CustomSendAction)

+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method oriMethod = class_getInstanceMethod(self.class, @selector(sendAction:to:forEvent:));
        Method cusMethod = class_getInstanceMethod(self.class, @selector(customSendAction:to:forEvent:));

        // 替换系统方法的实现为自定义方法实现
        BOOL addSuccess = class_addMethod(self.class, @selector(sendAction:to:forEvent:), method_getImplementation(cusMethod), method_getTypeEncoding(cusMethod));

        if (addSuccess) {
            // 如果添加成功， 替换自定义方法实现为系统方法的实现
            class_replaceMethod(self.class, @selector(customSendAction:to:forEvent:), method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
        }else {
            // 如果没有添加成功，就交换方法
            method_exchangeImplementations(oriMethod, cusMethod);
        }
    });
}

- (void)customSendAction:(SEL)action to:(nullable id)target forEvent:(nullable UIEvent *)event {
    [super sendAction:action to:target forEvent:event];
    NSLog(@"自定义方法---");
}


//- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
//    [super sendAction:action to:target forEvent:event];
//    NSLog(@"自定义方法---");
//}
@end
