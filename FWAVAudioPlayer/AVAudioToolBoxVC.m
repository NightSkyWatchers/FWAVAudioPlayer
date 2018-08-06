//
//  AVAudioToolBoxVC.m
//  FWAVdieoPlayer
//
//  Created by zhangfuwei on 2018/7/17.
//  Copyright © 2018年 zhangfuwei. All rights reserved.
//

#import "AVAudioToolBoxVC.h"
#import <AudioToolbox/AudioToolbox.h>
#import <objc/runtime.h>
#import "Person+AddPositonAttribute.h"


@interface AVAudioToolBoxVC ()
/** run  */
@property (nonatomic, strong) UIButton *runButton;

/** sing  */
@property (nonatomic, strong) UIButton *exchangeButton;


/** showLabel  */
@property (nonatomic, strong) UILabel *showLabel;
/** stu  */
@property (nonatomic, strong) Person *stu;

@end

@implementation AVAudioToolBoxVC {
    Person      *_stu;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRandomBackgroundColor];
    
    [self.view addSubview:self.runButton];
    [self.view addSubview:self.exchangeButton];

}

- (void)replaceRunMethod {
    NSLog(@"拦截提换为新run方法");
}

- (void)personRun:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
            [self.stu run];
            break;
        case 2:
            [self.stu sing];
            break;
        case 3:{
            // MARK: 交换Person的两个方法实现run 、sing
            Method run = class_getInstanceMethod(self.stu.class, @selector(run));
            Method sing = class_getInstanceMethod(self.stu.class, @selector(sing));
            method_exchangeImplementations(run, sing);
            self.showLabel.text = @"交换person的run和sing的方法实现";

        }
            break;
        case 4:{
            // MARK: 交换Person的两个方法实现run 、sing
            Method oldRun = class_getInstanceMethod(self.stu.class, @selector(run));
            Method newRun = class_getInstanceMethod(self.class, @selector(replaceRunMethod));
            method_exchangeImplementations(oldRun, newRun);
            self.showLabel.text = @"拦截替换之后--newrun";

        }
            break;
        case 5:{
            // MARK: 遍历属性列表，修改指定属性的值
            unsigned int count = 0;
            Ivar *ivar = class_copyIvarList(self.stu.class, &count);
            for (int i = 0; i< count; i++) {
                Ivar tempIvar = ivar[i];
                const char *varChar = ivar_getName(tempIvar);
                NSString *varString = [NSString stringWithUTF8String:varChar];
                if ([varString isEqualToString:@"_age"]) {
                    object_setIvar(self.stu, tempIvar, @"13");
                }
            }
            self.showLabel.text = [NSString stringWithFormat:@"改变后，stu 的 age = %@",self.stu.age];
        }
            break;
        case 6:{
            // MARK: 分类为Person增添一个属性
            self.stu.position = @"ban zhang";
            self.showLabel.text = [NSString stringWithFormat:@"新增了一个属性，stu 的 position = %@",self.stu.position];

        }
            break;
        case 7:{
            // MARK: 为Person增添一个eatting方法
            
            class_addMethod(self.stu.class, @selector(personEatting),(IMP)personEatting, "v@:");
            if ([self.stu respondsToSelector:@selector(personEatting)]) {
                [self.stu performSelector:@selector(personEatting)];
                
                self.showLabel.text = @"添加 eatting 方法成功";
            }else {
                self.showLabel.text = @"添加 eatting 方法失败";
            }
        }
            break;
        default:
            break;
    }
}

- (void)exchangeMethod:(UIButton *)sender {
    if (self.runButton.tag<7) {
        self.runButton.tag++;
        NSString *title;
        if (self.runButton.tag == 2) {
            title = @"sing";
        }else if (self.runButton.tag == 3){
            title = @"exchange";
        }else if (self.runButton.tag == 4){
            title = @"holdReplace";
        }else if (self.runButton.tag == 5){
            title = @"modifyAttribute";
        }else if (self.runButton.tag == 6){
            title = @"addNewAttribute";
        }else if (self.runButton.tag == 7){
            title = @"addNewMethod";
        }
        [self.runButton setTitle:title forState:UIControlStateNormal];

    }else {
        self.runButton.tag = 1;
        [self.runButton setTitle:@"run" forState:UIControlStateNormal];
    }
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self playSoundEffect:@"bukeyi.mp3"];
    self.showLabel.text = [NSString stringWithFormat:@"stu 的 age = %@",self.stu.age];
}




void personEatting (id self , SEL _cmd){
    NSLog(@"person eatting ");
}
/**
 *  播放完成回调函数
 *
 *  @param soundID    系统声音ID
 *  @param clientData 回调时传递的数据
 */
void soundCompleteCallback(SystemSoundID soundID,void * clientData){
    NSLog(@"播放完成...");
}

/**
 *  播放音效文件
 *
 *  @param name 音频文件名称
 */
-(void)playSoundEffect:(NSString *)name{
    NSString *audioFile=[[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl=[NSURL fileURLWithPath:audioFile];
    //1.获得系统声音ID
    SystemSoundID soundID=0;
    /**
     * inFileUrl:音频文件url
     * outSystemSoundID:声音id（此函数会将音效文件加入到系统音频服务中并返回一个长整形ID）
     */
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    //如果需要在播放完之后执行某些操作，可以调用如下方法注册一个播放完成回调函数
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    //2.播放音频
    AudioServicesPlaySystemSound(soundID);//播放音效
    //    AudioServicesPlayAlertSound(soundID);//播放音效并震动
}

#pragma mark --- lazyLoad

- (Person *)stu {
    if (!_stu) {
        _stu = [[Person alloc] init];
        _stu.name = @"Tom";
        _stu.age = @"23";
        _stu.height = @"178";
        _stu.weight = @"80";
    }
    return _stu;
}

- (UIButton *)runButton {
    if (!_runButton) {
        _runButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 100, 150, 20)];
        [_runButton setTitle:@"run" forState:UIControlStateNormal];
        _runButton.tag = 1;
        [_runButton addTarget:self action:@selector(personRun:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _runButton;
}

- (UIButton *)exchangeButton {
    if (!_exchangeButton) {
        _exchangeButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 200, 150, 20)];
        [_exchangeButton setTitle:@"exchange" forState:UIControlStateNormal];
        [_exchangeButton addTarget:self action:@selector(exchangeMethod:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exchangeButton;
}

- (UILabel *)showLabel {
    if (!_showLabel) {
        _showLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 250, self.view.bounds.size.width, 50)];
//        _showLabel.text = @"展示";
        [self.view addSubview:_showLabel];
    }
    return _showLabel;
}

@end
