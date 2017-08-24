//
//  FFCameraInfo.h
//  Socket_for_Camera
//
//  Created by lsq on 2017/5/15.
//  Copyright © 2017年 detu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 拍照模式还是录制模式
 */
typedef enum : NSUInteger {
    FFCameraType_photo = 1,
    FFCameraType_video,
} FFCameraType;

/**
 * 拍摄状态
 */
typedef enum : NSUInteger{
    FFCameraShotState_None,
    FFCameraShotState_Photo,
    FFCameraShotState_StartVideo,
    FFCameraShotState_VideoIng,
    FFCameraShotState_StopVideo,
    FFCameraShotState_TimeRecording,
    FFCameraShotState_TimePhoto,
}FFCameraShotState;

@interface FFCameraInfo : NSObject

// 是否连接上相机
@property (nonatomic, assign) BOOL isConnectCamera;
// 是否在录制
@property (nonatomic, assign) BOOL isTakingMovie;
// SD总内存
@property (nonatomic, assign) int totleSpace;
// SD剩余内存
@property (nonatomic, assign) int freeSpace;
// 相机温度
@property (nonatomic, assign) int temperature;
// 拍摄状态
@property (nonatomic, assign) FFCameraShotState shotState;
// 自动休眠时间
@property (nonatomic, copy) NSString *autoSleeptime;
// 风扇
@property (nonatomic, copy) NSString *fan;
// 定时拍照
@property (nonatomic, assign) int delaycapturetime;
// 定时录影
@property (nonatomic, assign) int delayrecordtime;
// 快门时间
@property (nonatomic, assign) int shutter;
// 缩时录影开关
@property (nonatomic, assign) int timelapse;
// 开启/停止HDR
@property (nonatomic, assign) int HDR;
// 现在拍摄模式，1为照片，2为视频, APP用来记录的模式
@property (nonatomic, assign) int nowRecordMode;
// 是否显示实时预览
@property (nonatomic, assign) BOOL isOpenedLiveStream;
// 正在录制的时间,为0表示没有在录制
@property (nonatomic, assign) int nowMovieRecordingTime;
// 分段时间
@property (nonatomic, assign) int cycleRec;
// 循环录制状态
@property (nonatomic, assign) BOOL cycleRecBool;
// 定时录像状态
@property (nonatomic, assign) int timingRec;
// 拍照状态
@property (nonatomic, assign) int timingPhoto;
// 循环拍照状态
@property (nonatomic, assign) int cyclePhoto;
// 开启/停止WDR
@property (nonatomic, assign) int WDR;
// 曝光
@property (nonatomic, assign) int EV;
// 剩余空间还能拍多少时间的视频
@property (nonatomic, copy) NSString *max_record_time;
// 剩余空间还能拍多少张
@property (nonatomic, copy) NSString *pictureNumber;
// 关机
@property (nonatomic, assign) int powerOff;
// 电量
@property (nonatomic, assign) int battery;
// sd卡状态
@property (nonatomic, assign) int sdCardState;
// iso
@property (nonatomic, assign) int iso;
// 白平衡
@property (nonatomic, assign) int wb;
// 序列号
@property (nonatomic, copy) NSString *seriesNumber;
// 固件版本
@property (nonatomic, copy) NSString *fwVersion;
// 路由应用版本
@property (nonatomic, copy) NSString *routerAppVer;
// 路由系统版本
@property (nonatomic, copy) NSString *routerSysVer;
// 相机固件
@property (nonatomic, copy) NSString *cameraSoftVer;

// 硬件标注
@property (nonatomic, copy) NSString *twinData;
// ssid
@property (nonatomic, copy) NSString * SSID;
// 密码
@property (nonatomic, copy) NSString * pwd;
// VF状态1是VF状态 0不是VF状态
@property (nonatomic,assign) int vfState;
// 视频质量
@property (nonatomic,assign) int videoQuality;
// 照片质量
@property (nonatomic,assign) int photoQuality;
// 型号
@property (nonatomic,copy) NSString *cameraType;
// 视频分段
@property (nonatomic,copy) NSString *dtvideosplittime;

#warning 临时模式
// 模式
@property (nonatomic,assign) int videoModel;

// 数据初始化
- (void)initData;
// 重置
- (void)reset;

@end
