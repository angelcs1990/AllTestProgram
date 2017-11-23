//
//  SRouterManager.h
//  TestRouter
//
//  Created by cs on 16/5/20.
//  Copyright © 2016年 chensi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRouter.h"

@interface SRouterManager : NSObject
+ (instancetype)shareInstance;
#pragma mark - 基础方法
+ (id)routerExcuteFunction:(NSString *)className function:(NSString *)funtionName;
+ (id)routerHandleCmd:(NSInteger)cmd caller:(id)caller target:(NSString *)targetClassname params:(NSDictionary *)params from:(NSInteger)from;

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

#pragma mark - 注册、反注册
+ (BOOL)routerRegister:(NSString *)targetClassname block:(SRouterHandler)block;
+ (BOOL)routerRegister:(id)classInst protocol:(Protocol *)protocol;
+ (BOOL)routerRegisterServiceClass:(NSString *)targetClassname;
+ (BOOL)routerRegisterMapName:(NSString *)shortName target:(NSString *)targetFullname;
+ (BOOL)routerRegisterMapNameForDict:(NSDictionary *)dictMap;

+ (void)routerUnregisterBlock:(NSString *)targetClassname;
+ (void)routerUnregisterProtocl:(id)classInst protocl:(Protocol *)protocl;
+ (void)routerUnregisterServiceClass:(NSString *)targetClassname;
+ (void)routerUnregisterMapName:(NSString *)fullname;
+ (void)routerUnregisterMapNameForDict:(NSDictionary *)dictMap;
@end
