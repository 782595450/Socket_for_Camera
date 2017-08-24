//
//  FFSDK.m
//  Socket_for_Camera
//
//  Created by lsq on 2017/5/20.
//  Copyright © 2017年 detu. All rights reserved.
//

#import "FFSDK.h"
#import "FFSocket.h"

#define FF_MSG_TimeOut      6

static FFSDK *instance = nil;

static BOOL FF_SDK_Log_Switch = NO;

@interface FFSDK () <FFSocketDelegate>
@property (nonatomic, assign) int tokenNumber;                       // 会话id
@property (nonatomic, strong) NSMutableDictionary *callbackBlock;    // 保存请求回调,超时要踢掉
@property (nonatomic, strong) NSLock *dictionaryLock;
@property (nonatomic, strong) dispatch_queue_t APIQueue;
@property (nonatomic, strong) NSMutableArray *currentComplete;

@end

@implementation FFSDK

#pragma mark - 单列
+ (FFSDK *)instance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[FFSDK alloc] init];
    });
    
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.dictionaryLock = [[NSLock alloc] init];
        self.callbackBlock = [[NSMutableDictionary alloc] init];
        self.currentComplete = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)dealloc {
    self.APIQueue = nil;
    [FFSocket shareInstance].FFSocketDelegate = nil;
    [self disConnect];
    [self cleanSendQueue];
}

- (dispatch_queue_t)APIQueue {
    if (_APIQueue == nil) {
        _APIQueue = dispatch_queue_create("com.api", DISPATCH_QUEUE_SERIAL);
    }
    
    return _APIQueue;
}

#pragma mark - log输出开关
void CustomLog(const char *func, int lineNumber, NSString *format, ...)
{
    if ([FFSDK logEnable]) {  // 开启了Log
        va_list args;
        va_start(args, format);
        NSString *string = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);
        
        NSString *strFormat = [NSString stringWithFormat:@"%s, Line:%i, SDK_Log:%@",func,lineNumber,string];
        NSLog(@"%@", strFormat);
    }
}

+ (void)openLog:(BOOL)enable {
    FF_SDK_Log_Switch = enable;
}

+ (BOOL)logEnable {
    return FF_SDK_Log_Switch;
}

#pragma mark - 连接socket
- (void)connectSocket:(successBlock)block {
    dispatch_async(self.APIQueue, ^{
        [[FFSocket shareInstance] connectSocketWithHost:FF_HOST onPort:FF_PORT];
        [FFSocket shareInstance].FFSocketDelegate = self;
        self.socketCallBackBlock = block;
        self.tokenNumber = 0;
    });
}


#pragma mark - 关闭所有的socket连接并清空数据
- (void)disConnect {
    [[FFSocket shareInstance] disConnect];
    [self cleanSendQueue];
}

#pragma mark - 清空发送队列
- (void)cleanSendQueue {
    [_dictionaryLock lock];
    FFlus_SDK_Log(@"清空消息发送队列");
    for (NSString *key in self.callbackBlock) {
        responseBlock complete = [self.callbackBlock objectForKey:key];
        if (complete != nil) {
            complete(NO, nil);
        }
    }
    [self.callbackBlock removeAllObjects];
    [_dictionaryLock unlock];
}

#pragma mark - delegate
#pragma mark - 端口连接成功代理
- (void)socketDidConnect:(NSString *)connectHost onPort:(int)port {
    if (self.socketCallBackBlock) {
        self.socketCallBackBlock(YES);
    }
}

#pragma mark - 端口连接失败,超时代理
- (void)socketDisConnect:(NSError *)error {
    if (self.socketCallBackBlock) {
        self.socketCallBackBlock(NO);
    }
    [self disConnect];
}

#pragma mark - 接收消息代理
- (void)didReceiveMessage:(FFMessageModel *)messageModel {
    NSString *key = [NSString stringWithFormat:@"%i", messageModel.msgid];
    [_dictionaryLock lock];
    id obj = [self.callbackBlock objectForKey:key];
    [self.callbackBlock removeObjectForKey:key];
    [_dictionaryLock unlock];
    
    responseBlock complete = nil;
    if (obj != nil) {
        complete = (responseBlock)obj;
    }
    if (complete == nil) {
        FFlus_SDK_Log(@"被动接收的包/超时返回的包");
#pragma mark - NOTIFY
        [self handleNotify:messageModel];
    } else {
        if (messageModel.msgid == MSGID_START_SESSION) {
            self.tokenNumber = messageModel.token;
        }
        complete(YES, messageModel);
        [self.currentComplete removeAllObjects];
    }
}

#pragma mark - 发送消息
- (void)sendMsg:(NSMutableDictionary *)dic withMsgid:(int)msgid block:(responseBlock)block {
    dispatch_async(self.APIQueue, ^{
        if (block != nil) {
            // 保存回调 block 到字典里，接收时候用到
            NSString *key = [NSString stringWithFormat:@"%i",msgid];
            [self.dictionaryLock lock];
            [self.callbackBlock setObject:block forKey:key];
            [self.dictionaryLock unlock];
            [self.currentComplete removeAllObjects];
            // 每次运行的指令只有一个，用于判断是否是当前指令
            NSString *dateKey = [self getDate];
            [self.currentComplete addObject:dateKey];
            // 5 秒超时, 找到 key 删除
            [self timerRemove:key dateKey:dateKey];
        }
        FFlus_SDK_Log(@"通知 socket 发送数据:%@",dic);
        // 发送
        [[FFSocket shareInstance] send:dic];
    });
}

#pragma mark 超时删除数据
- (void)timerRemove:(NSString *)key dateKey:(NSString *)dateKey{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, FF_MSG_TimeOut * NSEC_PER_SEC), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (key) {
            [_dictionaryLock lock];
            responseBlock complete = [self.callbackBlock objectForKey:key];
            if (complete != nil) {
                FFMessageModel *model = [FFMessageModel new];
                model.rval = -100;
                // 是否是当前发送的指令超时
                if ([[self.currentComplete objectAtIndex:0] isEqualToString:dateKey]) {
                    complete(NO, model);
                    FFlus_SDK_Log(@"%@指令超时",key);
                    [_callbackBlock removeObjectForKey:key];
                }
            }
            [_dictionaryLock unlock];
        }
    });

}

- (NSString *)getDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    return currentDateStr;
}

#pragma mark - 组建数据包
- (NSMutableDictionary *)buildPacket:(int)tokenNumber andMsgid:(int)msgid andParam:(int)param {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@(tokenNumber) forKey:@"token"];
    [dict setObject:@(msgid) forKey:@"msgid"];
    if (param >= 0) {
        [dict setObject:@(param) forKey:@"param"];
    }
    return dict;
    
}

#pragma mark - notify/被动接受的包
- (void)handleNotify:(FFMessageModel *)messageModel {
    if (self.cameraNotifyBlock) {
        self.cameraNotifyBlock(messageModel);
    }
}

#pragma mark - 开始会话
- (void)startSession:(responseBlock)block {
    NSMutableDictionary *dict = [self buildPacket:0 andMsgid:MSGID_START_SESSION andParam:-1];
    [self sendMsg:dict withMsgid:MSGID_START_SESSION block:block];
}

#pragma mark - 心跳回复
- (void)heardbeat {
    NSMutableDictionary *dict = [self buildPacket:self.tokenNumber andMsgid:MSGID_HEARTBEAT andParam:-1];
    FFlus_SDK_Log(@"通知 socket 发送数据:%@",dict);
    // 直接发送，返回结果当NOTIFY来处置
    [[FFSocket shareInstance] send:dict];
}

#pragma mark - 停止会话
- (void)stopSession:(responseBlock)block {
    NSMutableDictionary *dict = [self buildPacket:self.tokenNumber andMsgid:MSGID_STOP_SESSION andParam:-1];
    [self sendMsg:dict withMsgid:MSGID_STOP_SESSION block:block];
}

#pragma mark - 设置时间戳
- (void)SetDateImPrint:(NSString *)param result:(responseBlock)callback {
}

#pragma mark - 获取剩余可录影时长
- (void)getRecordRemainTimeCount:(responseBlock)block {
    NSMutableDictionary *dict = [self buildPacket:self.tokenNumber andMsgid:MSGID_GET_RECORD_REMAIN_TIME_COUNT andParam:-1];
    [self sendMsg:dict withMsgid:MSGID_GET_RECORD_REMAIN_TIME_COUNT block:block];
}

#pragma mark - 获取剩余拍照数量
- (void)getPhotoRemainQuantityCount:(responseBlock)block {
    NSMutableDictionary *dict = [self buildPacket:self.tokenNumber andMsgid:MSGID_GET_PHOTO_REMAIN_QUANTITY andParam:-1];
    [self sendMsg:dict withMsgid:MSGID_GET_PHOTO_REMAIN_QUANTITY block:block];
}

#pragma mark - 关闭VF
- (void)stopVF:(responseBlock)block {
    NSMutableDictionary *dict = [self buildPacket:self.tokenNumber andMsgid:MSGID_STOP_VF andParam:-1];
    [self sendMsg:dict withMsgid:MSGID_STOP_VF block:block];
}

#pragma mark - 重置VF
- (void)resetVF:(responseBlock)block {
    NSMutableDictionary *dict = [self buildPacket:self.tokenNumber andMsgid:MSGID_RESET_VF andParam:-1];
    [self sendMsg:dict withMsgid:MSGID_RESET_VF block:block];
}

#pragma mark - SD卡初始化
- (void)formatSDCard:(responseBlock)block {
    NSMutableDictionary *dict = [self buildPacket:self.tokenNumber andMsgid:MSGID_FARMAT_SD_CARD andParam:-1];
    [self sendMsg:dict withMsgid:MSGID_FARMAT_SD_CARD block:block];
}

#pragma mark - 获取电量
- (void)getBatteryLevel:(responseBlock)block {
//    NSMutableDictionary *dict = [self buildPacket:self.tokenNumber andMsgid:MSGID_CAMERA_GET_BATTERY andParam:-1];
//    [self sendMsg:dict withMsgid:MSGID_CAMERA_GET_BATTERY block:block];
}

#pragma mark - 相机关机
- (void)closeMachine:(responseBlock)block {
    NSMutableDictionary *dict = [self buildPacket:self.tokenNumber andMsgid:MSGID_CAMERA_POWEROFF andParam:-1];
    [self sendMsg:dict withMsgid:MSGID_CAMERA_POWEROFF block:block];
}

#pragma mark - 开启录像
- (void)startVideoRecord:(responseBlock)block {
    NSMutableDictionary *dict = [self buildPacket:self.tokenNumber andMsgid:MSGID_CAMERA_START_RECORD andParam:-1];
    [self sendMsg:dict withMsgid:MSGID_CAMERA_START_RECORD block:block];
}

#pragma mark - 停止录像
- (void)stopVideoRecord:(responseBlock)block {
    NSMutableDictionary *dict = [self buildPacket:self.tokenNumber andMsgid:MSGID_CAMERA_STOP_RECORD andParam:-1];
    [self sendMsg:dict withMsgid:MSGID_CAMERA_STOP_RECORD block:block];
}

#pragma mark - 设置定时录像时间
- (void)setDelayRecordTime:(int)time result:(responseBlock)block {
    NSMutableDictionary *dict = [self buildPacket:self.tokenNumber andMsgid:MSGID_SET_DELAY_RECORD_TIME andParam:time];
    [self sendMsg:dict withMsgid:MSGID_SET_DELAY_RECORD_TIME block:block];
}

#pragma mark - 开启定时录影
- (void)startDelayRecord:(responseBlock)block {
    NSMutableDictionary *dict = [self buildPacket:self.tokenNumber andMsgid:MSGID_START_DELAY_RECORD andParam:-1];
    [self sendMsg:dict withMsgid:MSGID_START_DELAY_RECORD block:block];
}

#pragma mark - 取消定时录影
- (void)cancelDelayRecord:(responseBlock)block {
    NSMutableDictionary *dict = [self buildPacket:self.tokenNumber andMsgid:MSGID_CANCEL_DELAY_RECORD andParam:-1];
    [self sendMsg:dict withMsgid:MSGID_CANCEL_DELAY_RECORD block:block];
}

#pragma mark - 拍照
- (void)takePhoto:(responseBlock)block {
    NSMutableDictionary *dict = [self buildPacket:self.tokenNumber andMsgid:MSGID_CAMERA_CAPTURE andParam:-1];
    [self sendMsg:dict withMsgid:MSGID_CAMERA_CAPTURE block:block];
}

#pragma mark - 设置定时拍照时间
- (void)setDelayCaptureTime:(int)time result:(responseBlock)block {
    NSMutableDictionary *dict = [self buildPacket:self.tokenNumber andMsgid:MSGID_SET_DELAY_CAPTURE_TIME andParam:time];
    [self sendMsg:dict withMsgid:MSGID_SET_DELAY_CAPTURE_TIME block:block];
}

#pragma mark - 开始定时拍照
- (void)startDelayCapture:(responseBlock)block {
    NSMutableDictionary *dict = [self buildPacket:self.tokenNumber andMsgid:MSGID_START_DELAY_CAPTURE andParam:-1];
    [self sendMsg:dict withMsgid:MSGID_START_DELAY_CAPTURE block:block];
}

#pragma mark -取消定时拍照
- (void)cancelDelayCapture:(responseBlock)block {
    NSMutableDictionary *dict = [self buildPacket:self.tokenNumber andMsgid:MSGID_CANCEL_DELAY_CAPTURE andParam:-1];
    [self sendMsg:dict withMsgid:MSGID_CANCEL_DELAY_CAPTURE block:block];
}

#pragma mark - 获取所有设置信息
- (void)systemGetAllCurrentSettings:(responseBlock)block {
    NSMutableDictionary *dict = [self buildPacket:self.tokenNumber andMsgid:MSGID_QUERY_CUR_SETTINGS andParam:-1];
    [self sendMsg:dict withMsgid:MSGID_QUERY_CUR_SETTINGS block:block];
}

#pragma mark - 获取所有设备信息（序列号，设备名，版本号等等）
- (void)systemGetDeviceInfo:(responseBlock)block {
    NSMutableDictionary *dict = [self buildPacket:self.tokenNumber andMsgid:MSGID_GET_DEVICEINFO andParam:-1];
    [self sendMsg:dict withMsgid:MSGID_GET_DEVICEINFO block:block];
}

#pragma mark - 设置视频质量
- (void)setSystemVideoQuality:(EN_QUALITY_TYPE)recordQuality result:(responseBlock)block {
    NSMutableDictionary *dict = [self buildPacket:self.tokenNumber andMsgid:MSGID_SET_RECORD_QUALITY andParam:recordQuality];
    [self sendMsg:dict withMsgid:MSGID_SET_RECORD_QUALITY block:block];
}

#pragma mark - 设置iso
- (void)setSystemISO:(EN_ISO_TYPE)ISOType result:(responseBlock)block {
    NSMutableDictionary *dict = [self buildPacket:self.tokenNumber andMsgid:MSGID_SET_CAPTURE_ISO andParam:ISOType];
    [self sendMsg:dict withMsgid:MSGID_SET_CAPTURE_ISO block:block];
}
#pragma mark - 设置EVO
- (void)setSystemEV:(EN_EV_TYPE)EVType result:(responseBlock)block {
    NSMutableDictionary *dict = [self buildPacket:self.tokenNumber andMsgid:MSGID_SET_E_VALUE andParam:EVType];
    [self sendMsg:dict withMsgid:MSGID_SET_E_VALUE block:block];
}
#pragma mark - 设置快门时间
- (void)setSystemShutter:(EN_SHUTTER_TYPE)shutterType result:(responseBlock)block {
    NSMutableDictionary *dict = [self buildPacket:self.tokenNumber andMsgid:MSGID_SET_EXPOSURE_TIME andParam:shutterType];
    [self sendMsg:dict withMsgid:MSGID_SET_EXPOSURE_TIME block:block];
}

#pragma mark - 设置照片质量
- (void)setSystemPhotoQuality:(EN_QUALITY_TYPE)captureQuality result:(responseBlock)block {
    NSMutableDictionary *dict = [self buildPacket:self.tokenNumber andMsgid:MSGID_SET_CAPTURE_QUALITY andParam:captureQuality];
    [self sendMsg:dict withMsgid:MSGID_SET_CAPTURE_QUALITY block:block];
}
#pragma mark - 设置HDR
- (void)setSystemHDR:(SWITCH_TYPE)param result:(responseBlock)block {
    NSMutableDictionary *dict = [self buildPacket:self.tokenNumber andMsgid:MSGID_SET_HDR andParam:param];
    [self sendMsg:dict withMsgid:MSGID_SET_HDR block:block];
}

#pragma mark - 设置AWB
- (void)setSystemWB:(EN_AWB_TYPE)AWBType result:(responseBlock)block {
    NSMutableDictionary *dict = [self buildPacket:self.tokenNumber andMsgid:MSGID_SET_AWB andParam:AWBType];
    [self sendMsg:dict withMsgid:MSGID_SET_AWB block:block];
}


#pragma mark - 恢复出厂设置
- (void)SystemReset:(responseBlock)block{
    NSMutableDictionary *dict = [self buildPacket:self.tokenNumber andMsgid:MSGID_CAMERA_RESET_FACTORY andParam:-1];
    [self sendMsg:dict withMsgid:MSGID_CAMERA_RESET_FACTORY block:block];
}

#pragma mark - 风扇控制
- (void)setFan:(int)fantype result:(responseBlock)block{
    NSMutableDictionary *dict = [self buildPacket:self.tokenNumber andMsgid:MSGID_CAMERA_FUN_CONTROL andParam:fantype];
    [self sendMsg:dict withMsgid:MSGID_CAMERA_FUN_CONTROL block:block];
}

#pragma mark - 设置自动休眠时间
- (void)setAutoSleepTime:(EN_AUTO_SLEEP_TIME_TYPE)sleepTime result:(responseBlock)block {
    NSMutableDictionary *dict = [self buildPacket:self.tokenNumber andMsgid:MSGID_SET_AUTO_SLEEP_TIME andParam:sleepTime];
    [self sendMsg:dict withMsgid:MSGID_SET_AUTO_SLEEP_TIME block:block];
}


#pragma mark - 设置缩时录影
- (void)settimelapse:(SWITCH_TYPE)timelapse result:(responseBlock)block {
    NSMutableDictionary *dict = [self buildPacket:self.tokenNumber andMsgid:MSGID_SET_RECORD_TIMELAPSE andParam:timelapse];
    [self sendMsg:dict withMsgid:MSGID_SET_RECORD_TIMELAPSE block:block];
}

- (void)changeModel:(EN_VF_RESOLUTION_TYPE)type result:(responseBlock)block{
    NSMutableDictionary *dict = [self buildPacket:self.tokenNumber andMsgid:MSGID_SET_RECORD_RESOLUTION andParam:type];
    [self sendMsg:dict withMsgid:MSGID_SET_RECORD_RESOLUTION block:block];
}

@end
