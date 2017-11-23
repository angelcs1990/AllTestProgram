//
//  SRouterManager.m
//  TestRouter
//
//  Created by cs on 16/5/20.
//  Copyright © 2016年 chensi. All rights reserved.
//

#import "SRouterManager.h"


@implementation SRouterManager
+ (instancetype)shareInstance
{
    static SRouterManager *mgr;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mgr = [SRouterManager new];
    });
    
    return mgr;
}

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
    return [[SRouterLocal routerLocalShareInstance] handlerCommand:ctx];

}
+ (id)routerHandleCmd:(NSInteger)cmd caller:(id)caller target:(NSString *)targetClassname params:(NSDictionary *)params from:(NSInteger)from
{
    RouterHandlerContext *context = [RouterHandlerContext new];
    context.caller = caller;
    context.cmd = cmd;
    context.targetClass = targetClassname;
    context.dictParam = params;
    context.from = from;

    return [self _handleCommand:context];
}

+ (id)routerHandleOtherCmd:(id)caller target:(NSString *)targetClassname params:(NSDictionary *)params from:(NSInteger)from
{
    return [self routerHandleCmd:RouterHandlerOther caller:caller target:targetClassname params:params from:from];
}
+ (id)routerQuery:(NSInteger)cmd target:(id)object
{
    return [self routerHandleCmd:RouterHandlerQuery caller:nil target:nil params:@{keySRouter__Param_Cmd:[NSNumber numberWithInteger:cmd], keySRouter__Param_Value:object} from:SRouterCmdFromLocal];
}


#define SROUTER_PARAM_PACK_NUM(_n) [NSNumber numberWithInteger:_n]
#pragma mark -
#pragma mark - 简便方法
+ (id)routerPushLocal:(NSString *)targetClassname caller:(id)caller
{
    return [self routerHandleCmd:RouterHandlerJump caller:caller target:targetClassname params:@{keySRouter__Param_Cmd:[NSNumber numberWithInteger:RouterHandlerJumpPush]} from:SRouterCmdFromLocal];
}
+ (id)routerPushLocal:(NSString *)targetClassname caller:(id)caller params:(NSDictionary *)params
{
    return [self routerHandleCmd:RouterHandlerJump caller:caller target:targetClassname params:@{keySRouter__Param_Cmd:[NSNumber numberWithInteger:RouterHandlerJumpPushWithParams], keySRouter__Param_Value:params} from:SRouterCmdFromLocal];
}
+ (id)routerPresentLocal:(NSString *)targetClassname caller:(id)caller
{
    return [self routerHandleCmd:RouterHandlerJump caller:caller target:targetClassname params:@{keySRouter__Param_Cmd:SROUTER_PARAM_PACK_NUM(RouterHandlerJumpPresent)} from:SRouterCmdFromLocal];
}
+ (id)routerPresentLocal:(NSString *)targetClassname caller:(id)caller params:(NSDictionary *)params
{
    return [self routerHandleCmd:RouterHandlerJump caller:caller target:targetClassname params:@{keySRouter__Param_Cmd:SROUTER_PARAM_PACK_NUM(RouterHandlerJumpPresentWithParams), keySRouter__Param_Value:params} from:SRouterCmdFromLocal];
}
+ (id)routerPushRemote:(NSString *)targetClassname caller:(id)caller
{
    return [self routerHandleCmd:RouterHandlerJump caller:caller target:targetClassname params:@{keySRouter__Param_Cmd:[NSNumber numberWithInteger:RouterHandlerJumpPush]} from:SRouterCmdFromRemote];
}
+ (id)routerPushRemote:(NSString *)targetClassname caller:(id)caller params:(NSDictionary *)params
{
    return [self routerHandleCmd:RouterHandlerJump caller:caller target:targetClassname params:@{keySRouter__Param_Cmd:[NSNumber numberWithInteger:RouterHandlerJumpPushWithParams], keySRouter__Param_Value:params} from:SRouterCmdFromRemote];
}
+ (id)routerPresentRemote:(NSString *)targetClassname caller:(id)caller
{
    return [self routerHandleCmd:RouterHandlerJump caller:caller target:targetClassname params:@{keySRouter__Param_Cmd:SROUTER_PARAM_PACK_NUM(RouterHandlerJumpPresent)} from:SRouterCmdFromRemote];
}
+ (id)routerPresentRemote:(NSString *)targetClassname caller:(id)caller params:(NSDictionary *)params
{
    return [self routerHandleCmd:RouterHandlerJump caller:caller target:targetClassname params:@{keySRouter__Param_Cmd:SROUTER_PARAM_PACK_NUM(RouterHandlerJumpPresentWithParams), keySRouter__Param_Value:params} from:SRouterCmdFromRemote];
}

+ (id)routerQueryViewController:(NSString *)targetClassname
{
    return [self routerQuery:RouterHandlerQueryViewController target:targetClassname];
}
+ (id)routerQueryProtocol:(Protocol *)protocol
{
    return [self routerQuery:RouterHandlerQueryProtocol target:protocol];
}
+ (id)routerQueryBlock:(NSString *)targetClassname
{
    return [self routerQuery:RouterHandlerQueryBlock target:targetClassname];
}


#pragma mark - 注册、反注册
+ (BOOL)routerRegister:(NSString *)targetClassname block:(SRouterHandler)block
{
    return [self routerHandleCmd:RouterHandlerRegister caller:nil target:targetClassname params:@{keySRouter__Param_Cmd:SROUTER_PARAM_PACK_NUM(RouterHandlerRegisterBlock), keySRouter__Param_Value:@{keySRouter_RegisterCmd_Param:block}} from:SRouterCmdFromLocal];
}
+ (BOOL)routerRegister:(id)classInst protocol:(Protocol *)protocol
{
    return [self routerHandleCmd:RouterHandlerRegister caller:nil target:nil params:@{keySRouter__Param_Cmd:SROUTER_PARAM_PACK_NUM(RouterHandlerRegisterProtocol), keySRouter__Param_Value:@{keySRouter_RegisterCmd_Param:protocol, keySRouter_RegisterCmd_Instance:classInst}} from:SRouterCmdFromLocal];
}

+ (BOOL)routerRegisterServiceClass:(NSString *)targetClassname
{
    [self routerHandleCmd:RouterHandlerRegister caller:nil target:targetClassname params:@{keySRouter__Param_Cmd:SROUTER_PARAM_PACK_NUM(RouterHandlerRegisterService)} from:SRouterCmdFromLocal];
    return YES;
}
+ (BOOL)routerRegisterMapName:(NSString *)shortName target:(NSString *)targetFullname
{
    [self routerHandleCmd:RouterHandlerRegister caller:nil target:nil params:@{keySRouter__Param_Cmd:SROUTER_PARAM_PACK_NUM(RouterHandlerRegisterMapname), keySRouter__Param_Value:@{keySRouter_RegisterCmd_TargeName:targetFullname, keySRouter_RegisterCmd_Param:shortName}} from:SRouterCmdFromLocal];
    return YES;
}
+ (BOOL)routerRegisterMapNameForDict:(NSDictionary *)dictMap
{
    [self routerHandleCmd:RouterHandlerRegister caller:nil target:nil params:@{keySRouter__Param_Cmd:SROUTER_PARAM_PACK_NUM(RouterHandlerRegisterMapname), keySRouter__Param_Value:@{keySRouter_RegisterCmd_Param:dictMap}} from:SRouterCmdFromLocal];
    
    return YES;
}

+ (void)routerUnregisterBlock:(NSString *)targetClassname
{
    [self routerHandleCmd:RouterHandlerUnregister caller:nil target:targetClassname params:@{keySRouter__Param_Cmd:SROUTER_PARAM_PACK_NUM(RouterHandlerUnregisterBlock)} from:SRouterCmdFromLocal];
}
+ (void)routerUnregisterProtocl:(id)classInst protocl:(Protocol *)protocl;
{
    [self routerHandleCmd:RouterHandlerUnregister caller:nil target:nil params:@{keySRouter__Param_Cmd:SROUTER_PARAM_PACK_NUM(RouterHandlerUnregisterProtocol), keySRouter__Param_Value:@{keySRouter_RegisterCmd_Param:protocl, keySRouter_RegisterCmd_Instance:classInst}} from:SRouterCmdFromLocal];
}
+ (void)routerUnregisterServiceClass:(NSString *)targetClassname
{
    [self routerHandleCmd:RouterHandlerUnregister caller:nil target:targetClassname params:@{keySRouter__Param_Cmd:SROUTER_PARAM_PACK_NUM(RouterHandlerUnregisterService)} from:SRouterCmdFromLocal];
}
+ (void)routerUnregisterMapName:(NSString *)fullname
{
    [self routerHandleCmd:RouterHandlerUnregister caller:nil target:nil params:@{keySRouter__Param_Cmd:SROUTER_PARAM_PACK_NUM(RouterHandlerUnregisterMapname), keySRouter__Param_Value:@{keySRouter_RegisterCmd_Param:fullname}} from:SRouterCmdFromLocal];
}
+ (void)routerUnregisterMapNameForDict:(NSDictionary *)dictMap
{
    [self routerHandleCmd:RouterHandlerUnregister caller:nil target:nil params:@{keySRouter__Param_Cmd:SROUTER_PARAM_PACK_NUM(RouterHandlerUnregisterMapname), keySRouter__Param_Value:@{keySRouter_RegisterCmd_Param:dictMap}} from:SRouterCmdFromLocal];
}

@end
