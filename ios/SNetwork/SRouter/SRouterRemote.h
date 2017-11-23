//
//  SRouterRemote.h
//  TestRouter
//
//  Created by cs on 16/4/21.
//  Copyright © 2016年 cs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RouterHandlerInf.h"

@class SRouterRemote;
@protocol SRouterRemoteDelegate <NSObject>
@optional
/**
 *  可以做一些安全检测
 *
 *  @param srr    实例类
 *  @param scheme scheme名
 *  @param path   url路径
 *  @param dict   参数
 *
 *  @return NO终止页面调用 YES允许页面调用
 */
- (BOOL)routerRemote:(SRouterRemote *)srr withScheme:(NSString *)scheme withPath:(NSString *)path withParams:(NSDictionary *)dict;
@end


@interface SRouterRemote : NSObject

@property (nonatomic, weak) id<SRouterRemoteDelegate> delegate;


+ (instancetype)routerRemoteShareInstance;
/**
 *  远程调用接口
 *
 *  @param url        远程调用的url地址
 *  @param completion 返回值传递block
 *
 *  @return YES or NO
 */
- (BOOL)handlerCommandWithURL:(NSURL *)url completion:(void (^)(NSDictionary *))completion;
@end
