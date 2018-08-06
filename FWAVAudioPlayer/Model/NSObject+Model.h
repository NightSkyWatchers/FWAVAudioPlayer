//
//  NSObject+Model.h
//  FWAVdieoPlayer
//
//  Created by zhangfuwei on 2018/8/4.
//  Copyright © 2018年 zhangfuwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Model)

+ (instancetype)modelWithDictionary:(NSDictionary *)dic;

+ (instancetype)arrayContainModelClass;

@end
