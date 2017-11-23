//
//  SRouter.h
//  TestRouter
//
//  Created by cs on 16/4/19.
//  Copyright © 2016年 cs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RouterHandlerInf.h"



@interface SRouterBase : NSObject

@end

@interface SRouterLocal : SRouterBase
+ (id<RouterHandlerInf>)routerLocalShareInstance;


/**
 *  注册协议，当需要代理方式返回时调用此方法注册通信协议
 *
 *  @param classIns 需要接受数据的实例对象
 *  @param protocol 双方通信协议
 *
 *  @return YES成功
 */
- (BOOL)registerProtocol:(id)classIns forProtocol:(Protocol*)protocol;
- (void)unregisterProtocol:(id)classIns forProtocol:(Protocol *)protocol;
/**
 *  获取注册该协议的实例类
 *
 *  @param protocol 协议名
 *
 *  @return 实例类
 */
- (NSArray *)objectForProtocol:(Protocol *)protocol;
/**
 *  注册BLOCK，当需要数据返回时可调用此方法
 *
 *  @param block     BLOCK
 *  @param className 目标类名
 *
 *  @return YES成功
 */
- (BOOL)registerBlock:(SRouterHandler)block className:(NSString *)className;
- (void)unregisterBlock:(NSString *)className;
/**
 *  获取注册了的BLOCK
 *
 *  @param className 目标类名
 *
 *  @return Block
 */
- (SRouterHandler)blockForClassName:(NSString *)className;

/**
 *  远程调用时注册类名映射
 *
 *  @param shortName     简短名字
 *  @param fullClassName 完整类名
 */
- (void)registerShortName:(NSString *)shortName withFullClassName:(NSString *)fullClassName;
- (void)registerShortNameForDic:(NSDictionary *)dict;

/**
 *  注册长时间存在的单例类
 *
 *  @param className 类名
 */
- (void)registerShareInstanceClass:(NSString *)className;
- (void)unregisterShareInstanceClass:(NSString *)className;
@end
