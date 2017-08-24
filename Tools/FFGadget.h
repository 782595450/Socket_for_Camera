//
//  FFGadget.h
//  Socket_for_Camera
//
//  Created by lsq on 2017/5/20.
//  Copyright © 2017年 detu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFGadget : NSObject

+ (instancetype)sharedInstance;

/**
 *  时间转换
 *
 *  @param duration 时长
 *
 *  @return  00:00:00格式时间
 */
- (NSString *)timeConversion:(int)duration;


@end
