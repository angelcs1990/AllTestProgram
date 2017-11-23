//
//  SRouterManager.m
//  TestRouter
//
//  Created by cs on 16/5/20.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "SRouterManager.h"

@implementation SRouterManager
+ (id)routerExcuteFunction:(NSString *)className function:(NSString *)funtionName
{
    id result;
    Class targetClass = NSClassFromString(className);
    if (targetClass == nil) {
        return nil;
    } else {
        SEL targetFun = NSSelectorFromString(funtionName);
_Pragma("clang diagnostic push")
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")
        result = [targetClass performSelector:targetFun];
_Pragma("clang diagnostic pop")
    }
    
    return result;
}

+ (id)_handleCommand:(RouterHandlerContext *)ctx
{
    return [[SRouterLocal shareInstance] handleCommand:ctx];

}

+ (id)routerHandleCmd:(NSInteger)cmd caller:(id)caller callee:(id)callee target:(NSString *)targetClassname params:(NSDictionary *)params from:(NSInteger)from
{
    RouterHandlerContext *context = [RouterHandlerContext new];
    context.caller = caller;
    context.cmd = cmd;
    context.callee = callee;
    context.targetClass = targetClassname;
    context.dictParam = params;
    context.from = from;

    return [self _handleCommand:context];
}

+ (id)routerHandleOtherCmd:(id)caller target:(NSString *)targetClassname params:(NSDictionary *)params from:(NSInteger)from
{
    return [self routerHandleCmd:RouterHandlerOther caller:caller callee:nil target:targetClassname params:params from:from];
}

+ (id)routerQuery:(NSInteger)cmd target:(id)object
{
    return [self routerHandleCmd:RouterHandlerQuery caller:nil callee:nil target:nil params:@{keySRouter__Param_Cmd:[NSNumber numberWithInteger:cmd], keySRouter__Param_Value:object} from:SRouterCmdFromLocal];
}



#pragma mark -
#pragma mark - 简便方法
+ (id)routerPushLocal:(NSString *)targetClassname caller:(id)caller
{
    return [self routerHandleCmd:RouterHandlerJump caller:caller callee:nil target:targetClassname params:@{keySRouter__Param_Cmd:@(SubJumpRouterHandlerPush)} from:SRouterCmdFromLocal];
}

+ (id)routerPushLocal:(NSString *)targetClassname caller:(id)caller params:(NSDictionary *)params
{
    return [self routerHandleCmd:RouterHandlerJump caller:caller callee:nil target:targetClassname params:@{keySRouter__Param_Cmd:@(SubJumpRouterHandlerPushWithParams), keySRouter__Param_Value:params} from:SRouterCmdFromLocal];
}

+ (id)routerPresentLocal:(NSString *)targetClassname caller:(id)caller
{
    return [self routerHandleCmd:RouterHandlerJump caller:caller callee:nil target:targetClassname params:@{keySRouter__Param_Cmd:@(SubJumpRouterHandlerPresent)} from:SRouterCmdFromLocal];
}

+ (id)routerPresentLocal:(NSString *)targetClassname caller:(id)caller params:(NSDictionary *)params
{
    return [self routerHandleCmd:RouterHandlerJump caller:caller callee:nil target:targetClassname params:@{keySRouter__Param_Cmd:@(SubJumpRouterHandlerPresentWithParams), keySRouter__Param_Value:params} from:SRouterCmdFromLocal];
}

+ (id)routerPushRemote:(NSString *)targetClassname caller:(id)caller
{
    return [self routerHandleCmd:RouterHandlerJump caller:caller callee:nil target:targetClassname params:@{keySRouter__Param_Cmd:@(SubJumpRouterHandlerPush)} from:SRouterCmdFromRemote];
}

+ (id)routerPushRemote:(NSString *)targetClassname caller:(id)caller params:(NSDictionary *)params
{
    return [self routerHandleCmd:RouterHandlerJump caller:caller callee:nil target:targetClassname params:@{keySRouter__Param_Cmd:@(SubJumpRouterHandlerPushWithParams), keySRouter__Param_Value:params} from:SRouterCmdFromRemote];
}

+ (id)routerPresentRemote:(NSString *)targetClassname caller:(id)caller
{
    return [self routerHandleCmd:RouterHandlerJump caller:caller callee:nil target:targetClassname params:@{keySRouter__Param_Cmd:@(SubJumpRouterHandlerPresent)} from:SRouterCmdFromRemote];
}

+ (id)routerPresentRemote:(NSString *)targetClassname caller:(id)caller params:(NSDictionary *)params
{
    return [self routerHandleCmd:RouterHandlerJump caller:caller callee:nil target:targetClassname params:@{keySRouter__Param_Cmd:@(SubJumpRouterHandlerPresentWithParams), keySRouter__Param_Value:params} from:SRouterCmdFromRemote];
}

+ (id)routerQueryViewController:(NSString *)targetClassname
{
    return [self routerQuery:SubQueryRouterHandlerViewController target:targetClassname];
}

+ (id)routerQueryProtocol:(Protocol *)protocol
{
    return [self routerQuery:SubQueryRouterHandlerProtocol target:protocol];
}

+ (id)routerQueryBlock:(NSString *)targetClassname
{
    return [self routerQuery:SubQueryRouterHandlerBlock target:targetClassname];
}

#pragma mark - 订阅相关
+ (void)routerSubscribMsg:(NSInteger)msg withTargetInst:(id)targetInst caller:(id)caller
{
    [self routerHandleCmd:RouterHandlerRegister caller:caller callee:targetInst target:nil params:@{keySRouter__Param_Cmd:@(SubRegisterRouterHandlerSubscribe), keySRouter__Param_Value:@(msg)} from:SRouterCmdFromLocal];
}

+ (void)routerUnSubscribMsg:(NSInteger)msg withTargetInst:(id)targetInst caller:(id)caller
{
    [self routerHandleCmd:RouterHandlerUnregister caller:nil callee:targetInst target:nil params:@{keySRouter__Param_Cmd:@(SubUnregisterRouterHandlerSubscribe), keySRouter__Param_Value:@{@"msg":@(msg), @"caller":caller}} from:SRouterCmdFromLocal];
}

+ (void)routerNotifySubscriber:(id)caller withMsg:(NSInteger)msg withParams:(NSDictionary *)params
{    
    [self routerHandleCmd:RouterHandlerNotifySubscriber caller:caller callee:nil target:nil params:@{keySRouter__Param_Cmd:@(msg), keySRouter__Param_Value:params} from:SRouterCmdFromLocal];
}

#pragma mark - 注册、反注册
+ (BOOL)routerRegisterBlock:(SRouterHandler)block withKeyName:(NSString *)targetClassname
{
    return [[self routerHandleCmd:RouterHandlerRegister caller:nil callee:nil target:targetClassname params:@{keySRouter__Param_Cmd:@(SubRegisterRouterHandlerBlock), keySRouter__Param_Value:@{keySRouter_RegisterCmd_Param:block}} from:SRouterCmdFromLocal] boolValue];
}

+ (BOOL)routerRegisterBlock:(SRouterHandler)block withInstance:(id)instance
{
    return [[self routerHandleCmd:RouterHandlerRegister caller:nil callee:nil target:nil params:@{keySRouter__Param_Cmd:@(SubRegisterRouterHandlerBlock), keySRouter__Param_Value:@{keySRouter_RegisterCmd_Param:block, keySRouter_RegisterCmd_Instance:instance}} from:SRouterCmdFromLocal] boolValue];
}

+ (BOOL)routerRegisterProtocol:(Protocol *)protocol withInstance:(id)classInst
{
    return [[self routerHandleCmd:RouterHandlerRegister caller:nil callee:nil target:nil params:@{keySRouter__Param_Cmd:@(SubRegisterRouterHandlerProtocol), keySRouter__Param_Value:@{keySRouter_RegisterCmd_Param:protocol, keySRouter_RegisterCmd_Instance:classInst}} from:SRouterCmdFromLocal] boolValue];
}

+ (id)routerRegisterServiceClass:(NSString *)targetClassname
{
    return [self routerHandleCmd:RouterHandlerRegister caller:nil callee:nil target:targetClassname params:@{keySRouter__Param_Cmd:@(SubRegisterRouterHandlerService)} from:SRouterCmdFromLocal];
}

+ (void)routerRegisteRules:(NSString *)plistname
{
    [self routerHandleCmd:RouterHandlerRuleFiles caller:nil callee:nil target:nil params:@{keySRouter__Param_Cmd:@(SubRuleRouterHandleAdd), keySRouter__Param_Value:plistname} from:SRouterCmdFromLocal];
}

+ (void)routerClearRules
{
    [self routerHandleCmd:RouterHandlerRuleFiles caller:nil callee:nil target:nil params:@{keySRouter__Param_Cmd:@(SubRuleRouterHandleClear)} from:SRouterCmdFromLocal];
}

+ (void)routerUnRegisterRule:(NSString *)ruleKeyClass
{
    [self routerHandleCmd:RouterHandlerRuleFiles caller:nil callee:nil target:nil params:@{keySRouter__Param_Cmd:@(SubRuleRouterHandleRemove), keySRouter__Param_Value:ruleKeyClass} from:SRouterCmdFromLocal];
}

+ (BOOL)routerRegisterMapName:(NSString *)shortName target:(NSString *)targetFullname
{
    [self routerHandleCmd:RouterHandlerRegister caller:nil callee:nil target:nil params:@{keySRouter__Param_Cmd:@(SubRegisterRouterHandlerMapname), keySRouter__Param_Value:@{keySRouter_RegisterCmd_TargeName:targetFullname, keySRouter_RegisterCmd_Param:shortName}} from:SRouterCmdFromLocal];
    return YES;
}

+ (BOOL)routerRegisterMapNameForDict:(NSDictionary *)dictMap
{
    [self routerHandleCmd:RouterHandlerRegister caller:nil callee:nil target:nil params:@{keySRouter__Param_Cmd:@(SubRegisterRouterHandlerMapname), keySRouter__Param_Value:@{keySRouter_RegisterCmd_Param:dictMap}} from:SRouterCmdFromLocal];
    
    return YES;
}

+ (void)routerUnregisterBlockWithInstance:(id)instance
{
    [self routerHandleCmd:RouterHandlerUnregister caller:nil callee:nil target:nil params:@{keySRouter__Param_Cmd:@(SubUnregisterRouterHandlerBlock), keySRouter__Param_Value:@{keySRouter_RegisterCmd_Instance:instance}} from:SRouterCmdFromLocal];
}

+ (void)routerUnregisterBlockWithKeyname:(NSString *)targetClassname
{
    [self routerHandleCmd:RouterHandlerUnregister caller:nil callee:nil target:targetClassname params:@{keySRouter__Param_Cmd:@(SubUnregisterRouterHandlerBlock)} from:SRouterCmdFromLocal];
}

+ (void)routerUnregisterProtocol:(Protocol *)protocl withInstance:(id)classInst
{
    [self routerHandleCmd:RouterHandlerUnregister caller:nil callee:nil target:nil params:@{keySRouter__Param_Cmd:@(SubUnregisterRouterHandlerProtocol), keySRouter__Param_Value:@{keySRouter_RegisterCmd_Param:protocl, keySRouter_RegisterCmd_Instance:classInst}} from:SRouterCmdFromLocal];
}

+ (void)routerUnregisterServiceClass:(NSString *)targetClassname
{
    [self routerHandleCmd:RouterHandlerUnregister caller:nil callee:nil target:targetClassname params:@{keySRouter__Param_Cmd:@(SubUnregisterRouterHandlerService)} from:SRouterCmdFromLocal];
}

+ (void)routerUnregisterMapName:(NSString *)fullname
{
    [self routerHandleCmd:RouterHandlerUnregister caller:nil callee:nil target:nil params:@{keySRouter__Param_Cmd:@(SubUnregisterRouterHandlerMapname), keySRouter__Param_Value:@{keySRouter_RegisterCmd_Param:fullname}} from:SRouterCmdFromLocal];
}

+ (void)routerUnregisterMapNameForDict:(NSDictionary *)dictMap
{
    [self routerHandleCmd:RouterHandlerUnregister caller:nil callee:nil target:nil params:@{keySRouter__Param_Cmd:@(SubUnregisterRouterHandlerMapname), keySRouter__Param_Value:@{keySRouter_RegisterCmd_Param:dictMap}} from:SRouterCmdFromLocal];
}

@end
