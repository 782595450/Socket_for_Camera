//
//  FFCameraErrorHandle.m
//  Socket_for_Camera
//
//  Created by lsq on 2017/5/15.
//  Copyright © 2017年 detu. All rights reserved.
//

#import "FFCameraErrorHandle.h"

@implementation FFCameraErrorHandle

+ (instancetype)shareInstance {
    static FFCameraErrorHandle * obj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[FFCameraErrorHandle alloc] init];
    });
    
    return obj;
}

#pragma mark - 错误处理
- (NSString *)handleFFError:(int)error{
    NSString *errorStr = @"未识别的错误类型";
    switch (error) {
        case FFCamera_Error_CONNECTSOCKET_SUCCESS:
            errorStr = @"socket连接成功";
            break;
        case FFCamera_Error_TimeOut:
            errorStr = @"消息返回超时";
            break;
        case FFCamera_Error_CONNECTSOCKET_FAIL:
            errorStr = @"socket连接失败";
            break;
        case FFCamera_Error_Net:
            errorStr = @"网络异常";
            break;
        case FFCamera_Error_Parse:
            errorStr = @"json包解析异常";
            break;
        case FFCamera_Error_RET_SUCCESS:
            errorStr = @"消息返回成功";
            break;
        case FFCamera_Error_SESSION_HAVENOT_STARTED:
            errorStr = @"会话没开始";
            break;
        case FFCamera_Error_SESSION_START_ALREADY:
            errorStr = @"当前会话已存在";
            break;
        case FFCamera_Error_RET_UNKNOWN_ERROR:
            errorStr = @"返回未知错误";
            break;
        case FFCamera_Error_RET_SESSION_START_FAIL:
            errorStr = @"开启会话失败";
            break;
        case FFCamera_Error_RET_INVALID_TOKEN:
            errorStr = @"无效的token";
            break;
        case FFCamera_Error_RET_REACH_MAX_CLNT:
            errorStr = @"相机正在使用中";
            break;
        case FFCamera_Error_RET_JSON_PACKAGE_ERROR:
            errorStr = @"固件JSON包生成错误";
            break;
        case FFCamera_Error_RET_OPERATION_UNSUPPORTED:
            errorStr = @"操作不受支持";
            break;
        case FFCamera_Error_RET_INVALID_OPERATION:
            errorStr = @"无效的操作";
            break;
        case FFCamera_Error_RET_INVALID_OPERATION_VALUE:
            errorStr = @"无效的操作命令";
            break;
        case FFCamera_Error_RET_NO_MORE_SPACE:
            errorStr = @"没有更多的卡容量";
            break;
        case FFCamera_Error_RET_CARD_PROTECTED:
            errorStr = @"卡处于保护状态";
            break;
        case FFCamera_Error_RET_NO_MORE_MEMORY:
            errorStr = @"固件程序内存不足";
            break;
        case FFCamera_Error_RET_CART_REMOVED:
            errorStr = @"SD已移除";
            break;
        case FFCamera_Error_RET_HDMI_INSERTED:
            errorStr = @"HDMI已插入";
            break;
        case FFCamera_Error_RET_SYSTEM_BUSY:
            errorStr = @"系统繁忙";
            break;
        case FFCamera_Error_RET_F4PRO_NOT_READY:
            errorStr = @"相机没准备好";
            break;
        case FFCamera_Error_RET_SYSTEM_BUSY_RECORDING:
            errorStr = @"相机录制繁忙";
            break;
        case FFCamera_Error_RET_SYSTEM_BUSY_CAPTURING:
            errorStr = @"相机拍照繁忙";
            break;
        case FFCamera_Error_RET_SYSTEM_DEVICE_ABNORMAL:
            errorStr = @"系统设备异常";
            break;
        case FFCamera_Error_RET_A12_BOOTUP_FAILURE:
            errorStr = @"系统启动失败";
            break;
        case FFCamera_Error_RET_SYNC_SETTINGS_FAILURE:
            errorStr = @"同步设置失败";
            break;
        case FFCamera_Error_RET_SYSTEM_BUSY_SETTING:
            errorStr = @"系统设置繁忙";
            break;
        case FFCamera_Error_RET_CAMERA_HAVENOT_BOOTED:
            errorStr = @"相机未启动";
            break;
        case FFCamera_Error_RET_SYSTEM_BUSY_DELAY_CAPTURING:
            errorStr = @"定时拍照繁忙";
            break;
        case FFCamera_Error_RET_SYSTEM_BUSY_DELAY_RECORDING:
            errorStr = @"定时录制繁忙";
            break;
        case FFCamera_Error_RET_NOT_IN_DELAY_CAPTURING_STATE:
            errorStr = @"不在定时拍照状态";
            break;
        case FFCamera_Error_RET_NOT_IN_DELAY_RECORDING_STATE:
            errorStr = @"不在定时录制状态";
            break;
        case FFCamera_Error_RET_STORAGE_NOT_READY:
            errorStr = @"SD卡未准备好";
            break;
        case FFCamera_Error_RET_CAMERA_NOT_READY:
            errorStr = @"相机未准备好";
            break;
        case FFCamera_Error_RET_CAMERA_NO_SDCARD:
            errorStr = @"相机没SD卡";
            break;
        case FFCamera_Error_RET_CAMERA_POWERON:
            errorStr = @"相机处于开机状态";
            break;
        case FFCamera_Error_RET_CAMERA_POWERON_FAILED:
            errorStr = @"相机开机失败";
            break;
        case FFCamera_Error_RET_CAMERA_ABNORMAL:
            errorStr = @"相机异常，重启";
            break;
        case FFCamera_Error_RET_CAMERA_UPGRADE:
            errorStr = @"相机处于升级状态";
            break;
        case FFCamera_Error_RET_CAMERA_FACTORY:
            errorStr = @"相机处于厂测模式";
            break;
        case FFCamera_Error_RET_CAMERA_USB_STORAGE:
            errorStr = @"相机处于USB状态";
            break;
        case FFCamera_Error_RET_CAMERA_STANDBY:
            errorStr = @"相机处于待机状态";
            break;
        case FFCamera_Error_RET_CAMERA_LIVEVIEW:
            errorStr = @"相机处于直播状态";
            break;
        case FFCamera_Error_RET_CAMERA_POWEROFF:
            errorStr = @"相机处于关机状态";
            break;
        default:
            break;
    }
    NSLog(@"相机返回结果:%@ 错误码:%i",errorStr,error);
    return errorStr;
    
}


@end
