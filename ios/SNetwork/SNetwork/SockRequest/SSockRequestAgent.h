//
//  SSockRequestAgent.h
//  SNetworkDemo
//
//  Created by cs on 16/5/26.
//  Copyright © 2016年 cs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSockBaseRequest.h"
#import "SSockNetworkProtocol.h"
#import "MacroDef.h"


////收到数据
typedef void(^SSockRequestBlockRecv)(id responseData);
////数据处理进度
//typedef void(^SSockRequestBlockProgress)(id object);
////连接断开
typedef void(^SSockRequestBlockDisconnect)(NSError *);
////连接ok
typedef void(^SSockRequestBlockConnect)();

@protocol SSockRequestDelegate <NSObject>

- (void)sockRequestDidConnect;
- (void)sockRequestDidDisconnectWithError:(NSError *)err;
- (void)sockRequestDidRecvData:(id)data;

@end

//分发消息可以到block中，也可以定义network的delegate＝需要实现分发消息的类中去


@interface SSockRequestAgent : NSObject<SSockRequestDelegate>
@property (nonatomic, strong) id<SSockNetworkProtocol> network;

@property (nonatomic, copy) SSockRequestBlockConnect blockConnect;
@property (nonatomic, copy) SSockRequestBlockDisconnect blockDisconnect;
@property (nonatomic, copy) SSockRequestBlockRecv blockDataRecv;

+ (instancetype)shareInstance;

/**
 *  消息类型跟实例地址的映射（注册，反注册相关api）
 *
 *  @param msgType 消息类型
 *  @param request 请求实例地址
 */
- (void)registerMessagType:(NSInteger)msgType sockRequest:(SSockBaseRequest *)request;
- (NSArray<SSockBaseRequest *> *)queryRequestInstancesForMessageType:(NSInteger)msgType;
- (void)unregisterMessageType:(NSInteger)msgType sockRequest:(SSockBaseRequest *)request;
- (void)unregisterMessageType:(NSInteger)msgType;

- (void)addRequest:(SSockBaseRequest *)request;
- (void)cancelRequest:(SSockBaseRequest *)request;

/**
 *  断开所有连接
 */
- (void)disconnectAll;
- (void)disconnectRequest:(SSockBaseRequest *)request;
@end
