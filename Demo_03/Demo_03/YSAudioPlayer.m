//
//  YSAudioPlayer.m
//  Demo_01
//
//  Created by fdiostwo on 2017/5/10.
//  Copyright © 2017年 FengDingKeJi. All rights reserved.
//

#import "YSAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface YSAudioPlayer ()<AVAudioPlayerDelegate>

@property (nonatomic, strong)AVAudioPlayer *player;

@end

@implementation YSAudioPlayer

- (BOOL)startPlayWithCompeteHandler:(void (^)(NSError *))competeHandler{
    
    NSLog(@"播放的URL:%@",_url);
    
    if (_url && ![_player isPlaying]) {
        
        NSURL *url = [NSURL fileURLWithPath:_url];
        
        NSError *error = nil;
        
        _player.delegate = nil;
        
        _player = nil;
        
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        
        _player.numberOfLoops = 0;
        
        _player.volume = 1;
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        
        _player.delegate = self;
        
        [_player prepareToPlay];
        
        BOOL Success = [_player play];
        
        if (error) {
            
            competeHandler ?: competeHandler(error);
            return NO;
            
        }else{
            
            if (Success) {
                competeHandler ?: competeHandler(nil);
                return YES;
                
            }else{
                error = [NSError errorWithDomain:@"播放失败" code:201 userInfo:nil];
                competeHandler ?: competeHandler(error);
                return NO;
            }
        }
        
    }else{
        return NO;
    }
}

- (void)stop{
    
    if ([_player isPlaying]) {
        
        [_player stop];
    }
    
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    _player.delegate = nil;
    _player = nil;
}

@end
