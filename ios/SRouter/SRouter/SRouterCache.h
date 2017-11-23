//
//  SRouterContext.h
//  TestRouter
//
//  Created by cs on 16/12/5.
//  Copyright © 2016年 chensi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRouterHandlerProtocol.h"

/**
 *  上下文数据
 */
@interface SRouterCache : NSObject

+ (instancetype)routerCache;

- (void)registerShortName:(NSString *)name withFullClassName:(NSString *)fullClassName;
- (void)registerShortNameForDict:(NSDictionary *)dict;
- (void)unregisterShortName:(NSString *)name;
- (NSString *)queryClassName:(NSString *)keyClassName;
- (id)queryClassImpForProtocol:(Protocol *)keyProtocol;

- (BOOL)registerProtocol:(Protocol *)keyProtocol classInstance:(id)classIns;
- (void)unregisterProtocol:(Protocol *)keyProtocol classInstance:(id)classIns;

- (BOOL)registerBlock:(SRouterHandler)block keyName:(NSString *)className;
- (void)unregisterBlockWithKeyname:(NSString *)className;
- (SRouterHandler)queryBlockWithKeyName:(NSString *)className;

- (id)registerService:(NSString *)className;
- (void)unregisterService:(NSString *)className;
- (id)serviceForClassName:(NSString *)className;
//- (void)registerTempService:(id)service;
//- (void)unregisterTempService:(id)service;
//- (id)tmpServiceFor

- (BOOL)registerBlock:(SRouterHandler)block withInstance:(id)instance;
- (void)unregisterBlockWithInstance:(id)instance;


- (void)unregisterSubscriberInstance:(id)sberInst withDestObj:(id)destInst withMsg:(NSInteger)msg;
- (NSArray *)subscriberObjects:(id)destInst withMsg:(NSInteger)msg;
- (void)registerSubscriberInstance:(id)sberInst withDestObj:(id)destInst withMsg:(NSInteger)msg;
- (SRouterHandler)queryBlockWithInstance:(id)instance;

/**
 *  添加plist文件中的内容
 *  可配合验证是类名是否调用正确
 *
 *  @param rules      rule数组
 *
 */
- (void)addRules:(NSArray<RouterRulesContext *> *)rules;
- (void)clearRules;
- (void)removeRule:(NSString *)key;
- (RouterRulesContext *)queryRuleForName:(NSString *)name;
@end
