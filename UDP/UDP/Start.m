//
//  Start.m
//  UDP
//
//  Created by 刘明 on 16/8/17.
//  Copyright © 2016年 LM. All rights reserved.
//

#import "Start.h"
#import "GCDAsyncUdpSocket.h"

@interface Start ()<GCDAsyncUdpSocketDelegate>

@property(nonatomic,strong)GCDAsyncUdpSocket * udpSocket;
@property(nonatomic,strong)dispatch_source_t timer;

@end

@implementation Start
-(void)start{
    

  GCDAsyncUdpSocket* udpSocket=  [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    self.udpSocket =udpSocket;
    NSError *error = nil;
    if(![self.udpSocket bindToPort :8022 error:&error])
    {
        NSLog(@"error in bindToPort");
        //return;
    }
    //    [self.udpSocket enableBroadcast:YES error:&error];
    //    if(error)
    //    {
    //        NSLog(@"error in enableBroadcast");
    //        //return;
    //    }
    //    [self.udpSocket joinMulticastGroup:@"224.0.0.1" error:&error];
    //
    //    if (nil != error) {
    //
    //        NSLog(@"error in joinMulticastGroup");
    //
    //    }
    //只接受一次数据
    //    [self.udpSocket receiveOnce:&error];
    //无限接收
    [self.udpSocket beginReceiving:&error];
    if(error)
    {
        NSLog(@"error in beginReceiving");
        //return;
    }
        [self startSendMsg];
}
-(void)startSendMsg{
    
    //    {
    //        U1    start[4]={0xf5,0x5f,0x??,0};
    //        uint64_t timestamp;
    //        data;
    //    }
    NSString* str = @"11";
    NSData* sendData = [str dataUsingEncoding:NSUTF8StringEncoding];
    __block int cu = 10;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //        dispatch_source_set_timer(timer, dispatch_walltime(nil, 15), 0.2 * NSEC_PER_SEC, 0);
    dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, 0), 2*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^
                                      {
                                          if (cu) {
                                              [self.udpSocket sendData:sendData toHost:@"192.168.1.1" port:8022 withTimeout:-1 tag:0];
                                          }else{
                                              dispatch_source_cancel(_timer);
                                          }
                                          //                                              cu--;
                                      });
    dispatch_resume(_timer);
}
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
    NSLog(@"发送成功");
}

/**
 *  发送失败
 */
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error{
    NSLog(@"发送失败");
}

/**
 *  接收到数据
 */
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext{
    NSLog(@"%@",data);
    //    NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    //    NSString* str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    //    NSLog(@"`````````````%@",str);
}
/**
 *  链接关闭
 */
- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error{
    NSLog(@"链接关闭");
}
@end
