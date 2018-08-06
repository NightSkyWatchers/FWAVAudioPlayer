//
//  Person.h
//  FWAVdieoPlayer
//
//  Created by zhangfuwei on 2018/8/2.
//  Copyright © 2018年 zhangfuwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface Person : BaseModel
/** age  */
@property (nonatomic, copy) NSString *name;
/** age  */
@property (nonatomic, copy) NSString *age;
/** age  */
@property (nonatomic, copy) NSString *height;
/** age  */
@property (nonatomic, copy) NSString *weight;

- (void)run;

- (void)sing;
@end
