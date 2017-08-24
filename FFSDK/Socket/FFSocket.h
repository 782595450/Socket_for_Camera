//
//  FFSocket.h
//  Socket_for_Camera
//
//  Created by lsq on 2017/5/20.
//  Copyright © 2017年 detu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
#import "FFMessageModel.h"

@protocol  FFSocketDelegate <NSObject>

@optional
/** 端口连接成功 */
-(void)socketDidConnect:(NSString *)connectHost onPort:(int)port;
/** 端口连接失败,超时 */
-(void)socketDisConnect:(NSError *)error;
/** 接收消息代理 */
- (void)didReceiveMessage:(FFMessageModel *)messageModel;

@end

@interface FFSocket : NSObject <GCDAsyncSocketDelegate>

@property (nonatomic, strong) GCDAsyncSocket                *FFSocket;
@property (nonatomic, weak) id<FFSocketDelegate>           FFSocketDelegate;

+ (instancetype)shareInstance;
- (BOOL)connectSocketWithHost:(NSString *)host onPort:(uint16_t)port ;
- (void)disConnect ;
- (void)send:(NSDictionary *)data ;

@end
