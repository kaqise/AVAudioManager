//
//  YSAudioRecord.h
//  Demo_01
//
//  Created by fdiostwo on 2017/5/10.
//  Copyright © 2017年 FengDingKeJi. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol YSAudioRecordDelegate <NSObject>

/** 获取录制音频的实时音量 */
- (void)ys_peakPower:(float)power;

@end

@interface YSAudioRecord : NSObject

- (void)stopRecord;

- (BOOL)startRecordWithCompeteHandler:(void(^)(NSError *error))competeHandler;

- (NSArray <NSString *> *)getAudioFilePathes;

@property (nonatomic, weak)id<YSAudioRecordDelegate> delegate;

@property (nonatomic, copy)NSString *lastFilePath;//最后一个文件路径


@end
