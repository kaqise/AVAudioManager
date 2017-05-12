//
//  YSAudioPlayer.h
//  Demo_01
//
//  Created by fdiostwo on 2017/5/10.
//  Copyright © 2017年 FengDingKeJi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSAudioPlayer : NSObject

@property (nonatomic, copy)NSString *url;

- (BOOL)startPlayWithCompeteHandler:(void(^)(NSError *error))competeHandler;
- (void)stop;

@end
