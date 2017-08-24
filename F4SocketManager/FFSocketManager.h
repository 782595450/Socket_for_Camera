//
//  FFSocketManager.h
//  Socket_for_Camera
//
//  Created by lsq on 2017/5/15.
//  Copyright © 2017年 detu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FFCameraInfo.h"
#import "FFCameraErrorHandle.h"
#import "FFProtocol.h"
#import "FFSDK.h"

typedef void (^resultResponseBlock)(FFCamera_Error_Type);
typedef void (^ffNotifyBlock)(int);
typedef void (^ffRetBlock)(id);
typedef void (^ffSocketConnect)(BOOL);

@interface FFSocketManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) FFCameraInfo *cameraInfo;                     // 数据源
@property (nonatomic, copy) ffSocketConnect soccketExceptionBlock;              // socket连接状态
@property (nonatomic, copy) ffNotifyBlock batteryNotifyBlock;                  // 电量notify
@property (nonatomic, copy) ffRetBlock heardbeatBlock;                         // 心跳回复
@property (nonatomic, copy) ffNotifyBlock temperatureNotifyBlock;              // 温度notify
@property (nonatomic, copy) ffNotifyBlock freeMemoryNotifyBlock;               // SD卡剩余内存
@property (nonatomic, copy) ffNotifyBlock delayRecordRemainTimeNotifyBlock;    // 定时录影倒计时时间notify
@property (nonatomic, copy) ffNotifyBlock delayCaptureRemainTimeNotifyBlock;   // 定时拍照剩余时间notify
@property (nonatomic, copy) ffNotifyBlock delayCaptureStartNotifyBlock;        // 定时拍照开始notify
@property (nonatomic, copy) ffNotifyBlock delayRecordStartNotifyBlock;         // 定时录制开始notify
@property (nonatomic, copy) ffNotifyBlock delayCaptureRetBlock;                // 定时拍照成功失败回调
@property (nonatomic, copy) ffNotifyBlock delayRecordRetBlock;                 // 定时录制开始成功失败回调
@property (nonatomic, copy) ffNotifyBlock machinePhotoNotifyBlock;             // 相机单机拍照成功失败回调
@property (nonatomic, copy) ffNotifyBlock machineMovieStartNotifyBlock;        // 相机单机录影开始回调
@property (nonatomic, copy) ffNotifyBlock machineMovieResultNotifyBlock;       // 相机单机录影停止成功失败回调

/**
 * do      建立socket连接
 * param  : 设置结果 命令号
 */
- (void)connectSocketCallBack:(resultResponseBlock)responseBlock;

/**
 * do      开启会话
 */
- (void)startSession:(resultResponseBlock)responseBlock;

/**
 * do      进入预览获取数据
 */
- (void)pushInpreview:(resultResponseBlock)responseBlock ;

/**
 * do      心跳指令
 */
- (void)heardbeat;

/**
 * do      关闭Socket
 */
- (void)closeSocket ;

/**
 * do      拍摄照片
 */
- (void)takePhoto:(resultResponseBlock)responseBlock ;

/**
 * do       设置定时拍照时间
 * @params  time 设置选项
 */
- (void)setDelayCaptureTime:(int)time result:(resultResponseBlock)responseBlock;

/**
 * do       开始定时拍照
 */
-(void)startDelayCapture:(resultResponseBlock)responseBlock;

/**
 * do       取消定时拍照
 */
-(void)cancelDelayCapture:(resultResponseBlock)responseBlock;

/**
 * do      录制视频
 * params: start or stop
 */
- (void)recordStartOrStop:(BOOL)abool callBack:(resultResponseBlock)responseBlock ;

/**
 * do       设置定时录像时间
 * @params  time 设置选项
 */
- (void)setDelayRecordTime:(int)time result:(resultResponseBlock)responseBlock;

/**
 * do      开启定时录影
 */
-(void)startDelayRecord:(resultResponseBlock)responseBlock;

/**
 * do      取消定时录影
 */
-(void)cancelDelayRecord:(resultResponseBlock)responseBlock;


#pragma mark - 各种设置命令接口

/**
 * do      设置EV
 * params: -2  -1  0  1  2
 */
- (void)setEV:(EN_EV_TYPE)type callBack:(resultResponseBlock)responseBlock ;

/**
 * do      设置WB
 * params: auto sunnight cloudy tungsten Fluorscent
 */
- (void)setWB:(EN_AWB_TYPE)type callBack:(resultResponseBlock)responseBlock ;

/**
 * do      设置ISO
 * params: auto 100 200 400 800
 */
- (void)setISO:(EN_ISO_TYPE)type callBack:(resultResponseBlock)responseBlock ;

/**
 * do      设置HDR
 * params: open or close
 */
- (void)setHDR:(SWITCH_TYPE)type callBack:(resultResponseBlock)responseBlock ;

/**
 * do      设置快门自动
 * params: open or close
 */
- (void)setshutter:(EN_SHUTTER_TYPE)type callBack:(resultResponseBlock)responseBlock ;

/**
 * do      设置视频质量
 * params: High     Medium     Low
 */
- (void)setVideoQuality:(EN_QUALITY_TYPE)type callBack:(resultResponseBlock)responseBlock ;

/**
 * do      amba停止会话
 */
- (void)stopSession:(resultResponseBlock)responseBlock ;

/**
 * do      amba停止VF
 */
- (void)stopVF:(resultResponseBlock)responseBlock ;

/**
 * do      amba重置VF
 */
- (void)startVF:(resultResponseBlock)responseBlock ;

/**
 * do      关闭相机
 */
- (void)closeMachine:(resultResponseBlock)responseBlock;


/**
 * do      SD卡格式化
 */
- (void)FormatDisk:(resultResponseBlock)responseBlock ;

/**
 * do      恢复出厂设置
 */
- (void)SystemReset:(resultResponseBlock)responseBlock ;

/**
 * do      风扇控制
 */
- (void)setFan:(int)fantype callBack:(resultResponseBlock)responseBlock ;

/**
 * do      自动休眠时间设置
 */
- (void)setAutoSleep:(EN_AUTO_SLEEP_TIME_TYPE)sleepTimeType callback:(resultResponseBlock)responseBlock;

/**
 * do      缩时录影设置
 */
- (void)setTimelapse:(SWITCH_TYPE)type callBack:(resultResponseBlock)responseBlock ;

/**
 * do      获取剩余可录影时长
 */
- (void)getRecordRemainTimeCount:(resultResponseBlock)responseBlock ;

/**
 * do      获取剩余拍照数量
 */
- (void)getPhotoRemainQuantityCount:(resultResponseBlock)responseBlock ;

/**
 * do       定时数据转换
 */
- (int)switchDelay:(int)time;

#warning 临时模式切换
- (void)changeModel:(EN_VF_RESOLUTION_TYPE)type callBack:(resultResponseBlock)responseBlock ;

@end
