//
//  SSockRequestAgent.m
//  SNetworkDemo
//
//  Created by cs on 16/5/26.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "SSockRequestAgent.h"
#import "SSockCoreNetwork.h"



@interface SSockRequestAgent()
//@property (nonatomic, copy, readwrite) SSockRequestBlockConnect blockConnect;
//@property (nonatomic, copy, readwrite) SSockRequestBlockDisconnect blockDisconnect;
//@property (nonatomic, copy, readwrite) SSockRequestBlockRecv blockDataRecv;
@property (nonatomic, copy) NSMutableDictionary *dictCacheMap;
@end
@implementation SSockRequestAgent
+ (instancetype)shareInstance
{
    static SSockRequestAgent *agent;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        agent = [SSockRequestAgent new];
    });
    
    return agent;
}

#pragma mark - lifecycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupBlock];
    }
    
    return self;
}


- (void)setupBlock
{
//    _blockConnect = ^{
//        S_LOG(@"连接ok");
//    };
//    _blockDisconnect = ^(NSError *err){
//        S_LOG(@"断开连接了");
//    };
//    _blockDataRecv = ^(id response){
//        S_LOG(response);
//    };
}


#pragma mark - public method
- (void)registerMessagType:(NSInteger)msgType sockRequest:(SSockBaseRequest *)request
{
    if ([self.dictCacheMap objectForKey:@(msgType)] == nil) {
        NSMutableSet *instSet = [NSMutableSet set];
        [instSet addObject:request];
        [self.dictCacheMap setObject:instSet forKey:@(msgType)];
    } else {
        [[self.dictCacheMap objectForKey:@(msgType)] addObject:request];
    }
}

- (NSArray<SSockBaseRequest *> *)queryRequestInstancesForMessageType:(NSInteger)msgType
{
    return [[self.dictCacheMap objectForKey:@(msgType)] allObjects];
}
- (void)unregisterMessageType:(NSInteger)msgType sockRequest:(SSockBaseRequest *)request
{
    [[self.dictCacheMap objectForKey:@(msgType)] removeObject:request];
    if ([[self.dictCacheMap objectForKey:@(msgType)] count] == 0) {
        [self.dictCacheMap removeObjectForKey:@(msgType)];
    }
}
- (void)unregisterMessageType:(NSInteger)msgType
{
    [self.dictCacheMap removeObjectForKey:@(msgType)];
}


- (void)addRequest:(SSockBaseRequest *)request
{
    if ([self.network respondsToSelector:@selector(sendRequest:)]) {
        [self.network sendRequest:request];
    }
}
- (void)cancelRequest:(SSockBaseRequest *)request
{
    if ([self.network respondsToSelector:@selector(cancelRequest:)]) {
        [self.network cancelRequest:request];
    }
}
- (void)disconnectRequest:(SSockBaseRequest *)request
{
    if ([self.network respondsToSelector:@selector(disconnectRequest:)]) {
        [self.network disconnectRequest:request];
    }
}

- (void)disconnectAll
{
    if ([self.network respondsToSelector:@selector(disconnectAll)]) {
        [self.network disconnectAll];
    }
}
#pragma mark - SSockRequestDelegate
- (void)sockRequestDidDisconnectWithError:(NSError *)err
{
    //    _blockDisconnect(nil);
    S_LOG(@"断开连接了");
    if (self.blockDisconnect) {
        self.blockDisconnect(err);
    }
}
- (void)sockRequestDidConnect
{
    //    _blockConnect();
    S_LOG(@"连接ok");
    if (self.blockConnect) {
        self.blockConnect();
    }
}
- (void)sockRequestDidRecvData:(id)data
{
//    S_LOG(data);
    if (self.blockDataRecv) {
        self.blockDataRecv(data);
    }
    
    NSDictionary *dict = (NSDictionary *)data;
    NSInteger type = [dict[@"type"] integerValue];
    NSArray<SSockBaseRequest *> *request = [self queryRequestInstancesForMessageType:type];
    [request enumerateObjectsUsingBlock:^(SSockBaseRequest * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.responseDataBlock) {
            obj.responseDataBlock(data);
        }
    }];
}
#pragma mark - setter and getter
- (id<SSockNetworkProtocol>)network
{
    if (_network == nil) {
        _network = [SSockCoreNetwork new];
        ((SSockCoreNetwork *)_network).responseDelegate = self;
    }
    
    return _network;
}
- (NSMutableDictionary *)dictCacheMap
{
    if (_dictCacheMap == nil) {
        _dictCacheMap = [NSMutableDictionary dictionary];
    }
    
    return _dictCacheMap;
}
@end
