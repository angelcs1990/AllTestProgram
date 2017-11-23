//
//  SSockBaseRequest.m
//  SNetworkDemo
//
//  Created by cs on 16/5/24.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "SSockBaseRequest.h"
#import "SRouter.h"
#import "SSockRequestAgent.h"

@interface SSockBaseRequest ()

//@property (nonatomic, copy, readwrite) SSockRequestBlockRecv blockRecv;
//@property (nonatomic, copy, readwrite) SSockRequestBlockProgress blockProgress;
//@property (nonatomic, copy, readwrite) SSockRequestBlockConnect blockConnectSuccess;
//@property (nonatomic, copy, readwrite) SSockRequestBlockDisconnect blockDisconnect;
@property (nonatomic, weak, readwrite) SNetworkConfig *networkConfig;

@end

@implementation SSockBaseRequest
{
    NSTimeInterval _cacheTimeoutStop;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupBlock];
        
//        //注册消息对应的返回
//        [[SSockRequestAgent shareInstance] registerMessagType:[self requestMsgType] sockRequest:self];
    }
    
    return self;
}

- (void)dealloc
{
    NSLog(@"SSockBaseRequest dealloc");
    
    //取消消息注册
    [[SSockRequestAgent shareInstance] unregisterMessageType:[self requestMsgType] sockRequest:self];
}

- (void)setupBlock
{
//    @SROUTER_WeakSelf(self);
//    _blockRecv = ^(id responseData){
//        @SROUTER_strongSelf(self);
//        NSLog(@"%@ 收到的数据:%@", self, responseData);
//    };
}
- (id)requestParams
{
    return nil;
}
//- (NSString *)requestUrl
//{
//    return nil;
//}
- (NSString *)requestServerIP
{
    return self.networkConfig.baseUrl;
}
- (NSString *)requestClassName
{
    NSString *t = NSStringFromClass([self class]);
    return t;
}
- (NSInteger)requestPort
{
    return self.networkConfig.port;
}

//- (NSTimeInterval)requestTimeoutInterval
//{
//    return 0;
//}

- (NSTimeInterval)requestCacheTimeout
{
    return 0;
}
- (NSString *)requestDownloadPath
{
    return nil;
}

- (NSInteger)requestDataType
{
    return 0;
}

- (void)start
{
    if ([self isCacheExpired]) {
        //注册消息对应的返回
        [[SSockRequestAgent shareInstance] registerMessagType:[self requestMsgType] sockRequest:self];
        [[SSockRequestAgent shareInstance] addRequest:self];
    }
}
- (void)startWithCompletionHandler:(SSockResponseData)block withoutCache:(BOOL)cache
{
    self.responseDataBlock = block;
    if (cache) {
        [self startWithoutCache];
    } else {
        [self start];
    }
}
- (void)startWithoutCache
{
    [[SSockRequestAgent shareInstance] addRequest:self];
}
- (void)stop
{
    //取消消息注册
    [[SSockRequestAgent shareInstance] unregisterMessageType:[self requestMsgType] sockRequest:self];
    [[SSockRequestAgent shareInstance] cancelRequest:self];
}
- (void)disconnect
{
    [[SSockRequestAgent shareInstance] disconnectRequest:self];
}
- (void)disconnectAll
{
    [[SSockRequestAgent shareInstance] disconnectAll];
}
#pragma mark - private method
- (BOOL)isCacheExpired
{
    if (_cacheTimeoutStop <= 0 && [self requestCacheTimeout] > 0) {
        _cacheTimeoutStop = [self requestCacheTimeout] + [NSDate timeIntervalSinceReferenceDate];
    }
    
    if (_cacheTimeoutStop - [NSDate timeIntervalSinceReferenceDate] > 0) {
        return NO;
    }
    
    [self resetCacheTimeout];
    return YES;

}
- (void)resetCacheTimeout
{
    _cacheTimeoutStop = 0;
}
#pragma mark - setter and getter
- (SNetworkConfig *)networkConfig
{
    if (_networkConfig == nil) {
        _networkConfig = [SNetworkConfig shareInstance];
        
        
    }
    
    return _networkConfig;
}
@end
