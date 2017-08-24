//
//  FFCameraErrorHandle.h
//  Socket_for_Camera
//
//  Created by lsq on 2017/5/15.
//  Copyright © 2017年 detu. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(int, FFCamera_Error_Type) {
    
    /** 自定义回调 */
    FFCamera_Error_CONNECTSOCKET_SUCCESS                    = 101 ,         // socket连接成功
    FFCamera_Error_TimeOut                                  = -100 ,        // 消息返回超时
    FFCamera_Error_CONNECTSOCKET_FAIL                       = -101 ,        // socket连接失败
    FFCamera_Error_Net                                      = -102 ,        // 网络异常
    FFCamera_Error_Parse                                    = -103 ,        // json包解析异常
    
    /** 相机错误回调 */
    FFCamera_Error_RET_SUCCESS                              = 0 ,           // 消息返回成功
    FFCamera_Error_SESSION_HAVENOT_STARTED                  = 1 ,           // 会话没开始
    FFCamera_Error_SESSION_START_ALREADY                    = 2 ,           // 当前会话已存在
    FFCamera_Error_RET_CAMERA_POWERON                       = 10 ,          // 相机处于开机状态
    FFCamera_Error_RET_CAMERA_POWERON_FAILED                = 11 ,          // 相机开机失败
    FFCamera_Error_RET_CAMERA_ABNORMAL                      = 12 ,          // 相机异常，重启
    FFCamera_Error_RET_CAMERA_UPGRADE                       = 13 ,          // 相机处于升级状态
    FFCamera_Error_RET_CAMERA_FACTORY                       = 14 ,          // 相机处于厂测模式
    FFCamera_Error_RET_CAMERA_USB_STORAGE                   = 15 ,          // 相机处于USB状态
    FFCamera_Error_RET_CAMERA_STANDBY                       = 16 ,          // 相机处于待机状态
    FFCamera_Error_RET_CAMERA_LIVEVIEW                      = 17 ,          // 相机处于直播状态
    FFCamera_Error_RET_CAMERA_POWEROFF                      = 18 ,          // 相机处于关机状态
    FFCamera_Error_RET_UNKNOWN_ERROR                        = -1 ,          // 返回未知错误
    FFCamera_Error_RET_SESSION_START_FAIL                   = -2 ,          // 开启会话失败
    FFCamera_Error_RET_INVALID_TOKEN                        = -3 ,          // 无效的token
    FFCamera_Error_RET_REACH_MAX_CLNT                       = -4 ,          // 相机正在使用中
    FFCamera_Error_RET_JSON_PACKAGE_ERROR                   = -5 ,          // 固件JSON包生成错误
    FFCamera_Error_RET_OPERATION_UNSUPPORTED                = -7 ,          // 操作不受支持
    FFCamera_Error_RET_INVALID_OPERATION                    = -8 ,          // 无效的操作
    FFCamera_Error_RET_INVALID_OPERATION_VALUE              = -9 ,          // 无效的操作命令
    FFCamera_Error_RET_NO_MORE_SPACE                        = -10 ,         // 没有更多的卡容量
    FFCamera_Error_RET_CARD_PROTECTED                       = -11 ,         // 卡处于保护状态
    FFCamera_Error_RET_NO_MORE_MEMORY                       = -12 ,         // 固件程序内存不足
    FFCamera_Error_RET_CART_REMOVED                         = -13 ,         // SD已移除
    FFCamera_Error_RET_HDMI_INSERTED                        = -14 ,         // HDMI已插入
    FFCamera_Error_RET_SYSTEM_BUSY                          = -15 ,         // 系统繁忙
    FFCamera_Error_RET_F4PRO_NOT_READY                      = -16 ,         // 相机没准备好
    FFCamera_Error_RET_SYSTEM_BUSY_RECORDING                = -17 ,         // 相机录制繁忙
    FFCamera_Error_RET_SYSTEM_BUSY_CAPTURING                = -18 ,         // 相机拍照繁忙
    FFCamera_Error_RET_SYSTEM_DEVICE_ABNORMAL               = -19 ,         // 系统设备异常
    FFCamera_Error_RET_A12_BOOTUP_FAILURE                   = -20 ,         // 系统启动失败
    FFCamera_Error_RET_SYNC_SETTINGS_FAILURE                = -21 ,         // 同步设置失败
    FFCamera_Error_RET_SYSTEM_BUSY_SETTING                  = -29 ,         // 系统设置繁忙
    FFCamera_Error_RET_CAMERA_HAVENOT_BOOTED                = -30 ,         // 相机未启动
    FFCamera_Error_RET_SYSTEM_BUSY_DELAY_CAPTURING          = -31 ,         // 定时拍照繁忙
    FFCamera_Error_RET_SYSTEM_BUSY_DELAY_RECORDING          = -32 ,         // 定时录制繁忙
    FFCamera_Error_RET_NOT_IN_DELAY_CAPTURING_STATE         = -33 ,         // 不在定时拍照状态
    FFCamera_Error_RET_NOT_IN_DELAY_RECORDING_STATE         = -34 ,         // 不在定时录制状态
    FFCamera_Error_RET_STORAGE_NOT_READY                    = -35 ,         // SD卡未准备好
    FFCamera_Error_RET_CAMERA_NOT_READY                     = -36 ,         // 相机未准备好
    FFCamera_Error_RET_CAMERA_NO_SDCARD                     = -37 ,         // 相机没SD卡
    
};

@interface FFCameraErrorHandle : NSObject

+ (instancetype)shareInstance;

/**
 *  FF错误处理
 */
- (NSString *)handleFFError:(int)error;

@end


