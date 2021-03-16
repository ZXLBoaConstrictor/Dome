//
//  ZXLAudioUnitManager.h
//  AudioUnitDome
//
//  Created by zhangxiaolong on 2021/3/16.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@protocol ZXLAudioUnitManagerDelegate <NSObject>
- (void)timerReadPcmData:(NSData *)pcmData;
@end

typedef void (^ZXLAudioUnit_outputBlock)(AudioBufferList *bufferList,UInt32 inNumberFrames);


@interface ZXLAudioUnitManager : NSObject
@property (nonatomic, weak) id<ZXLAudioUnitManagerDelegate> delegate;

///播放的回调，回调的参数 buffer 为要向播放设备（扬声器、耳机、听筒等）传的数据，在回调里把数据传给 buffer
@property (nonatomic,copy) ZXLAudioUnit_outputBlock bl_output;


+(instancetype)manager;
/// 开始录音
- (void)startInput;
/// 停止录音
- (void)stopInput;
/// 开始播放音频
- (void)startOutput;
/// 停止播放音频
- (void)stopOutput;

//清理
- (void)clear;
@end

