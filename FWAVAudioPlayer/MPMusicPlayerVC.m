//
//  MPMusicPlayerVC.m
//  FWAVdieoPlayer
//
//  Created by zhangfuwei on 2018/7/17.
//  Copyright © 2018年 zhangfuwei. All rights reserved.
//

#import "MPMusicPlayerVC.h"
#import "UIImageView+CornerRadius.h"
#import "UIImage+CircleImage.h"


@interface MPMusicPlayerVC ()
/** copy  */
@property (nonatomic, strong) NSArray *arr;
@property (nonatomic, strong) NSMutableArray *mutArr;

/** imageV  */
@property (nonatomic, strong) UIImageView *imageV;
/** imageV  */
@property (nonatomic, strong) UIImageView *imageV2;

@end

@implementation MPMusicPlayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRandomBackgroundColor];
    
    CGFloat height = [UIScreen mainScreen].bounds.size.height/2-40;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, width, height)];
    self.imageV2 = [[UIImageView alloc] initWithFrame:CGRectMake(0,height+22, width, height)];
    
    
    [self.view addSubview:self.imageV];
    [self.view addSubview:self.imageV2];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.mutArr = [NSMutableArray arrayWithObjects:@"1",@"2",@"4",@"3", nil];
    
    self.arr = self.mutArr.copy;
    
    [self.mutArr removeObjectAtIndex:0];
    
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGFloat corner = 10;
    UIImage *image =  [UIImage imageNamed:[NSString stringWithFormat:@"guide_%u",arc4random_uniform(5)+1]];
    
    self.imageV.image = [image fw_circleImage];
    [self.imageV2 fw_setCircleImage:image];
//    [self.imageV2 fw_setCornerRadius:corner image:image];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
