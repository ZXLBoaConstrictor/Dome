//
//  ZXLAudioPlayer.h
//  AudioUnitDome
//
//  Created by zhangxiaolong on 2021/3/16.
//

#import <Foundation/Foundation.h>

@protocol ZXLPlayerManagerDelegate<NSObject>
@optional

/// 播放当前添加的音频索引
/// @param audioIndex 音频索引
-(void)startPlayAudioIndex:(NSInteger)audioIndex;
@end

@interface ZXLAudioPlayer : NSObject
@property(nonatomic, weak) id<ZXLPlayerManagerDelegate> delegate;

+ (instancetype)manager;

//收到的base64音频数据(webSocket 接收到的是音频Base64字符串)
-(void)startPlay:(NSString *)audioBase64String;

-(void)playNextAudio;

-(void)clear;

@end
