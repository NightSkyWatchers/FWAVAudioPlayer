//
//  ViewController.m
//  FWAVdieoPlayer
//
//  Created by zhangfuwei on 2018/3/26.
//  Copyright © 2018年 zhangfuwei. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<AVAudioPlayerDelegate>
/** audio  */
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;


@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UIImageView *middleMeter;
@property (strong, nonatomic) IBOutlet UIView *leftMeter;
@property (strong, nonatomic) IBOutlet UIView *rightMeter;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *meterH;

@end


@implementation ViewController {
    NSTimer *_timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRandomBackgroundColor];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self.audioPlayer stop];
}

- (void)dealloc {
    [_timer invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)stopBtnClick:(id)sender {
    [self.audioPlayer stop];

    
}
- (IBAction)playBtnClick:(id)sender {
    if (self.audioPlayer.isPlaying) {
        [self.audioPlayer pause];
        _timer.fireDate=[NSDate distantFuture];//暂停定时器

    }else {
        [self.audioPlayer play];
        _timer.fireDate=[NSDate distantPast];//恢复定时器

    }

}


- (void)updateProgress {
    self.progress.progress = self.audioPlayer.currentTime/self.audioPlayer.duration;
    [self.audioPlayer updateMeters];
    CGFloat meter = (CGFloat)[self.audioPlayer peakPowerForChannel:1];
    if (meter<0&& meter>-160) {
        self.meterH.constant  = -meter/20 *130;

    }else if (meter>0){
        self.meterH.constant  = meter/20 *130;

    }else {
        self.meterH.constant = 130;
    }

    [self.view setNeedsDisplay];
}

- (void)routeChange:(NSNotification *)noti {
    NSDictionary *userInfo=noti.userInfo;
    int changeReason= [userInfo[AVAudioSessionRouteChangeReasonKey] intValue];
    //等于AVAudioSessionRouteChangeReasonOldDeviceUnavailable表示旧输出不可用
    if (changeReason==AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        AVAudioSessionRouteDescription *route=userInfo[AVAudioSessionRouteChangePreviousRouteKey];
        AVAudioSessionPortDescription *port= [route.outputs firstObject];
        //原设备为耳机则暂停
        if ([port.portType isEqualToString:@"Headphones"]) {
            [self stopBtnClick:nil];
        }
    }
}

- (AVAudioPlayer *)audioPlayer {
    if (!_audioPlayer) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"bukeyi" ofType:@"mp3"];
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:path] error:nil];
        _audioPlayer.meteringEnabled = YES;
        [_audioPlayer prepareToPlay];
        
        //设置后台播放模式
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        [audioSession setActive:YES error:nil];

        //添加通知，拔出耳机后暂停播放
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routeChange:) name:AVAudioSessionRouteChangeNotification object:nil];
    }
    return _audioPlayer;
}
@end
