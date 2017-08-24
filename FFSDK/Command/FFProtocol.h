//
//  F4PProtocol.h
//  Socket_for_Camera
//
//  Created by lsq on 2017/5/20.
//  Copyright © 2017年 detu. All rights reserved.
//

// socket host port
#define FF_HOST                         @"192.168.xxx.x"
#define FF_PORT                         1234
// rtsp流
#define FFRtspStream                    @"rtsp://192.168.xxx.x"

typedef enum ERR_CODE_LIST {
    SESSION_HAVENOT_STARTED =1,
    SESSION_START_ALREADY = 2,
    RET_SUCCESS = 0,
    RET_UNKNOWN_ERROR = -1,
    
    RET_SESSION_START_FAIL = -2,
    RET_INVALID_TOKEN = -3,
    RET_REACH_MAX_CLNT = -4,
    RET_JSON_PACKAGE_ERROR = -5,
    
    
    RET_OPERATION_UNSUPPORTED = -7,
    RET_INVALID_OPERATION = -8,			//msgid invalid
    RET_INVALID_OPERATION_VALUE = -9,   //param invalid
    
    RET_NO_MORE_SPACE = -10,
    RET_CARD_PROTECTED = -11,
    RET_NO_MORE_MEMORY = -12,
    RET_CART_REMOVED = -13,
    RET_HDMI_INSERTED = -14,
    
    RET_SYSTEM_BUSY = -15,
    RET_F4PRO_NOT_READY = -16,
    RET_SYSTEM_BUSY_RECORDING = -17,
    RET_SYSTEM_BUSY_CAPTURING = -18,
    RET_SYSTEM_DEVICE_ABNORMAL = -19,
    RET_A12_BOOTUP_FAILURE = -20,
    RET_SYNC_SETTINGS_FAILURE = -21,
    
    RET_SYSTEM_BUSY_SETTING = -29,
    RET_CAMERA_HAVENOT_BOOTED = -30,
    RET_SYSTEM_BUSY_DELAY_CAPTURING = -31,
    RET_SYSTEM_BUSY_DELAY_RECORDING = -32,
    RET_NOT_IN_DELAY_CAPTURING_STATE = -33,
    RET_NOT_IN_DELAY_RECORDING_STATE = -34,
    RET_STORAGE_NOT_READY = -35,
    RET_CAMERA_NOT_READY = -36,
    RET_CAMERA_NO_SDCARD = -37,
    
    
    RET_ERR_CODE_LAST
} EN_RET_CODE_LIST;

typedef enum CLIENT_MSGID_LIST {
    MSGID_UNKNOWN = 999,
    //session
    MSGID_START_SESSION                  = 1001,        //开启会话
    MSGID_STOP_SESSION                   = 1002,        //关闭会话
    MSGID_RESTART_SESSION                = 1003,
    MSGID_FORCE_CATCH_SESSION            = 1004,
    MSGID_HEARTBEAT                      = 1010,        //心跳
    
    //photo
    MSGID_CAMERA_CAPTURE                 = 2001,        //拍照
    MSGID_GET_PHOTO_AMOUNTS              = 2002,        //
    MSGID_SET_CAPTURE_SIZE               = 2003,        //-
    MSGID_GET_CAPTURE_SIZE               = 2004,        //-
    MSGID_SET_CAPTURE_QUALITY            = 2005,        //设置拍照质量
    MSGID_GET_CAPTURE_QUALITY            = 2006,        //获取拍照质量
    MSGID_SET_EXPOSURE_TIME              = 2007,        //设置快门速度（曝光时长）
    MSGID_GET_EXPOSURE_TIME              = 2008,        //
    MSGID_START_DELAY_CAPTURE            = 2009,        //开始定时拍照
    MSGID_CANCEL_DELAY_CAPTURE           = 2010,        //取消定时拍照
    MSGID_SET_DELAY_CAPTURE_TIME         = 2011,		//设置定时拍照时间
    MSGID_GET_DELAY_CAPTURE_TIME         = 2012,		//获取定时拍照时间
    MSGID_GET_DELAY_CAPTURE_REMAIN_TIME  = 2013,		//获取定时拍照剩余时间
    MSGID_GET_PHOTO_REMAIN_QUANTITY      = 2020,		//获取剩余拍照数量
    
    
    //image
    MSGID_SET_CAPTURE_ISO                = 2101,        //设置ISO
    MSGID_GET_CAPTURE_ISO                = 2102,        //获取ISO
    MSGID_SET_CAPTURE_SCENCE             = 2103,        //sunlight,//-
    MSGID_GET_CAPTURE_SCENCE             = 2104,        //sunlight,//-
    MSGID_SET_EFFECT_MODE                = 2105,
    MSGID_GET_EFFECT_MODE                = 2106,
    MSGID_SET_E_VALUE                    = 2107,        //设置EV值
    MSGID_GET_E_VALUE                    = 2108,        //获取EV值
    MSGID_SET_AWB                        = 2109,        //设置AWB
    MSGID_GET_AWB                        = 2110,        //获取AWB
    MSGID_SET_SHARPNESS                  = 2111,
    MSGID_GET_SHARPNESS                  = 2112,
    MSGID_SET_METERING                   = 2113,
    MSGID_GET_METERING                   = 2114,
    MSGID_SET_HDR                        = 2115,        //设置HDR
    MSGID_GET_HDR                        = 2116,        //获取HDR
    
    //recording
    MSGID_CAMERA_START_RECORD            = 3001,        //开始录制
    MSGID_CAMERA_STOP_RECORD             = 3002,        //停止录制
    MSGID_SET_RECORD_RESOLUTION          = 3003,        //-
    MSGID_GET_RECORD_RESOLUTION          = 3004,        //-
    MSGID_SET_RECORD_QUALITY             = 3005,        //设置录影质量
    MSGID_GET_RECORD_QUALITY             = 3006,        //获取录影质量
    MSGID_SET_RECORD_AUDIO               = 3007,		//
    MSGID_GET_RECORD_AUDIO               = 3008,		//-
    MSGID_SET_RECORD_LOOP                = 3009,		//
    MSGID_GET_RECORD_LOOP                = 3010,		//-
    MSGID_SET_RECORD_SPLIT_TIME          = 3011,        //
    MSGID_GET_RECORD_SPLIT_TIME          = 3012,        //-
    MSGID_SET_RECORD_TIMELAPSE           = 3013,        //设置缩时录影
    MSGID_GET_RECORD_TIMELAPSE           = 3014,        //获取缩时录影
    MSGID_START_DELAY_RECORD             = 3015,        //开启定时录影
    MSGID_CANCEL_DELAY_RECORD            = 3016,        //取消定时录影
    MSGID_GET_DELAY_RECORD_REMAIN_TIME 	 = 3017,		//获取定时录影倒计时时间
    MSGID_SET_DELAY_RECORD_TIME          = 3018,		//设置定时录影时长
    MSGID_GET_DELAY_RECORD_TIME          = 3019,
    MSGID_GET_RECORDING_TIME_COUNT       = 3020,	 	//获取当前录制时间
    MSGID_GET_RECORD_REMAIN_TIME_COUNT   = 3021,		//获取剩余可录影时长
    
    //notification
    MSGID_NOTIFY_F4PRO_BOOT_SUCCESS      = 5001,
    MSGID_NOTIFY_F4PRO_BOOT_FAILED       = 5002,
    MSGID_NOTIFY_DELAY_CAPTURE_TIMECOUNT = 5003,        //定时拍照倒计时时间
    MSGID_NOTIFY_DELAY_RECORD_TIMECOUNT  = 5004,        //定时录制倒计时时间
    MSGID_NOTIFY_START_CAPTURE           = 5005,        //定时倒计时拍照启动
    MSGID_NOTIFY_START_RECORD            = 5006,        //定时倒计时录制启动
    MSGID_NOTIFY_STOP_RECORD             = 5007,        //
    MSGID_NOTIFY_RECORD_TIMECOUNT        = 5008,        // 录影时间
    
    MSGID_NOTIFY_BATTERY                 = 5009,        //电量notify
    MSGID_NOTIFY_TEMPERATURE             = 5010,        //温度notify
    MSGID_NORIFY_SDCARD_CAPACITY         = 5011,        //卡剩余容量

    //live view /pre stream /rtsp server
    MSGID_RESET_VF                       = 7001,        //重置VF（开关流）
    MSGID_STOP_VF                        = 7002,        //停止VF（开关流）
    MSGID_SET_PREVIEW_SIZE               = 7003,
    MSGID_GET_PREVIEW_SIZE               = 7004,
    MSGID_SET_PREVIEW_BITRATE            = 7005,
    MSGID_GET_PREVIEW_BITRATE            = 7006,
    MSGID_SET_PREVIEW_FPS                = 7007,
    MSGID_GET_PREVIEW_FPS                = 7008,
    MSGID_SET_PREVIEW_AUDIO              = 7009,
    MSGID_GET_PREVIEW_AUDIO              = 7010,
    
    //wifi control
    MSGID_CAMERA_ENABLE_WIFI_2_4G        = 8001,        //2.4/5
    MSGID_CAMERA_ENABLE_WIFI_5G          = 8002,
    MSGID_CAMERA_GET_WIFI_STATE          = 8003,        //获取WIFI状态，WIFI名称和WIFI开关状态
    MSGID_MODIFY_WIFI_PASSWORD           = 8004,        //修改密码
    
    
    //system
    MSGID_CAMERA_POWEROFF                = 9001,        //关机
    MSGID_CAMERA_AUTO_POWEROFF           = 9002,        //自动关机时间
    MSGID_CAMERA_RESET_FACTORY           = 9003,        //恢复出厂设置
    MSGID_GET_DEVICEINFO                 = 9004,        //获取所有设备信息（序列号，设备名，版本号等等）
    MSGID_QUERY_CUR_SETTINGS             = 9005,        //获取所有设置信息
    MSGID_QUERY_CUR_STATUS               = 9006,
    MSGID_GET_SD_CARD_STATE              = 9007,
    MSGID_FARMAT_SD_CARD                 = 9008,        //格式化卡
    MSGID_SET_AUTO_SLEEP_TIME            = 9009,        //自动休眠时间
    
    MSGID_CAMERA_SET_BEEP_SWITCH         = 9010,        //-
    MSGID_CAMERA_GET_BEEP_SWITCH         = 9011,        //-
    MSGID_CAMERA_SET_FUN_SWITCH          = 9012,        //-
    MSGID_CAMERA_GET_FUN_SWITCH          = 9013,        //-
    MSGID_CAMERA_SET_LED_SWITCH          = 9014,        //-
    MSGID_CAMERA_GET_LED_SWITCH          = 9015,        //-
    MSGID_CAMERA_SET_LIGHT_FREQ          = 9016,        //-
    MSGID_CAMERA_GET_LIGHT_FREQ          = 9017,        //-
    MSGID_CAMERA_SET_MIC_VOLUME          = 9018,        //-
    MSGID_CAMERA_GET_MIC_VOLUME          = 9019,        //-
    
    MSGID_CAMERA_GET_TBATERY             = 9101,        //获取电量
    MSGID_CAMERA_GET_BOARD_TMP           = 9102,
    MSGID_CAMERA_GET_USB_INSERTED_STATE  = 9103,
    MSGID_CAMERA_SET_DATETIME            = 9104,
    MSGID_CAMERA_FUN_CONTROL             = 9105,        //风扇开关
    
    MSGID_CAMERA_GET_LENS_PARAM          = 9901,
    
    MSGID_CAMERA_END = 9999,
    
    CLIENT_MSGID_LAST
} EN_MSGID_LIST;


// HDR 延时开关状态
typedef enum {
    en_switch_off = 0,
    en_switch_on = 1,
    en_switch_auto = 2,
    
    en_switch_type_max
} SWITCH_TYPE;

// 录音分辨率
typedef enum {
    en_video_resolution_3840x2160_30P,
    en_video_resolution_2080x1024_60P,
    
    en_video_resolution_type_max
} EN_VIDEO_RESOLUTION_TYPE;

// 预览分辨率
typedef enum {
    en_vf_resolution_3840x2160_30P,
    en_vf_resolution_2080x1024_60P,
    
    en_vf_resolution_type_max
} EN_VF_RESOLUTION_TYPE;

// 质量
typedef enum {
    en_quality_sfine = 0,
    en_quality_fine,
    en_quality_normal,
    
    en_quality_type_max
} EN_QUALITY_TYPE;

// 照片分辨率
typedef enum {
    en_photo_resolution_3840x2160,
    en_photo_resolution_2880x1440,
    en_photo_resolution_2160x1080,
    en_photo_resolution_1440x720,
    
    en_photo_resolution_type_max
} EN_PHOTO_RESOLUTION_TYPE;


// 卡状态 USB状态
typedef enum {
    en_insert_state_in,
    en_insert_state_out,
    en_insert_state_unknown,
    
    en_insert_state_max
} EN_INSERT_STATE_TYPE;

// 工作模式
typedef enum {
    en_work_mode_preview,	//resolution
    en_work_mode_liveview,
    
    en_work_mode_max
} EN_WORK_MODE_TYPE;

// ISO
typedef enum {
    en_iso_auto,	//resolution
    en_iso_50,
    en_iso_100,
    en_iso_200,
    en_iso_400,
    en_iso_800,
    en_iso_1600,
    en_iso_3200,
    en_iso_6400,
    
    en_iso_type_max
} EN_ISO_TYPE;


// 快门时间
typedef enum {
    en_shut_speed_auto,
    en_shut_speed_250us,
    en_shut_speed_500us,
    en_shut_speed_1ms,
    en_shut_speed_2ms,
    en_shut_speed_4ms,
    en_shut_speed_17ms,
    en_shut_speed_33ms,
    en_shut_speed_67ms,
    en_shut_speed_125ms,
    en_shut_speed_250ms,
    en_shut_speed_500ms,
    en_shut_speed_1s,
    en_shut_speed_2s,
    en_shut_speed_4s,
    en_shut_speed_8s,
    
    en_shut_type_max
}EN_SHUTTER_TYPE;

// AWB
typedef enum {
    en_awb_auto,
    en_awb_daylight,
    en_awb_cloudy,
    en_awb_incandescent,
    en_awb_fluorescent,
    en_awb_outdoor,
    
    en_awb_type_max
} EN_AWB_TYPE;

// EV
typedef enum {
    en_ev_f3,
    en_ev_f2,
    en_ev_f1,
    en_ev_0,
    en_ev_z1,
    en_ev_z2,
    en_ev_z3,
    
    en_ev_type_max
} EN_EV_TYPE;

// 自动休眠时间
typedef enum {
    en_auto_sleep_time_1min,
    en_auto_sleep_time_3min,
    en_auto_sleep_time_5min,
    en_auto_sleep_time_15min,
    
    en_auto_sleep_time_max
} EN_AUTO_SLEEP_TIME_TYPE;

// 设备电源模式
typedef enum {
    en_power_normal,
    en_power_standby,
    en_power_poweroff,
    
    en_power_type_max
} EN_POWER_MANAGER_STATE_TYPE;

typedef enum {
    en_F4Pro_Start = 0,
    en_F4Pro_created,
    en_F4Pro_waitA12_boot,
    en_F4Pro_A12_boot_failed,
    en_F4Pro_Sync_setting,  //at this state, F4 will sync all A12 settings and status and timestamp etc  to make all a12 are ready to work normal
    en_F4Pro_Sync_setting_failed,
    en_F4Pro_normalwork,
    en_F4Pro_pre_capture,
    en_F4Pro_taking_photo,
    en_F4Pro_delay_taking_photo,
    en_F4Pro_pre_record,
    en_F4Pro_start_record,
    en_F4Pro_recording,
    en_F4Pro_stop_record,
    en_F4Pro_delay_recording,
    en_F4Pro_record_aborting,
    //  en_F4Pro_reset_factory,
    //  en_F4Pro_formating,
    //  en_F4Pro_power_off,
    //  en_F4Pro_upgrade,
    en_F4Pro_abnormal,
    
} F4PRO_CAMERA_STATE;

