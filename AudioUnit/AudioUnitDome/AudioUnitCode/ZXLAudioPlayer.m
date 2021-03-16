//
//  ZXLAudioPlayer.m
//  AudioUnitDome
//
//  Created by zhangxiaolong on 2021/3/16.
//

#import "ZXLAudioPlayer.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <mobileffmpeg/MobileFFmpegConfig.h>
#import <mobileffmpeg/MobileFFmpeg.h>
#import <Bolts/Bolts.h>
#import "ZXLAudioUnitManager.h"

// 主目录
#define QEFILE_DIRECTORY             [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

@interface ZXLAudioPlayer()
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) NSMutableArray * audioUrls;
@property (nonatomic, assign) NSInteger playIndex;

@property (nonatomic, assign) NSInteger readerLength;
@property (nonatomic, strong) NSData * readerDataStore;
@end

@implementation ZXLAudioPlayer
+ (instancetype)manager {
    static ZXLAudioPlayer * player;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[ZXLAudioPlayer alloc]init];
    });
    return player;
}

-(instancetype)init{
    if (self = [super init]) {
        self.playIndex = 0;
        self.readerDataStore = nil;
        self.readerLength = 0;
        self.isPlaying = NO;
        self.audioUrls = [NSMutableArray array];
    }
    return self;
}

-(NSString *)mp3Path{
    NSString *timeStamp = @((long)([[NSDate date] timeIntervalSince1970]*1000)).stringValue;
    return [NSString stringWithFormat:@"%@/webSocketAudio_%@.mp3",QEFILE_DIRECTORY,timeStamp];
}

-(void)startPlay:(NSString *)audioBase64String{
    NSData *audioData = [[NSData  alloc] initWithBase64EncodedString:audioBase64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    NSString *currentMp3Path = [self mp3Path];
    BOOL bWrite = [audioData writeToFile:currentMp3Path atomically:YES];
    if (bWrite) {
        [self.audioUrls addObject:currentMp3Path];
        if (!self.isPlaying) {
            [self playCurrentIndexAudio];
        }
    }
}

-(void)playNextAudio{
    self.playIndex += 1;
    [self playCurrentIndexAudio];
}

-(void)playCurrentIndexAudio{
    if (self.playIndex >= self.audioUrls.count) {
        self.isPlaying = NO;
        return;
    }
    
    typeof(self) __weak weakSelf = self;
    if ([ZXLAudioUnitManager manager].bl_output == nil){
        [ZXLAudioUnitManager manager].bl_output = ^(AudioBufferList *bufferList, UInt32 inNumberFrames) {
            AudioBuffer buffer = bufferList->mBuffers[0];
            if (self.readerDataStore && self.readerDataStore.length > 0) {
                NSInteger len = [weakSelf readData:buffer.mData length:buffer.mDataByteSize];
                buffer.mDataByteSize = (int)len;
                
                if (len == 0){
                    weakSelf.readerLength = 0;
                    weakSelf.readerDataStore = nil;
                    [[ZXLAudioUnitManager manager] stopOutput];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf playNextAudio];
                    });
                }
            }
        };
    }
    
    self.isPlaying = YES;
    NSString * audioPath = [self.audioUrls objectAtIndex:self.playIndex];
    NSString * audioPcmPath = [NSString stringWithFormat:@"%@.pcm",[audioPath substringWithRange:NSMakeRange(0, audioPath.length - 4)]];
    
    [[self mp3TranscodePcm:audioPath pcmPath:audioPcmPath] continueWithBlock:^id _Nullable(BFTask * _Nonnull t) {
        if ([t.result boolValue]) {
            weakSelf.readerLength = 0;
            weakSelf.readerDataStore = [NSData dataWithContentsOfFile:audioPcmPath];
            [[ZXLAudioUnitManager manager] startOutput];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(startPlayAudioIndex:)]) {
                [weakSelf.delegate startPlayAudioIndex:weakSelf.playIndex];
            }
        }
        return nil;
    }];
}

-(BFTask *)mp3TranscodePcm:(NSString *)audioPath pcmPath:(NSString *)audioPcmPath{
    BFTaskCompletionSource * taskSource = [BFTaskCompletionSource taskCompletionSource];
    int rc = [MobileFFmpeg execute:[NSString stringWithFormat:@"-y -i %@ -acodec pcm_s16le -f s16le -ac 1 -ar 16000 %@",audioPath,audioPcmPath]];
    if (rc == RETURN_CODE_SUCCESS) {
        [taskSource setResult:@(YES)];
    }else{
        [taskSource setResult:@(NO)];
    }
    return taskSource.task;
}

-(NSInteger)readData:(Byte *)data length:(NSInteger)len{
    UInt32 currentReadLength = 0;
    
    if (self.readerLength >= self.readerDataStore.length){
        self.readerLength = 0;
        return currentReadLength;
    }
    
    if (self.readerLength + len <= self.readerDataStore.length){
        self.readerLength = self.readerLength + len;
        currentReadLength = (int)len;
    }
    else{
        currentReadLength = (UInt32)(self.readerDataStore.length - self.readerLength);
        self.readerLength = (UInt32) self.readerDataStore.length;
    }
    
    NSData *subData = [self.readerDataStore subdataWithRange:NSMakeRange(_readerLength, currentReadLength)];
    Byte *tempByte = (Byte *)[subData bytes];
    memcpy(data,tempByte,currentReadLength);
    
    return currentReadLength;
}

/*
 * 播放完毕
 */
- (void)endPlay {
    if (self.playIndex < self.audioUrls.count) {
        NSString *filePath = [self.audioUrls objectAtIndex:self.playIndex];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            [[NSFileManager defaultManager] removeItemAtURL:[NSURL fileURLWithPath:filePath] error:nil];
        }
    }
}

-(void)clear{
    [self endPlay];
    [self.audioUrls removeAllObjects];
    self.playIndex = 0;
    self.isPlaying = NO;
    self.delegate = nil;
}
@end
