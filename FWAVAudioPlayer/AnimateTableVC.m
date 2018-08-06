//
//  AnimateTableVC.m
//  FWAVdieoPlayer
//
//  Created by zhangfuwei on 2018/7/30.
//  Copyright © 2018年 zhangfuwei. All rights reserved.
//

#import "AnimateTableVC.h"

/** note */
static NSString *const kReuseID            = @"reuseID";

@interface AnimateTableVC ()<UITableViewDelegate,UITableViewDataSource>
/** tableView  */
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation AnimateTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRandomBackgroundColor];

    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self animateTableView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)animateTableView {
    NSArray *arr = self.tableView.visibleCells;
    CGFloat height = self.tableView.bounds.size.height;
    
    [arr enumerateObjectsUsingBlock:^(UITableViewCell *cell, NSUInteger idx, BOOL * _Nonnull stop) {
        cell.transform = CGAffineTransformMakeTranslation(0, height);
        
        [UIView animateWithDuration:1.0 delay:0.2*idx usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionTransitionNone animations:^{
            cell.transform = CGAffineTransformMakeTranslation(0, 0);
        } completion:nil];
    }];
}
#pragma mark --- 代理数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseID forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"section- %ld,row-%ld",indexPath.section,indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [UIView animateWithDuration:0.2 animations:^{
        cell.transform = CGAffineTransformMakeScale(0.9, 0.9);
    }];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [UIView animateWithDuration:0.2 animations:^{
        cell.transform = CGAffineTransformIdentity;
    }];
}
#pragma mark --- LAZYLoad
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        //设置内容缩进
        _tableView.estimatedRowHeight = 37;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
        _tableView.scrollIndicatorInsets = self.tableView.contentInset;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        //        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kReuseID];
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}

@end
