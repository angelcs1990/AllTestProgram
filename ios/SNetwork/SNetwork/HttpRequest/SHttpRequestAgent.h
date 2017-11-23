//
//  SRequestAgent.h
//  SNetworkDemo
//
//  Created by cs on 16/5/12.
//  Copyright © 2016年 cs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHttpBaseRequest.h"
#import "SHttpCoreNetwork.h"

@interface SHttpRequestAgent : NSObject
@property (nonatomic, strong) id<SHttpNetworkProtocol> network;

+ (instancetype)shareInstance;

- (void)addRequest:(SHttpBaseRequest *)request;
- (void)cancelRequest:(SHttpBaseRequest *)request;
- (void)cancelAllRequests;

- (id)queryValue:(int)type andRequest:(SHttpBaseRequest *)request;
@end


