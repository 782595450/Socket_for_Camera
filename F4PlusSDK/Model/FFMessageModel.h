//
//  FFMessageModel.h
//  Socket_for_Camera
//
//  Created by lsq on 2017/5/20.
//  Copyright © 2017年 detu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFMessageModel : NSObject

@property (nonatomic, assign) int msgid; //消息命令
@property (nonatomic, assign) int token; //会话ID
@property (nonatomic, strong) id  param; //消息字段
@property (nonatomic, assign) int rval;  //错误返回


@end
