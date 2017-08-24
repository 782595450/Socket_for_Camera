//
//  FFSDK.h
//  Socket_for_Camera
//
//  Created by lsq on 2017/5/20.
//  Copyright © 2017年 detu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FFMessageModel.h"
#import "FFProtocol.h"

/**
 *  自定义Log，可配置开关（用于替换NSLog）
 */
#define FFlus_SDK_Log(format,...) CustomLog(__FUNCTION__,__LINE__,format,##__VA_ARGS__)


typedef void (^responseBlock)(BOOL,FFMessageModel *);
typedef void (^successBlock)(BOOL success);
typedef void (^notifyBlock)(FFMessageModel *);

@interface FFSDK : NSObject

+ (FFSDK *)instance;

/**
 *  自定义Log
 *  @warning 外部可直接调用 FFlus_SDK_Log
 *
 *  @param func         方法名
 *  @param lineNumber   行号
 *  @param format       Log内容
 *  @param ...          个数可变的Log参数
 */
void CustomLog(const char *func, int lineNumber, NSString *format, ...);

/**
 *  Log 输出开关 (默认关闭)
 */
+ (void)openLog:(BOOL)enable;

/**
 *  相机notify
 */
@property (nonatomic, copy) notifyBlock cameraNotifyBlock;

/**
 *  socket连接成功失败回调
 */
@property (nonatomic, strong) successBlock socketCallBackBlock;

/**
 *  建立socket连接
 */
- (void)connectSocket:(successBlock)block;

/**
 *  关闭socket连接
 */
- (void)disConnect;

/**
 *  获取所有设置信息
 */
- (void)systemGetAllCurrentSettings:(responseBlock)block;

/**
 *  获取所有设备信息（序列号，设备名，版本号等等）
 */
- (void)systemGetDeviceInfo:(responseBlock)block;

/**
 *  关闭VF
 */
- (void)stopVF:(responseBlock)block;

/**
 *  重置VF
 */
- (void)resetVF:(responseBlock)block;

/**
 *  SD卡初始化
 */
- (void)formatSDCard:(responseBlock)block;

/**
 *  获取电量
 */
- (void)getBatteryLevel:(responseBlock)block;

/**
 *  相机关机
 */
- (void)closeMachine:(responseBlock)block;

/**
 *  开启会话
 */
- (void)startSession:(responseBlock)block;

/**
 *  心跳
 */
- (void)heardbeat;

/**
 *  停止会话
 */
- (void)stopSession:(responseBlock)block;

/**
 *  获取剩余可录影时长
 */
- (void)getRecordRemainTimeCount:(responseBlock)block;

/**
 *  获取剩余拍照数量
 */
- (void)getPhotoRemainQuantityCount:(responseBlock)block;

/**
 *  开启录像
 */
- (void)startVideoRecord:(responseBlock)block;

/**
 *  停止录像
 */
- (void)stopVideoRecord:(responseBlock)block;

/**
 *  设置定时录像时间
 */
- (void)setDelayRecordTime:(int)time result:(responseBlock)block;

/**
 *  开启定时录影
 */
- (void)startDelayRecord:(responseBlock)block;

/**
 *  取消定时录影
 */
- (void)cancelDelayRecord:(responseBlock)block;

/**
 *  拍照
 */
- (void)takePhoto:(responseBlock)block;

/**
 *  设置定时拍照时间
 */
- (void)setDelayCaptureTime:(int)time result:(responseBlock)block;

/**
 *  开始定时拍照
 */
- (void)startDelayCapture:(responseBlock)block;

/**
 *  取消定时拍照
 */
- (void)cancelDelayCapture:(responseBlock)block;

/**
 *  设置时间戳
 *  @param param 时间戳
 */
- (void)SetDateImPrint:(NSString *)param result:(responseBlock)block;

/**
 *  设置视频质量
 *  @param recordQuality    参数
 */
- (void)setSystemVideoQuality:(EN_QUALITY_TYPE)recordQuality result:(responseBlock)block;

/**
 *  设置iso
 *  @param ISOType  参数
 */
- (void)setSystemISO:(EN_ISO_TYPE)ISOType result:(responseBlock)block;

/**
 *  设置EVO
 *  @param EVType    参数
 */
- (void)setSystemEV:(EN_EV_TYPE)EVType result:(responseBlock)block;

/**
 *  设置快门时间
 *  @param shutterType   参数
 */
- (void)setSystemShutter:(EN_SHUTTER_TYPE)shutterType result:(responseBlock)block;

/**
 *  设置照片质量
 *  @param captureQuality    参数
 */
- (void)setSystemPhotoQuality:(EN_QUALITY_TYPE)captureQuality result:(responseBlock)block;

/**
 *  设置HDR
 *  @param HDRtype  参数
 */
- (void)setSystemHDR:(SWITCH_TYPE)HDRtype result:(responseBlock)block;

/**
 *  设置WB
 *  @param AWBType  参数
 */
- (void)setSystemWB:(EN_AWB_TYPE)AWBType result:(responseBlock)block;

/**
 *  恢复出厂设置
 */
- (void)SystemReset:(responseBlock)block;

/**
 *  风扇控制
 */
- (void)setFan:(int)fantype result:(responseBlock)block;

/**
 *  设置自动休眠时间
 *  @param sleepTime    参数
 */
- (void)setAutoSleepTime:(EN_AUTO_SLEEP_TIME_TYPE)sleepTime result:(responseBlock)block;

/**
 *  设置缩时录影
 *  @param timelapse    参数
 */
- (void)settimelapse:(SWITCH_TYPE)timelapse result:(responseBlock)block;


#warning 临时模式切换
- (void)changeModel:(EN_VF_RESOLUTION_TYPE)type result:(responseBlock)block;

@end
