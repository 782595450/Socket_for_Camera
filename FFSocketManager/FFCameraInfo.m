//
//  FFCameraInfo.m
//  Socket_for_Camera
//
//  Created by lsq on 2017/5/15.
//  Copyright © 2017年 detu. All rights reserved.
//

#import "FFCameraInfo.h"

@implementation FFCameraInfo

//初始化数据
- (void)initData{
    self.isTakingMovie              = NO;   //当前没有在拍视频
    self.isOpenedLiveStream         = YES;  //开启实时视频
    self.nowRecordMode              = 1;    //当前在拍照
    self.sdCardState                = 1;    //默认插上
    self.SSID                       = @""; //默认没连接
    self.seriesNumber               = @""; //默认空
    self.isConnectCamera            = NO;   //默认相机没连上
    self.autoSleeptime              = @""; //默认自动休眠时间
    self.timelapse                  = -1;   //默认缩时录影关
    self.HDR                        = YES;  //默认HDR开启（待验证）
    self.shotState                  = FFCameraShotState_None;
    self.pictureNumber              = @""; //默认为空
    self.max_record_time            = @""; //默认为空
    self.delaycapturetime           = 0;    //默认定时拍照时间为0
    self.delayrecordtime            = 0;    //默认定时录影时间为0
}


//重置
- (void)reset{
    
    self.isTakingMovie              = NO;   //当前没有在拍视频
    self.isOpenedLiveStream         = YES;  //开启实时视频
    self.nowRecordMode              = 1;    //当前在拍照
    self.sdCardState                = 1;    //默认插上
    self.SSID                       = @""; //默认没连接
    self.seriesNumber               = @""; //默认空
    self.isConnectCamera            = NO;   //默认相机没连上
    self.autoSleeptime              = @""; //默认自动休眠时间
    self.timelapse                  = -1;   //默认缩时录影关
    self.HDR                        = YES;  //默认HDR开启
    self.shotState                  = FFCameraShotState_None;
    self.pictureNumber              = @""; //默认为空
    self.max_record_time            = @""; //默认为空
    self.delaycapturetime           = 0;    //默认定时拍照时间为0
    self.delayrecordtime            = 0;    //默认定时录影时间为0
    
    self.nowMovieRecordingTime      = 0;
    self.isTakingMovie              = NO;
    
    self.seriesNumber               = nil;
    self.fwVersion                  = nil;
    self.twinData                   = nil;
    self.SSID                       = nil;
    self.pwd                        = nil;
    self.cameraType                 = nil;
    self.dtvideosplittime           = nil;
}


@end
