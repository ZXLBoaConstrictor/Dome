//
//  ZXLAudioUnitManager.m
//  AudioUnitDome
//
//  Created by zhangxiaolong on 2021/3/16.
//

#import "ZXLAudioUnitManager.h"

@interface ZXLAudioUnitManager (){
    AUGraph auGraph;
    AudioUnit remoteIOUnit;
}
@property (nonatomic,assign) BOOL isRunningService; //是否运行着声音服务
@property (nonatomic,assign) BOOL isNeedInputCallback; //需要录音回调(获取input即麦克风采集到的声音回调)
@property (nonatomic,assign) BOOL isNeedOutputCallback; //需要播放回调(output即向发声设备传递声音回调)

@property (nonatomic, strong) NSTimer         *timer;
@property (nonatomic, strong) NSMutableData   *recorderDatas;
@property (nonatomic, assign) NSInteger        currentPos;//data 读取索引
@end

@implementation ZXLAudioUnitManager

+(instancetype)manager{
    static ZXLAudioUnitManager *audioUnitManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        audioUnitManager = [[ZXLAudioUnitManager alloc] init];
    });
    return audioUnitManager;
}

-(NSMutableData *)recorderDatas{
    if (!_recorderDatas) {
        _recorderDatas = [[NSMutableData alloc] init];
    }
    return _recorderDatas;
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(readPcmData) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

- (instancetype)init{
    if (self = [super init]){
        self.currentPos = 0;
        self.isRunningService = NO;
    }
    return self;
}

#pragma mark - 开启、停止服务
- (void)startService{
    if (self.isRunningService == YES){
        return;
    }
    [self setupSession];
    
    [self createAUGraph];
    
    [self setupRemoteIOUnit];
    
    [self startGraph];
    
    [self initEchoCancellation];
    
    CheckError(AudioOutputUnitStart(remoteIOUnit), "AudioOutputUnitStart failed");
    
    self.isRunningService = YES;
}

- (void)stopService{
    self.bl_output = nil;
    [self stopGraph];
}


- (void)clear{
    [self stopOutput];
    [self stopInput];
    [self stopService];
}

#pragma mark - 初始化AUGraph和Audio Unit
-(void)setupSession{
    AVAudioSession* audioSession = [AVAudioSession sharedInstance];
   BOOL isSuccess = [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionAllowBluetooth|AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    [audioSession setActive:YES error:nil];
    if (isSuccess) {
        
    }
}


-(void)startGraph{
    CheckError(AUGraphInitialize(auGraph),"AUGraphInitialize failed");
    CheckError(AUGraphStart(auGraph),"AUGraphStart failed");
}

- (void)stopGraph{
    
    if (self.isRunningService == NO){
        return;
    }
    
    CheckError(AUGraphStop(auGraph),"AUGraphStop failed");
    CheckError(AUGraphUninitialize(auGraph),"AUGraphUninitialize failed");
    CheckError(DisposeAUGraph(auGraph), "AUGraphDispose failed");
    self.isRunningService = NO;
}


-(void)createAUGraph{
    //Create graph
    CheckError(NewAUGraph(&auGraph),
               "NewAUGraph failed");
    
    //Create nodes and add to the graph
    AudioComponentDescription inputcd = {0};
    inputcd.componentType = kAudioUnitType_Output;
    inputcd.componentSubType = kAudioUnitSubType_VoiceProcessingIO;
    inputcd.componentManufacturer = kAudioUnitManufacturer_Apple;
    
    AUNode remoteIONode;
    //Add node to the graph
    CheckError(AUGraphAddNode(auGraph,
                              &inputcd,
                              &remoteIONode),
               "AUGraphAddNode failed");
    
    //Open the graph
    CheckError(AUGraphOpen(auGraph),
               "AUGraphOpen failed");
    
    //Get reference to the node
    CheckError(AUGraphNodeInfo(auGraph,
                               remoteIONode,
                               &inputcd,
                               &remoteIOUnit),
               "AUGraphNodeInfo failed");
}

-(void)setupRemoteIOUnit{
    //Open input of the bus 1(input mic)
    UInt32 inputEnableFlag = 1;
    CheckError(AudioUnitSetProperty(remoteIOUnit,
                                    kAudioOutputUnitProperty_EnableIO,
                                    kAudioUnitScope_Input,
                                    1,
                                    &inputEnableFlag,
                                    sizeof(inputEnableFlag)),
               "Open input of bus 1 failed");
    
    //Open output of bus 0(output speaker)
    UInt32 outputEnableFlag = 1;
    CheckError(AudioUnitSetProperty(remoteIOUnit,
                                    kAudioOutputUnitProperty_EnableIO,
                                    kAudioUnitScope_Output,
                                    0,
                                    &outputEnableFlag,
                                    sizeof(outputEnableFlag)),
               "Open output of bus 0 failed");
    
    AudioStreamBasicDescription mAudioFormat;
    mAudioFormat.mSampleRate         = 16000.0;//采样率
    mAudioFormat.mFormatID           = kAudioFormatLinearPCM;//PCM采样
    mAudioFormat.mFormatFlags        = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
    mAudioFormat.mReserved           = 0;
    mAudioFormat.mChannelsPerFrame   = 1;//1单声道，2立体声，但是改为2也并不是立体声
    mAudioFormat.mBitsPerChannel     = 16;//语音每采样点占用位数
    mAudioFormat.mFramesPerPacket    = 1;//每个数据包多少帧
    mAudioFormat.mBytesPerFrame      = (mAudioFormat.mBitsPerChannel / 8) * mAudioFormat.mChannelsPerFrame; // 每帧的bytes数
    mAudioFormat.mBytesPerPacket     = mAudioFormat.mBytesPerFrame;//每个数据包的bytes总数，每帧的bytes数＊每个数据包的帧数
    
    
    CheckError(AudioUnitSetProperty(remoteIOUnit,
                                    kAudioUnitProperty_StreamFormat,
                                    kAudioUnitScope_Input,
                                    0,
                                    &mAudioFormat,
                                    sizeof(mAudioFormat)),
               "kAudioUnitProperty_StreamFormat of bus 0 failed");
    
    CheckError(AudioUnitSetProperty(remoteIOUnit,
                                    kAudioUnitProperty_StreamFormat,
                                    kAudioUnitScope_Output,
                                    1,
                                    &mAudioFormat,
                                    sizeof(mAudioFormat)),
               "kAudioUnitProperty_StreamFormat of bus 1 failed");
    
    AURenderCallbackStruct input;
    input.inputProc = InputCallback;
    input.inputProcRefCon = (__bridge void *)(self);
    CheckError(AudioUnitSetProperty(remoteIOUnit,
                                    kAudioOutputUnitProperty_SetInputCallback,
                                    kAudioUnitScope_Output,
                                    1,
                                    &input,
                                    sizeof(input)),
               "couldnt set remote i/o render callback for output");
    
    AURenderCallbackStruct output;
    output.inputProc = outputRenderTone;
    output.inputProcRefCon = (__bridge void *)(self);
    CheckError(AudioUnitSetProperty(remoteIOUnit,
                                    kAudioUnitProperty_SetRenderCallback,
                                    kAudioUnitScope_Input,
                                    0,
                                    &output,
                                    sizeof(output)),
               "kAudioUnitProperty_SetRenderCallback failed");
}

-(void)initEchoCancellation{
    UInt32 newEchoCancellationStatus = 0;
    UInt32 echoCancellation;
    UInt32 size = sizeof(echoCancellation);
    CheckError(AudioUnitGetProperty(remoteIOUnit,
                                    kAUVoiceIOProperty_BypassVoiceProcessing,
                                    kAudioUnitScope_Global,
                                    0,
                                    &echoCancellation,
                                    &size),
               "kAUVoiceIOProperty_BypassVoiceProcessing failed");
    if (newEchoCancellationStatus == echoCancellation){
        return;
    }
    
    CheckError(AudioUnitSetProperty(remoteIOUnit,
                                    kAUVoiceIOProperty_BypassVoiceProcessing,
                                    kAudioUnitScope_Global,
                                    0,
                                    &newEchoCancellationStatus,
                                    sizeof(newEchoCancellationStatus)),
               "AudioUnitSetProperty kAUVoiceIOProperty_BypassVoiceProcessing failed");
}

#pragma mark - 开启或者停止音频输入、输出回调
- (void)startInput{
    [self startService];

    self.isNeedInputCallback = YES;
    
    [self.timer setFireDate:[NSDate distantPast]];
}

- (void)stopInput{
    self.isNeedInputCallback = NO;
    self.delegate = nil;
     [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)startOutput{
    [self startService];
    self.isNeedOutputCallback = YES;
}

- (void)stopOutput{
    self.isNeedOutputCallback = NO;
}

#pragma mark - 音频存储
-(void)storeAudioData:(NSData *)audioData{
    if (self.recorderDatas.length >= 1024*1024*10) {
        [self.recorderDatas resetBytesInRange:NSMakeRange(0, self.recorderDatas.length)];
        [self.recorderDatas setLength:0];
        self.currentPos = 0;
    }
    
    [self.recorderDatas appendData:audioData];
}

-(void)readPcmData{
    if (self.currentPos >= self.recorderDatas.length) {
        return;
    }
    
    NSInteger dataLength = self.recorderDatas.length;
    NSData * readData = [self.recorderDatas subdataWithRange:NSMakeRange(self.currentPos, dataLength - self.currentPos)];
    self.currentPos = dataLength;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(timerReadPcmData:)]) {
        [self.delegate timerReadPcmData:readData];
    }
}



#pragma mark - 回调函数
OSStatus InputCallback(void *inRefCon,
                       AudioUnitRenderActionFlags *ioActionFlags,
                       const AudioTimeStamp *inTimeStamp,
                       UInt32 inBusNumber,
                       UInt32 inNumberFrames,
                       AudioBufferList *ioData){
    
    ZXLAudioUnitManager *mySelf = (__bridge ZXLAudioUnitManager*)inRefCon;
    if (mySelf.isNeedInputCallback == NO){
        return noErr;
    }
    
    AudioBufferList bufferList;
    bufferList.mNumberBuffers = 1;
    bufferList.mBuffers[0].mData = NULL;
    bufferList.mBuffers[0].mDataByteSize = 0;

    AudioUnitRender(mySelf->remoteIOUnit,
                                      ioActionFlags,
                                      inTimeStamp,
                                      1,
                                      inNumberFrames,
                                      &bufferList);
    
    [mySelf storeAudioData:[NSData dataWithBytes:bufferList.mBuffers->mData length:bufferList.mBuffers->mDataByteSize]];
    return noErr;
}
OSStatus outputRenderTone(
                          void *inRefCon,
                          AudioUnitRenderActionFlags     *ioActionFlags,
                          const AudioTimeStamp         *inTimeStamp,
                          UInt32                         inBusNumber,
                          UInt32                         inNumberFrames,
                          AudioBufferList             *ioData){
    //TODO: implement this function
    memset(ioData->mBuffers[0].mData, 0, ioData->mBuffers[0].mDataByteSize);
    
    ZXLAudioUnitManager *mySelf = (__bridge ZXLAudioUnitManager*)inRefCon;
    if (mySelf.isNeedOutputCallback == NO){
        return noErr;
    }

    if (mySelf.bl_output){
        mySelf.bl_output(ioData,inNumberFrames);
    }
    return 0;
}

#pragma mark - 检查错误的方法
static void CheckError(OSStatus error, const char *operation)
{
    if (error == noErr) return;
    char errorString[20];
    // See if it appears to be a 4-char-code
    *(UInt32 *)(errorString + 1) = CFSwapInt32HostToBig(error);
    if (isprint(errorString[1]) && isprint(errorString[2]) &&
        isprint(errorString[3]) && isprint(errorString[4])) {
        errorString[0] = errorString[5] = '\'';
        errorString[6] = '\0';
    } else
        // No, format it as an integer
        sprintf(errorString, "%d", (int)error);
    fprintf(stderr, "Error: %s (%s)\n", operation, errorString);
    exit(1);
}

@end

