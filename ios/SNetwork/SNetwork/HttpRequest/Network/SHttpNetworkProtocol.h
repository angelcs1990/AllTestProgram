//
//  SNetworkProtocol.h
//  SNetworkDemo
//
//  Created by cs on 16/5/16.
//  Copyright © 2016年 cs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHttpBaseRequest.h"
#import "AFNetworking.h"
#import "SNetworkConfig.h"

@protocol SHttpNetworkProtocol <NSObject>
@required
- (void)sendRequest:(SHttpBaseRequest *)request;
- (void)cancelRequest:(SHttpBaseRequest *)request;
- (void)cancelAllRequests;
- (id)queryValue:(int)type andRequest:(SHttpBaseRequest *)request;
@end



/**
 *  网络基类
 */
@interface SHttpCoreNetwork : NSObject<SHttpNetworkProtocol>
@property (nonatomic, strong) SNetworkConfig *config;
@end


@protocol SNetworkExtraConfigDelegate <NSObject>

- (void)networkExtraConfig:(id)object;

@end

