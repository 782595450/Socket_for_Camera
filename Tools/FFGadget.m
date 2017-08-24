//
//  FFGadget.m
//  Socket_for_Camera
//
//  Created by lsq on 2017/5/20.
//  Copyright © 2017年 detu. All rights reserved.
//

#import "FFGadget.h"

@implementation FFGadget

+ (instancetype)sharedInstance{
    static FFGadget *obj = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        obj = [[FFGadget alloc] init];
    });
    return obj;
}

//时间转换
- (NSString *)timeConversion:(int)duration{
    NSString *timeData;
    int iHour = duration/3600;
    int iMin = (duration-iHour*3600)/60;
    int iSen = duration-iHour*3600-iMin*60;
    
    if (iHour >1 ) {
        timeData=[NSString stringWithFormat:@"%.2d:%.2d:%.2d", iHour, iMin, iSen];
    }else{
        timeData=[NSString stringWithFormat:@"%.2d:%.2d", iMin, iSen];
    }
    
    return timeData;
}

@end
