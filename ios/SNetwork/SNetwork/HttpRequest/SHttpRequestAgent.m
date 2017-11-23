//
//  SRequestAgent.m
//  SNetworkDemo
//
//  Created by cs on 16/5/12.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "SHttpRequestAgent.h"
#import "SHttpCoreNetwork.h"
@implementation SHttpRequestAgent
+ (instancetype)shareInstance
{
    static SHttpRequestAgent *agent;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        agent = [SHttpRequestAgent new];
        //网络库可以替换掉，只要实现网络协议
        agent.network = [SHttpNetwork shareInstance];
    });
    
    return agent;
}

- (void)addRequest:(SHttpBaseRequest *)request
{
    if ([self.network respondsToSelector:@selector(sendRequest:)]) {
        [self.network sendRequest:request];
//        [self.network cancelAllRequests];
    }
}
- (void)cancelRequest:(SHttpBaseRequest *)request
{
    if ([self.network respondsToSelector:@selector(cancelRequest:)]) {
        [self.network cancelRequest:request];
    }
}
- (void)cancelAllRequests
{
    if ([self.network respondsToSelector:@selector(cancelAllRequests)]) {
        [self.network cancelAllRequests];
    }
}

- (id)queryValue:(int)type andRequest:(SHttpBaseRequest *)request;
{
    if ([self.network respondsToSelector:@selector(queryValue:andRequest:)]) {
        return [self.network queryValue:0 andRequest:request];
    }
    
    return nil;
}

@end
