//
//  FFSocket.m
//  Socket_for_Camera
//
//  Created by lsq on 2017/5/20.
//  Copyright © 2017年 detu. All rights reserved.
//

#import "FFSocket.h"
#import "FFSDK.h"
#import "MJExtension.h"

#define SOCKET_TIMEOUT                              5               //socket连接超时时间

@interface FFSocket()

@property (strong, nonatomic) dispatch_queue_t socketQueue;         // 发数据的串行队列
@property (strong, nonatomic) dispatch_queue_t receiveQueue;        // 收数据处理的串行队列

@end

@implementation FFSocket

+ (instancetype)shareInstance {
    static FFSocket * obj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[FFSocket alloc] init];
    });
    return obj;
}

- (dispatch_queue_t)socketQueue {
    if (_socketQueue == nil) {
        _socketQueue = dispatch_queue_create("com.sendSocket", DISPATCH_QUEUE_SERIAL);
    }
    return _socketQueue;
}

- (dispatch_queue_t)receiveQueue {
    if (_receiveQueue == nil) {
        _receiveQueue = dispatch_queue_create("com.receiveSocket", DISPATCH_QUEUE_SERIAL);
    }
    return _receiveQueue;
}


#pragma mark -建立接收数据sorcket连接
- (BOOL )connectSocketWithHost:(NSString *)host onPort:(uint16_t)port {
    NSError *error;
    self.FFSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    // connected to server port
    BOOL abool = [self.FFSocket connectToHost:host onPort:port withTimeout:SOCKET_TIMEOUT error:&error];
    if (!abool) {
        FFlus_SDK_Log(@"socket,connect to server fail! %@",error);
        return abool;
    }
    
    return abool;
}

#pragma mark - 关闭socket
- (void)disConnect {
    // close socket
    [self.FFSocket setDelegate:nil delegateQueue:NULL];
    [self.FFSocket disconnect];
    self.FFSocket = nil;
    self.receiveQueue = nil;
    self.socketQueue = nil;
}

#pragma mark -发送消息
- (void)send:(NSDictionary *)data {
    dispatch_async(self.socketQueue, ^{
        int tag = [[data objectForKey:@"msgid"] intValue];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
        [self.FFSocket writeData:jsonData withTimeout:-1 tag:tag];
    });
}

#pragma mark - 开启接收数据
- (void)beginReadDataTimeOut:(long)timeOut tag:(long)tag {
    if (tag == MSGID_START_SESSION) {
        // 未定义结束符
        [self.FFSocket readDataWithTimeout:-1 tag:0];
    }else{
        [self.FFSocket readDataToData:[GCDAsyncSocket LFData] withTimeout:timeOut maxLength:0 tag:tag];
    }
}

#pragma mark GCDAsyncSocketDelegate
#pragma mark - 连接成功
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    dispatch_async(self.receiveQueue, ^{
        FFlus_SDK_Log(@"socket connect to server success");
        [self.FFSocket readDataWithTimeout:-1 tag:0];
        if ([self.FFSocketDelegate respondsToSelector:@selector(socketDidConnect:onPort:)]) {
            [self.FFSocketDelegate socketDidConnect:sock.localHost onPort:sock.localPort];
        }
    });
}


#pragma mark - 连接失败
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    dispatch_async(self.receiveQueue, ^{
        FFlus_SDK_Log(@"socket,connect to server fail!");
        FFlus_SDK_Log(@"socket error:%@",err);
        dispatch_async(self.receiveQueue, ^{
            if ([self.FFSocketDelegate respondsToSelector:@selector(socketDisConnect:)]) {
                [self.FFSocketDelegate socketDisConnect:err];
            }
        });
    });
}
#pragma mark - 写入数据成功 , 重新开启允许读取数据
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    dispatch_async(self.receiveQueue, ^{
        [self beginReadDataTimeOut:-1 tag:tag];
    });
}

#pragma mark - 接收到消息
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    dispatch_async(self.receiveQueue, ^{
        // 拆包处理
        [self unpacking:data];
    });
}

#pragma mark - 拆包处理
- (void)unpacking:(NSData *)data{
    
    int left = 0;
    int rigth = 0;
    int cut = 0;
    NSData *packet = nil;
    Byte *allByte = (Byte *)[data bytes];
    
    if(allByte == nil){
        return;
    }
    
    for (int i = 0; i < [data length]; i++){
        if ([[NSString stringWithFormat:@"%c",allByte[i]] isEqualToString:@"{"]) {
            left++;
        }else if ([[NSString stringWithFormat:@"%c",allByte[i]] isEqualToString:@"}"]){
            rigth++;
        }
        // 这是个完整的包
        int cutLength = i + 1 - cut;
        if ((left == rigth) && (left > 0) && (rigth > 0)) {
            packet = [data subdataWithRange:NSMakeRange(cut, cutLength)];
            [self handleData:packet];
            left = 0;
            rigth = 0;
            cut = i + 1;
        }
    }
}

#pragma mark - 数据处理
- (void)handleData:(NSData *)packet{
    // 转为明文消息
    NSString *secretStr  = [[NSString alloc] initWithData:packet encoding:NSUTF8StringEncoding];
    // 去掉首尾的换行以及空格符
    secretStr = [secretStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    // 去除'\n'
    secretStr            = [secretStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    FFMessageModel *messageModel = [FFMessageModel mj_objectWithKeyValues:secretStr];
    FFlus_SDK_Log(@"socket 读取数据:%@",secretStr);
    if ([self.FFSocketDelegate respondsToSelector:@selector(didReceiveMessage:)]) {
        [self.FFSocketDelegate didReceiveMessage:messageModel];
    }
    [self.FFSocket readDataWithTimeout:-1 tag:0];

}

@end
