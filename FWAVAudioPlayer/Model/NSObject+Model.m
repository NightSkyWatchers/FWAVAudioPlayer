//
//  NSObject+Model.m
//  FWAVdieoPlayer
//
//  Created by zhangfuwei on 2018/8/4.
//  Copyright © 2018年 zhangfuwei. All rights reserved.
//

#import "NSObject+Model.h"
#import <objc/runtime.h>

@implementation NSObject (Model)
+ (instancetype)modelWithDictionary:(NSDictionary *)dic {
    id objc = [[self alloc] init];
    
    unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList(self, &count);
    for (int i =0; i<count; i++) {
        Ivar ivar = ivarList[i];
        const char *ivarChar = ivar_getName(ivar);
        const char *ivarType = ivar_getTypeEncoding(ivar);
        NSString *name = [NSString stringWithUTF8String:ivarChar];
        NSString *type = [NSString stringWithUTF8String:ivarType];
        
        NSString *key = [name substringFromIndex:1];
        id  value = dic[key];
        
        // 字典
        if ([value isKindOfClass:[NSDictionary class]]) {
            type = [type stringByReplacingOccurrencesOfString:@"@" withString:@""];
            type = [type stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            Class modelClass = NSClassFromString(type);
            
            // 字典转模型
            if (modelClass) {
                value = [modelClass modelWithDictionary:value];
            }
        }
        // 数组
        if ([value isKindOfClass:[NSArray class]]) {
            if ([self respondsToSelector:@selector(arrayContainModelClass)]) {
                id idSelf = self;
                NSString *type = [idSelf arrayContainModelClass][key];
                Class modelClass = NSClassFromString(type);
                NSMutableArray *arrM = [NSMutableArray array];
                
                for (NSDictionary *dic in arrM) {
                    // 字典转模型
                    id model = [modelClass modelWithDictionary:dic];
                    [arrM addObject:model];
                }
            }
        }
        
        if (value) {
            [objc setValue:value forKey:key];
        }
    }
    return objc;
}
@end
