//
//  SRouterManager.h
//  TestRouter
//
//  Created by cs on 16/5/20.
//  Copyright © 2016年 cs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRouter.h"

@interface SRouterManager : NSObject

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

#pragma mark - 基础方法
+ (id)routerExcuteFunction:(NSString *)className function:(NSString *)funtionName;
+ (id)routerHandleCmd:(NSInteger)cmd caller:(id)caller callee:(id)callee target:(NSString *)targetClassname params:(NSDictionary *)params from:(NSInteger)from;
+ (id)routerHandleOtherCmd:(id)caller target:(NSString *)targetClassname params:(NSDictionary *)params from:(NSInteger)from;
+ (id)routerQuery:(NSInteger)cmd target:(id)object;


#pragma mark -
#pragma mark - 简便方法
+ (id)routerPushLocal:(NSString *)targetClassname caller:(id)caller;
+ (id)routerPushLocal:(NSString *)targetClassname caller:(id)caller params:(NSDictionary *)params;
+ (id)routerPresentLocal:(NSString *)targetClassname caller:(id)caller;
+ (id)routerPresentLocal:(NSString *)targetClassname caller:(id)caller params:(NSDictionary *)params;
+ (id)routerPushRemote:(NSString *)targetClassname caller:(id)caller;
+ (id)routerPushRemote:(NSString *)targetClassname caller:(id)caller params:(NSDictionary *)params;
+ (id)routerPresentRemote:(NSString *)targetClassname caller:(id)caller;
+ (id)routerPresentRemote:(NSString *)targetClassname caller:(id)caller params:(NSDictionary *)params;

+ (id)routerQueryViewController:(NSString *)targetClassname;
+ (id)routerQueryProtocol:(Protocol *)protocol;
+ (id)routerQueryBlock:(NSString *)targetClassname;

#pragma mark - 订阅相关
+ (void)routerSubscribMsg:(NSInteger)msg withTargetInst:(id)targetInst caller:(id)caller;
+ (void)routerUnSubscribMsg:(NSInteger)msg withTargetInst:(id)targetInst caller:(id)caller;
+ (void)routerNotifySubscriber:(id)caller withMsg:(NSInteger)msg withParams:(NSDictionary *)params;

#pragma mark - 注册、反注册
/**
 *  Block注册，用于回调（关键字可以随意定义，不过获取的时候要使用该关键字才能获取到）
 *  注意：注册后需要手动解除注册
 *
 *  @param block           回调block
 *  @param targetClassname 关键字
 *
 *  @return 无
 */
+ (BOOL)routerRegisterBlock:(SRouterHandler)block withKeyName:(NSString *)targetClassname;

/**
 *  同上（用实例注册，所以没有上面的灵活，在目标类中用实例获取）
 *  注意：不需要手动解除注册
 *
 *  @param block    回调block
 *  @param instance 实例
 *
 *  @return 无
 */
+ (BOOL)routerRegisterBlock:(SRouterHandler)block withInstance:(id)instance;

/**
 *  协议注册，用于回调
 *  注意：不需要手动解除注册
 *
 *  @param protocol  协议
 *  @param classInst 回调实例
 *
 *  @return 无
 */
+ (BOOL)routerRegisterProtocol:(Protocol *)protocol withInstance:(id)classInst;

/**
 *  注册服务类，提供长期生存周期
 *  注意：不用时可手动解除注册
 *
 *  @param targetClassname 要注册的类名
 *
 *  @return 实例对象
 */
+ (id)routerRegisterServiceClass:(NSString *)targetClassname;

/**
 *  注册关键字跟类名的映射（如shortNameA-A_ViewModuleController)
 *  使用时可以调用shortNameA代替完整类名
 *
 *  @param shortName      简短关键字
 *  @param targetFullname 类名
 *
 *  @return 无
 */

+ (void)routerRegisteRules:(NSString *)plistname;
+ (void)routerClearRules;
+ (void)routerUnRegisterRule:(NSString *)ruleKeyClass;

+ (BOOL)routerRegisterMapName:(NSString *)shortName target:(NSString *)targetFullname;
+ (BOOL)routerRegisterMapNameForDict:(NSDictionary *)dictMap;
+ (void)routerUnregisterBlockWithKeyname:(NSString *)targetClassname;
+ (void)routerUnregisterBlockWithInstance:(id)instance;
+ (void)routerUnregisterProtocol:(Protocol *)protocl withInstance:(id)classInst;
+ (void)routerUnregisterServiceClass:(NSString *)targetClassname;
+ (void)routerUnregisterMapName:(NSString *)fullname;
+ (void)routerUnregisterMapNameForDict:(NSDictionary *)dictMap;

@end
