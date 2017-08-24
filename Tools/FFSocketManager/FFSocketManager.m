//
//  FFSocketManager.m
//  Socket_for_Camera
//
//  Created by lsq on 2017/5/15.
//  Copyright © 2017年 detu. All rights reserved.
//

#import "FFSocketManager.h"
#import "FFGadget.h"

#define FFMAXVALUE              15
#define FFHEARDBEADTIME         4

@interface FFSocketManager()

@property (nonatomic, assign) NSTimer *heardbeatTimer;

@end

@implementation FFSocketManager

+ (instancetype) sharedInstance{
    static FFSocketManager  * obj = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        obj = [[self alloc] init];
        obj.cameraInfo = [[FFCameraInfo alloc] init];
        [obj.cameraInfo initData];
        obj.soccketExceptionBlock = [FFSDK instance].socketCallBackBlock;

    });
    
    return obj;
}

- (instancetype)init {
    if (self = [super init]) {
        [self handleNotify];
        //SDK log开关
        [FFSDK openLog:YES];
    }
    
    return self;
}

#pragma mark - 定时数据转换
- (int)switchDelay:(int)time{
    int switchtime = -1;
    switch (time) {
        case 0:
            switchtime = 0;
            break;
        case 1:
            switchtime = 2;
            break;
        case 2:
            switchtime = 5;
            break;
        case 3:
            switchtime = 10;
            break;
        case 4:
            switchtime = 30;
            break;
        default:
            break;
    }
    return switchtime;
}

#pragma mark - 倒序定时数据转换
- (int)switchReverseDelay:(int)time{
    int switchtime = -1;
    switch (time) {
        case 0:
            switchtime = 0;
            break;
        case 2:
            switchtime = 1;
            break;
        case 5:
            switchtime = 2;
            break;
        case 10:
            switchtime = 3;
            break;
            break;
        case 30:
            switchtime = 4;
            break;
        default:
            break;
    }
    return switchtime;
}


#pragma mark - 处理notify
- (void)handleNotify{
    __weak typeof(self) weak = self;
    [FFSDK instance].cameraNotifyBlock = ^(FFMessageModel *message) {
        __strong typeof(weak) self = weak;
        switch (message.msgid) {
                case MSGID_NOTIFY_START_CAPTURE:
#pragma mark - 定时拍照开始notify
                if (self.delayCaptureStartNotifyBlock) {
                    self.delayCaptureStartNotifyBlock(message.rval);
                }
                break;
                
                case MSGID_NOTIFY_START_RECORD:
#pragma mark - 定时录制开始notify
                if (self.delayRecordStartNotifyBlock) {
                    self.delayRecordStartNotifyBlock(message.rval);
                }
                break;
                
                case MSGID_NOTIFY_TEMPERATURE:
#pragma mark - 温度notify
                if (self.temperatureNotifyBlock) {
                    self.temperatureNotifyBlock(message.rval);
                }
                break;
                
                case MSGID_NOTIFY_DELAY_RECORD_TIMECOUNT:
#pragma mark - 定时录影倒计时时间notify
                if (self.delayRecordRemainTimeNotifyBlock) {
                    self.delayRecordRemainTimeNotifyBlock(message.rval);
                }
                break;
                
                case MSGID_NOTIFY_DELAY_CAPTURE_TIMECOUNT:
#pragma mark - 定时拍照剩余时间notify
                if (self.delayCaptureRemainTimeNotifyBlock) {
                    self.delayCaptureRemainTimeNotifyBlock(message.rval);
                }
                break;
                
                case MSGID_CAMERA_CAPTURE:
                if (self.cameraInfo.delaycapturetime > 0) {
#pragma mark - 定时拍照成功失败回调
                    if (self.delayCaptureRetBlock) {
                        self.delayCaptureRetBlock(message.rval);
                    }
                }
                break;
                
                case MSGID_CAMERA_START_RECORD:
                if (self.cameraInfo.delayrecordtime >0){
#pragma mark - 定时录制开始成功失败回调
                    if (self.delayRecordRetBlock) {
                        self.delayRecordRetBlock(message.rval);
                    }
                }
                break;
                
                case MSGID_HEARTBEAT:{
#pragma mark - 心跳
#pragma mark - 电量notify
                    int bat_current = [[message.param objectForKey:@"bat_current"] intValue];
                    int bat_total = [[message.param objectForKey:@"bat_total"] intValue];
                    int Percentage = (int)(bat_current / (bat_total * 1.0) * 100);
                    if (self.batteryNotifyBlock) {
                        self.batteryNotifyBlock(Percentage);
                    }
                    self.cameraInfo.battery = Percentage;
#pragma mark - SD卡剩余内存
                    if (self.freeMemoryNotifyBlock) {
                        self.freeMemoryNotifyBlock([[message.param objectForKey:@"remain_capacity"] intValue]);
                    }
                    self.cameraInfo.freeSpace = [[message.param objectForKey:@"remain_capacity"] intValue];
                    
                    }
                break;
                
#pragma mark - 单机录影停止成功失败回调
                case MSGID_CAMERA_STOP_RECORD:
                    if (self.machineMovieResultNotifyBlock) {
                        self.machineMovieResultNotifyBlock(message.rval);
                    }
                break;
                
            default:
                break;
        }
        
//        if (message.msgid == MSGID_NOTIFY_START_CAPTURE) {
//        }else if (message.msgid == MSGID_NOTIFY_START_RECORD){
//        }
//        else if (message.msgid == MSGID_NOTIFY_TEMPERATURE){
//        }
//        else if (message.msgid == MSGID_NOTIFY_DELAY_RECORD_TIMECOUNT){
//        }else if (message.msgid == MSGID_NOTIFY_DELAY_CAPTURE_TIMECOUNT){
//        }else if (self.cameraInfo.delaycapturetime > 0 && message.msgid == MSGID_CAMERA_CAPTURE) {
//        }else if (self.cameraInfo.delayrecordtime >0 && message.msgid == MSGID_CAMERA_START_RECORD){
//        }else if (message.msgid == MSGID_HEARTBEAT){
//
//        }
//#pragma mark - 单机拍照成功失败回调
//        else if (message.msgid == MSGID_CAMERA_CAPTURE){
//            if (self.machinePhotoNotifyBlock) {
//                self.machinePhotoNotifyBlock(message.rval);
//            }
//        }
//#pragma mark - 单机录影开始回调
//        else if (message.msgid == MSGID_CAMERA_START_RECORD){
//            if (self.machineMovieStartNotifyBlock) {
//                self.machineMovieStartNotifyBlock(message.rval);
//            }
//        }
//#pragma mark - 单机录影停止成功失败回调
//        else if (message.msgid == MSGID_CAMERA_STOP_RECORD){
//            if (self.machineMovieResultNotifyBlock) {
//                self.machineMovieResultNotifyBlock(message.rval);
//            }
//        }
        
    };
}


#pragma mark - 连接服务器
- (void)connectSocketCallBack:(resultResponseBlock)responseBlock{
    __weak typeof(self) weak = self;
    [[FFSDK instance] connectSocket:^(BOOL successs) {
        __strong typeof(weak) self = weak;
        if (successs) {
            if (responseBlock) {
                responseBlock(FFCamera_Error_CONNECTSOCKET_SUCCESS);
            }
            [[FFCameraErrorHandle shareInstance] handleFFError:FFCamera_Error_CONNECTSOCKET_SUCCESS];
        }else{
            if (responseBlock) {
                responseBlock(FFCamera_Error_CONNECTSOCKET_FAIL);
            }
            // 停止心跳发送
            [self stopHeardbeat];
            [[FFCameraErrorHandle shareInstance] handleFFError:FFCamera_Error_CONNECTSOCKET_FAIL];
        }
    }];
}

#pragma mark - 开启会话
- (void)startSession:(resultResponseBlock)responseBlock{
    [[FFSDK instance] startSession:^(BOOL success, FFMessageModel *e) {
        [[FFCameraErrorHandle shareInstance] handleFFError:e.rval];
        if (success) {
            if (responseBlock) {
                responseBlock(e.rval);
            }
        }else{
            if (responseBlock) {
                responseBlock(e.rval);
            }
        }
    }];
}

#pragma mark - 心跳定时器
- (void)startHeardbeat{
    if (!self.heardbeatTimer) {
        [self heardbeat];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.heardbeatTimer = [NSTimer scheduledTimerWithTimeInterval:FFHEARDBEADTIME target:self selector:@selector(timerHeardbeat) userInfo:nil repeats:YES];
        });
    }
}

- (void)timerHeardbeat{
    [self heardbeat];
}

- (void)stopHeardbeat{
    if (self.heardbeatTimer) {
        [self.heardbeatTimer invalidate];
        self.heardbeatTimer = nil;
    }
}

#pragma mark - 获取配置信息
- (void)pushInpreview:(resultResponseBlock)responseBlock {
    __weak typeof(self) weak = self;
    [[FFSDK instance] systemGetAllCurrentSettings:^(BOOL successs, FFMessageModel *e) {
        __strong typeof(weak) self = weak;
        __weak typeof(weak) weakSelf = weak;
        if (successs) {
            NSDictionary *currentDic = (NSDictionary *)e.param;
            
            if ([[currentDic objectForKey:@"awb"] intValue] > FFMAXVALUE) {
                self.cameraInfo.wb = 0;
            }else{
                self.cameraInfo.wb = [[currentDic objectForKey:@"awb"] intValue];                       // AWB
            }
            if ([[currentDic objectForKey:@"delay_capturetime"] intValue] > FFMAXVALUE) {
                self.cameraInfo.delaycapturetime = 0;
            }else{
                self.cameraInfo.delaycapturetime = [self switchReverseDelay:[[currentDic objectForKey:@"delay_capturetime"] intValue]];    // 定时拍照
            }
            if ([[currentDic objectForKey:@"delay_recordtime"] intValue] > FFMAXVALUE) {
                self.cameraInfo.delayrecordtime = 0;
            }else{
                self.cameraInfo.delayrecordtime = [self switchReverseDelay:[[currentDic objectForKey:@"delay_recordtime"] intValue]];   // 定时录影

            }
            if ([[currentDic objectForKey:@"ev"] intValue] > FFMAXVALUE) {
                self.cameraInfo.EV = 0;
            }else{
                self.cameraInfo.EV = [[currentDic objectForKey:@"ev"] intValue];                        // EV
            }
            if ([[currentDic objectForKey:@"hdr"] intValue] > FFMAXVALUE) {
                self.cameraInfo.HDR = 0;
            }else{
                self.cameraInfo.HDR = [[currentDic objectForKey:@"hdr"] intValue];                      // HDR
            }
            if ([[currentDic objectForKey:@"iso"] intValue] > FFMAXVALUE) {
                self.cameraInfo.iso = 0;
            }else{
                self.cameraInfo.iso = [[currentDic objectForKey:@"iso"] intValue];                      // ISO
            }
            if ([[currentDic objectForKey:@"shutter"] intValue] > FFMAXVALUE) {
                self.cameraInfo.shutter = 0;
            }else{
                self.cameraInfo.shutter = [[currentDic objectForKey:@"shutter"] intValue];              // 快门
            }
            self.cameraInfo.vfState = [[currentDic objectForKey:@"vf"] intValue];                   // VF状态
            if ([[currentDic objectForKey:@"video_timelapse"] intValue] > FFMAXVALUE) {
                self.cameraInfo.timelapse = 0;
            }else{
                self.cameraInfo.timelapse = [[currentDic objectForKey:@"video_timelapse"] intValue];    // 缩时录影
            }
            if ([[currentDic objectForKey:@"video_quality"] intValue] > FFMAXVALUE) {
                self.cameraInfo.videoQuality = 0;
            }else{
                self.cameraInfo.videoQuality = [[currentDic objectForKey:@"video_quality"] intValue];   // 视频分辨率
            }
            self.cameraInfo.fan = [currentDic objectForKey:@"funlevel"];
            self.cameraInfo.battery = [[currentDic objectForKey:@"battery"] intValue];              // 电量
            self.cameraInfo.temperature = [[currentDic objectForKey:@"temperature"] intValue];      // 温度
            self.cameraInfo.videoModel = [[currentDic objectForKey:@"video_resolution"] intValue];  // 模式
            if ([[currentDic objectForKey:@"auto_sleep_time"] intValue] > FFMAXVALUE) {
                self.cameraInfo.autoSleeptime = 0;
            }else{
                self.cameraInfo.autoSleeptime = [currentDic objectForKey:@"auto_sleep_time"];        // 自动休眠时间
            }
            self.cameraInfo.freeSpace = [[currentDic objectForKey:@"remain_capacity"] intValue];     // 剩余容量
            // VF状态
            if ([[currentDic objectForKey:@"vf"] isEqualToString:@"on"]) {
                self.cameraInfo.vfState = 1;
            }else{
                self.cameraInfo.vfState = 0;
            }
            
            // 状态同步
            int cameraState = [[currentDic objectForKey:@"camera_state"] intValue];
            switch (cameraState) {
                case en_F4Pro_recording:
                    self.cameraInfo.shotState = FFCameraShotState_VideoIng;
                    self.cameraInfo.nowMovieRecordingTime = [[currentDic objectForKey:@"camera_state_param"] intValue];
                    self.cameraInfo.nowRecordMode = FFCameraType_video;
                    self.cameraInfo.isTakingMovie = YES;
                    break;
                    
                default:
                    break;
            }

            
            [[FFSDK instance] systemGetDeviceInfo:^(BOOL successs, FFMessageModel *e) {
                __strong typeof(weakSelf) self = weakSelf;
                [[FFCameraErrorHandle shareInstance] handleFFError:e.rval];
                if (successs) {
                    NSDictionary *currentDic = (NSDictionary *)e.param;
                    self.cameraInfo.seriesNumber = [currentDic objectForKey:@"serialNum"];
                    self.cameraInfo.cameraSoftVer = [currentDic objectForKey:@"cameraSoftVer"];
                    self.cameraInfo.routerSysVer = [currentDic objectForKey:@"routerSysVer"];
                    self.cameraInfo.routerAppVer = [currentDic objectForKey:@"routerAppVer"];
                }
                if (responseBlock) {
                    responseBlock(e.rval);
                }
                //  开启心跳
                [self startHeardbeat];
                
            }];
        }else{
            if (responseBlock) {
                responseBlock(e.rval);
            }
            [[FFCameraErrorHandle shareInstance] handleFFError:e.rval];
        }
    }];
}

#pragma mark - 关闭连接
- (void)closeSocket{
    [self.cameraInfo reset];
    [[FFSDK instance] disConnect];
    [self stopHeardbeat];
}

#pragma mark - 心跳指令
- (void)heardbeat{
    [[FFSDK instance] heardbeat];
}

#pragma mark - 关闭会话
- (void)stopSession:(resultResponseBlock)responseBlock {
    [[FFSDK instance] stopSession:^(BOOL successs, FFMessageModel *e) {
        [[FFCameraErrorHandle shareInstance] handleFFError:e.rval];
        if (responseBlock) {
            responseBlock(e.rval);
        }
    }];
}

#pragma mark - 停止VF
- (void)stopVF:(resultResponseBlock)responseBlock {
    [[FFSDK instance] stopVF:^(BOOL successs, FFMessageModel *e) {
        [[FFCameraErrorHandle shareInstance] handleFFError:e.rval];
        if (responseBlock) {
            responseBlock(e.rval);
        }
    }];
}


#pragma mark - 重置VF
- (void)startVF:(resultResponseBlock)responseBlock {
    [[FFSDK instance] resetVF:^(BOOL successs, FFMessageModel *e) {
        [[FFCameraErrorHandle shareInstance] handleFFError:e.rval];
        if (responseBlock) {
            responseBlock(e.rval);
        }
    }];
}

#pragma mark - 设置HDR
- (void)setHDR:(SWITCH_TYPE)mode callBack:(resultResponseBlock)responseBlock {
    [[FFSDK instance] setSystemHDR:mode result:^(BOOL successs, FFMessageModel *e) {
        [[FFCameraErrorHandle shareInstance] handleFFError:e.rval];
        if (responseBlock) {
            responseBlock(e.rval);
        }
    }];
}

#pragma mark - 设置快门时间
- (void)setshutter:(EN_SHUTTER_TYPE)mode callBack:(resultResponseBlock)responseBlock {
    [[FFSDK instance] setSystemShutter:mode result:^(BOOL successs, FFMessageModel *e) {
        [[FFCameraErrorHandle shareInstance] handleFFError:e.rval];
        if (responseBlock) {
            responseBlock(e.rval);
        }
    }];
}

#pragma mark - 拍照
- (void)takePhoto:(resultResponseBlock)responseBlock {
    [[FFSDK instance] takePhoto:^(BOOL success, FFMessageModel *e) {
        [[FFCameraErrorHandle shareInstance] handleFFError:e.rval];
        if (responseBlock) {
            responseBlock(e.rval);
        }
    }];
}

#pragma mark - 设置定时拍照时间
- (void)setDelayCaptureTime:(int)time result:(resultResponseBlock)responseBlock {
    time = [self switchDelay:time];
    [[FFSDK instance] setDelayCaptureTime:time result:^(BOOL success, FFMessageModel *e) {
        if (responseBlock) {
            responseBlock(e.rval);
        }
    }];
}

#pragma mark - 开始定时拍照
- (void)startDelayCapture:(resultResponseBlock)responseBlock{
    [[FFSDK instance] startDelayCapture:^(BOOL successs, FFMessageModel *e) {
        [[FFCameraErrorHandle shareInstance] handleFFError:e.rval];
        if (responseBlock) {
            responseBlock(e.rval);
        }
    }];
}

 #pragma mark - 取消定时拍照
- (void)cancelDelayCapture:(resultResponseBlock)responseBlock{
    [[FFSDK instance] cancelDelayCapture:^(BOOL successs, FFMessageModel *e) {
        [[FFCameraErrorHandle shareInstance] handleFFError:e.rval];
        if (responseBlock) {
            responseBlock(e.rval);
        }
    }];
}

#pragma mark - 录制
- (void)recordStartOrStop:(BOOL)abool callBack:(resultResponseBlock)responseBlock {
    if (abool) {
        [[FFSDK instance] startVideoRecord:^(BOOL successs, FFMessageModel *e) {
            [[FFCameraErrorHandle shareInstance] handleFFError:e.rval];
            if (responseBlock) {
                responseBlock(e.rval);
            }
        }];
    }else{
        [[FFSDK instance] stopVideoRecord:^(BOOL successs, FFMessageModel *e) {
            [[FFCameraErrorHandle shareInstance] handleFFError:e.rval];
            if (responseBlock) {
                responseBlock(e.rval);
            }
        }];
    }
    
}

#pragma mark - 设置定时录像时间
- (void)setDelayRecordTime:(int)time result:(resultResponseBlock)responseBlock {
    time = [self switchDelay:time];
    [[FFSDK instance] setDelayRecordTime:time result:^(BOOL successs, FFMessageModel *e) {
        if (responseBlock) {
            responseBlock(e.rval);
        }
    }];
}

#pragma mark - 开启定时录影
- (void)startDelayRecord:(resultResponseBlock)responseBlock{
    [[FFSDK instance] startDelayRecord:^(BOOL successs, FFMessageModel *e) {
        [[FFCameraErrorHandle shareInstance] handleFFError:e.rval];
        if (responseBlock) {
            responseBlock(e.rval);
        }
    }];
}


#pragma mark - 取消定时录影
- (void)cancelDelayRecord:(resultResponseBlock)responseBlock{
    [[FFSDK instance] cancelDelayRecord:^(BOOL successs, FFMessageModel *e) {
        [[FFCameraErrorHandle shareInstance] handleFFError:e.rval];
        if (responseBlock) {
            responseBlock(e.rval);
        }
    }];
}

#pragma mark - 延时开关(缩时录影)
- (void)setTimelapse:(SWITCH_TYPE)mode callBack:(resultResponseBlock)responseBlock {
    [[FFSDK instance] settimelapse:mode result:^(BOOL successs, FFMessageModel *e) {
        [[FFCameraErrorHandle shareInstance] handleFFError:e.rval];
        if (responseBlock) {
            responseBlock(e.rval);
        }
    }];
}

#pragma mark - 定时
- (void)timeRecord:(resultResponseBlock)responseBlock {
//    [];
}

#pragma mark - ISO
- (void)setISO:(EN_ISO_TYPE)mode callBack:(resultResponseBlock)responseBlock {
    [[FFSDK instance] setSystemISO:mode result:^(BOOL successs, FFMessageModel *e) {
        [[FFCameraErrorHandle shareInstance] handleFFError:e.rval];
        if (responseBlock) {
            responseBlock(e.rval);
        }
    }];
}

#pragma mark - EVO
- (void)setEV:(EN_EV_TYPE)mode callBack:(resultResponseBlock)responseBlock {
    [[FFSDK instance] setSystemEV:mode result:^(BOOL successs, FFMessageModel *e) {
        [[FFCameraErrorHandle shareInstance] handleFFError:e.rval];
        if (responseBlock) {
            responseBlock(e.rval);
        }
    }];
}

#pragma mark - WB
- (void)setWB:(EN_AWB_TYPE)mode callBack:(resultResponseBlock)responseBlock {
    [[FFSDK instance] setSystemWB:mode result:^(BOOL successs, FFMessageModel *e) {
        [[FFCameraErrorHandle shareInstance] handleFFError:e.rval];
        if (responseBlock) {
            responseBlock(e.rval);
        }
    }];
}

#pragma mark - 质量
- (void)setVideoQuality:(EN_QUALITY_TYPE)mode callBack:(resultResponseBlock)responseBlock {
    [[FFSDK instance] setSystemVideoQuality:mode result:^(BOOL successs, FFMessageModel *e) {
        [[FFCameraErrorHandle shareInstance] handleFFError:e.rval];
        if (responseBlock) {
            responseBlock(e.rval);
        }

    }];
}


#pragma mark - SD卡格式化
- (void)FormatDisk:(resultResponseBlock)responseBlock {
    [[FFSDK instance] formatSDCard:^(BOOL successs, FFMessageModel *e) {
        [[FFCameraErrorHandle shareInstance] handleFFError:e.rval];
        if (responseBlock) {
            responseBlock(e.rval);
        }
    }];
}

#pragma mark - 关机
- (void)closeMachine:(resultResponseBlock)responseBlock{
    [[FFSDK instance] closeMachine:^(BOOL successs, FFMessageModel *e) {
        [[FFCameraErrorHandle shareInstance] handleFFError:e.rval];
        if (responseBlock) {
            responseBlock(e.rval);
        }
    }];
}

#pragma mark - 自动休眠
- (void)setAutoSleep:(EN_AUTO_SLEEP_TIME_TYPE)sleepTimeType callback:(resultResponseBlock)responseBlock{
    [[FFSDK instance] setAutoSleepTime:sleepTimeType result:^(BOOL successs, FFMessageModel *e) {
        [[FFCameraErrorHandle shareInstance] handleFFError:e.rval];
        if (responseBlock) {
            responseBlock(e.rval);
        }
    }];
}

#pragma mark - 恢复出厂设置
- (void)SystemReset:(resultResponseBlock)responseBlock {
    [[FFSDK instance] SystemReset:^(BOOL successs, FFMessageModel *e) {
        [[FFCameraErrorHandle shareInstance] handleFFError:e.rval];
        if (responseBlock) {
            responseBlock(e.rval);
        }
    }];
}

#pragma mark - 风扇控制
- (void)setFan:(int)fantype callBack:(resultResponseBlock)responseBlock {
    [[FFSDK instance] setFan:fantype result:^(BOOL successs, FFMessageModel *e) {
        [[FFCameraErrorHandle shareInstance] handleFFError:e.rval];
        if (responseBlock) {
            responseBlock(e.rval);
        }
    }];
}

#pragma mark - 获取剩余可录影时长
- (void)getRecordRemainTimeCount:(resultResponseBlock)responseBlock {
    __weak typeof(self) weak = self;
    [[FFSDK instance] getRecordRemainTimeCount:^(BOOL successs, FFMessageModel *e) {
        [[FFCameraErrorHandle shareInstance] handleFFError:e.rval];
        __strong typeof(weak) self = weak;
        if (successs) {
            self.cameraInfo.max_record_time = [[FFGadget sharedInstance] timeConversion:[e.param intValue]];
        }
        if (responseBlock) {
            responseBlock(e.rval);
        }
    }];
}

#pragma mark - 获取剩余拍照数量
- (void)getPhotoRemainQuantityCount:(resultResponseBlock)responseBlock {
    __weak typeof(self) weak =self;
    [[FFSDK instance] getPhotoRemainQuantityCount:^(BOOL successs, FFMessageModel *e) {
        [[FFCameraErrorHandle shareInstance] handleFFError:e.rval];
        __strong typeof(weak) self = weak;
        if (successs) {
            self.cameraInfo.pictureNumber = e.param;
        }
        if (responseBlock) {
            responseBlock(e.rval);
        }
    }];
}

- (void)changeModel:(EN_VF_RESOLUTION_TYPE)type callBack:(resultResponseBlock)responseBlock {
    __weak typeof(self) weak =self;
    [[FFSDK instance] changeModel:type result:^(BOOL successs, FFMessageModel *e) {
        [[FFCameraErrorHandle shareInstance] handleFFError:e.rval];
        __strong typeof(weak) self = weak;
        if (successs) {
            self.cameraInfo.videoModel = [e.param intValue];
        }
        if (responseBlock) {
            responseBlock(e.rval);
        }
    }];
}

@end
