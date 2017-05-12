//
//  YSAudioRecord.m
//  Demo_01
//
//  Created by fdiostwo on 2017/5/10.
//  Copyright © 2017年 FengDingKeJi. All rights reserved.
//



#import "YSAudioRecord.h"
#import <AVFoundation/AVFoundation.h>

#define kDirectoryLocation @"kDirectoryLocation"

@interface YSAudioRecord ()<AVAudioRecorderDelegate>

@property (nonatomic, strong)AVAudioRecorder *recorder;

@property (nonatomic, copy)NSMutableDictionary *settings;

@property (nonatomic, strong)NSTimer *powerTimer;

@property (nonatomic, copy)NSMutableArray *filePathes;

@end

@implementation YSAudioRecord

#pragma mark - LazyLoad 懒加载

- (NSMutableDictionary *)settings{
    if (!_settings) {
        _settings = [NSMutableDictionary dictionary];
        [_settings setValue:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];//录制格式
        [_settings setValue:@8000.00f forKey:AVSampleRateKey];//采样率:单位HZ 通常设置成44100 也就是44.1k,采样率必须要设为11025才能使转化成mp3格式后不会失真
        [_settings setValue:@1 forKey:AVNumberOfChannelsKey];//通道数 通常为双声道 值为2
        [_settings setValue:@16 forKey:AVLinearPCMBitDepthKey];//音频位宽 比特率 8 16 24 32
        [_settings setValue:@NO forKey:AVLinearPCMIsNonInterleaved];
        [_settings setValue:@NO forKey:AVLinearPCMIsFloatKey];
        [_settings setValue:@NO forKey:AVLinearPCMIsBigEndianKey];
        [_settings setValue:@(AVAudioQualityMax) forKey:AVEncoderAudioQualityKey];//声音质量
        
        /**
         //       AVEncoderAudioQualityKey 声音质量
         //       ① AVAudioQualityMin  = 0, 最小的质量
         //       ② AVAudioQualityLow  = 0x20, 比较低的质量
         //       ③ AVAudioQualityMedium = 0x40, 中间的质量
         //       ④ AVAudioQualityHigh  = 0x60,高的质量
         //       ⑤ AVAudioQualityMax  = 0x7F 最好的质量
         */
    }
    return _settings;
}

- (NSMutableArray *)filePathes{
    
    if (!_filePathes) {
        
        NSArray *arr = [NSArray arrayWithContentsOfFile:[self listPath]];
        
        if (arr) {
            _filePathes = [NSMutableArray arrayWithArray:arr];
        }else{
            _filePathes = [NSMutableArray array];
        }
    }
    return _filePathes;
}


#pragma mark --- AVAudioRecorderDelegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    
    NSString *path = [recorder.url path];
    
    self.lastFilePath = path;
    
    NSLog(@"录制的URL:%@",path);
    
    [self.filePathes addObject:path];
    
    [_filePathes writeToFile:[self listPath] atomically:YES];
    
    _recorder.delegate = nil;
    
    _recorder = nil;
    
}

#pragma mark - 内部方法

- (void)beginPeakPowerTimer{//开定时器
    
    _powerTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(getPower) userInfo:nil repeats:YES];
}

- (void)closeTimer{//关定时器
    
    [_powerTimer invalidate];
    
    _powerTimer = nil;
}

- (void)getPower{//定时器获取分贝数
    
    [self.recorder updateMeters];
    
    float power = [self.recorder averagePowerForChannel:0];
    
    if (self) {
        
        if ([self.delegate respondsToSelector:@selector(ys_peakPower:)]) {
            
            [self.delegate ys_peakPower:power];
        }
    }
}

- (NSString *)createAudioFile{//生成一个路径
    
    NSString *documentsDirectory = [self documentsDirectory];
    
    NSString *time = [NSString stringWithFormat:@"%.f",[[NSDate date] timeIntervalSince1970]];
    
    NSString *path = [[documentsDirectory stringByAppendingPathComponent:time] stringByAppendingPathExtension:@"wav"];
    
    return path;
    
}

#pragma mark - 外部调用 ------------------------

- (BOOL)startRecordWithCompeteHandler:(void (^)(NSError *))competeHandler{//开始录制
    
    NSString *path = [self createAudioFile];
    
    NSError *error = nil;
    
    _recorder = [[AVAudioRecorder alloc]initWithURL:[NSURL fileURLWithPath:path] settings:self.settings error:&error];
    
    _recorder.delegate = self;
    
    _recorder.meteringEnabled = YES;//开启仪表计数功能
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    [_recorder prepareToRecord];
    
    BOOL Success = [self.recorder record];
    
    if (error) {
        
        competeHandler ?: competeHandler(error);
        
        return NO;
        
    }else{
        
        if (Success) {
            
            [self beginPeakPowerTimer];
            competeHandler ?: competeHandler(nil);
            
            return YES;
            
        }else{
            
            error = [[NSError alloc]initWithDomain:@"开启录制失败" code:201 userInfo:nil];
            competeHandler ?: competeHandler(error);
            
            return NO;
        }
    }
}

- (void)stopRecord{//结束录制
    
    if ([_recorder isRecording]) {
        
        [self closeTimer];
        
        [_recorder stop];
    }
    
}

- (NSArray<NSString *> *)getAudioFilePathes{
    
    return self.filePathes;
}

- (NSString *)listPath{
    
    NSString *listPath = [[self documentsDirectory] stringByAppendingPathComponent:kDirectoryLocation];
    
    return listPath;
}

- (NSString *)documentsDirectory{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return documentsDirectory;
}


@end
