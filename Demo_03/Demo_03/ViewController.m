//
//  ViewController.m
//  Demo_03
//
//  Created by fdiostwo on 2017/5/5.
//  Copyright © 2017年 FengDingKeJi. All rights reserved.
//

#import "ViewController.h"
#import "YSAudioRecord.h"
#import "YSAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<YSAudioRecordDelegate>
@property (nonatomic, strong)YSAudioRecord *recoder;

@property (nonatomic, strong)YSAudioPlayer *player;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [[UIButton alloc]init];
    button.frame = CGRectMake(100, 200, [UIScreen mainScreen].bounds.size.width - 200, 50);
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(down:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(up:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"按住录制" forState:UIControlStateNormal];
    
    UIButton *button1 = [[UIButton alloc]init];
    button1.frame = CGRectMake(100, 400, [UIScreen mainScreen].bounds.size.width - 200, 50);
    button1.backgroundColor = [UIColor redColor];
    [button1 setTitle:@"播放" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    [self.view addSubview:button1];
    
}

- (void)down:(UIButton*)sender{
    [sender setTitle:@"松开停止" forState:UIControlStateNormal];
    [self.recoder startRecordWithCompeteHandler:^(NSError *error) {
        if (error) {
            NSLog(@"%@",error.domain);
        }
    }];
    
}
- (void)up:(UIButton*)sender{
    [sender setTitle:@"按住录制" forState:UIControlStateNormal];
    [self.recoder stopRecord];
}
- (void)play:(UIButton*)sender{
    self.player.url = self.recoder.lastFilePath;
    [self.player startPlay];
}

- (YSAudioRecord *)recoder{
    if (!_recoder) {
        _recoder = [[YSAudioRecord alloc]init];
        _recoder.delegate = self;
    }
    return _recoder;
}
- (YSAudioPlayer *)player{
    if (!_player) {
        _player = [[YSAudioPlayer alloc]init];
    }
    return _player;
}

- (void)ys_peakPower:(float)power{
    NSLog(@"%f",power);
}



@end
