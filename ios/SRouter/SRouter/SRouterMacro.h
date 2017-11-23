//
//  publicInf_macro.h
//  TestRouter
//
//  Created by cs on 16/4/19.
//  Copyright © 2016年 cs. All rights reserved.
//

#ifndef publicInf_macro_h
#define publicInf_macro_h

#import "SRouterHandlerProtocol.h"
#import "SRouterManager.h"



#define _SROUTER_SHAREINSTANECE_(_class, _fun) ({\
    id _SRouter_delegate_; \
    if(!NSClassFromString(_class)){\
        _SRouter_delegate_ = nil; \
    } else {\
        id _LOCAL_CLASS_ = NSClassFromString(_class);\
        SEL _LOCAL_FUN_ = NSSelectorFromString(_fun);\
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
        _SRouter_delegate_ = [_LOCAL_CLASS_ performSelector:_LOCAL_FUN_]; \
_Pragma("clang diagnostic pop") \
    }\
    _SRouter_delegate_;\
})



#define _SROUTER_HANDLER_CMD_LOCAL(_cmd, _target, _params, _from) [SROUTER_SHAREINSTANECE() routerHandleCmd:_cmd caller:self target:_target params:_params from:_from]

#define _SROUTER_QUERY_(_cmd, _value) [SROUTER_SHAREINSTANECE() routerQuery:_cmd target:_value]



#define _SROUTER_HANDLER_OTHERCMD(_target, _params, _from) [SROUTER_SHAREINSTANECE() routerHandleOtherCmd:self target:_target params:_params from:_from]

//////////////////////////////////////////////////////////////////////////////

/**
 *  获取实例对象
 *
 *  @return SRouter实例对象
 */
#define SROUTER_SHAREINSTANECE()  NSClassFromString(@"SRouterManager")
//_SROUTER_SHAREINSTANECE_(@"SRouterManager", @"shareInstance")

/**
 *  其它命令执行
 *
 *  @param _target 目标类名(NSString *)
 *  @param _params 参数(NSDictionary *)(如果只有子命令，可用SROUTER_OTHERCMD_PACK打包）
 *                 示例：1.SRouterHandlerOtherCmd(@"targetClass", SROUTER_OTHERCMD_PACK(cmd_1, value_1))
 *                      2.SRouterHandlerOtherCmd(@"targetClass", SROUTER_OTHERCMD_PACK_NOPARAM(cmd_1))
 *
 *  @return 所需对象(id)
 */
#define SRouterHandlerOtherCmd(_target, _params) _SROUTER_HANDLER_OTHERCMD(_target, _params, SRouterCmdFromLocal)


//类名映射
#pragma mark - 类名映射
/**
 *  执行远程调用时候必须调用该宏注册方可调用成功
 *
 *  @param _sname 自定义一个简短的字符串对应原类名(NSString *)（在远程调用的时候可以用该字符串代替原类名调用）
 *  @param _fname 原类名(NSString *)
 *
 */
#define SRouterRegisterShortName(_sname, _fname) [SROUTER_SHAREINSTANECE() routerRegisterMapName:_sname target:_fname]
/**
 *  同上
 *
 *  @param _dict 如果有多个简短字符对应类名，可以自己用Dictionary完成映射(NSDictionary *)
 *               示例：SRouterRegisterShortNameFromDict((@{@"B":keyModuleClassB, @"C":keyModuleClassC, @"D":keyModuleClassD}));
 *               注意：如例子所示，需要多加一层括号
 *
 */
#define SRouterRegisterShortNameFromDict(_dict) [SROUTER_SHAREINSTANECE() routerRegisterMapNameForDict:_dict]







/**
 *  订阅相关
 *
 *
 */
#define SRouter_SubscribMessage(_target, _msg) [SROUTER_SHAREINSTANECE() routerSubscribMsg:_msg withTargetInst:_target caller:self]
#define SRouter_NotifySubscribers(_msg, _params) [SROUTER_SHAREINSTANECE() routerNotifySubscriber:self withMsg:_msg withParams:_params]
#define SRouter_UnSubscribMessage(_target, _msg) [SROUTER_SHAREINSTANECE() routerUnSubscribMsg:_msg withTargetInst:_target caller:self]



//获取协议，block等
#define SRouterQueryViewController(_value) _SROUTER_QUERY_(SubQueryRouterHandlerViewController, _value)
#define SRouterQueryProtocol(_value) _SROUTER_QUERY_(SubQueryRouterHandlerProtocol, @protocol(_value))
#define SRouterQueryBlock(_value) _SROUTER_QUERY_(SubQueryRouterHandlerBlock, _value)
#define SRouterQueryBlockDefault() _SROUTER_QUERY_(SubQueryRouterHandlerBlock, self)


//协议，Block注册
#pragma mark - 协议，Block注册
/**
 *  注册block
 *
 *  @param _name 目标类名(NSString *)
 *  @param _blk  block(SRouterHandler)
 *               注意：只要是注册的东西，请自己手动解除注册
 *
 */
#define SRouterRegisterBlockName(_name, _blk) \
    [SROUTER_SHAREINSTANECE() routerRegisterBlock:_blk withKeyName:_name];
#define SRouterRegisterProtocol(_inst, _protocol) \
    [SROUTER_SHAREINSTANECE() routerRegisterProtocol:@protocol(_protocol) withInstance:_inst];
#define SRouterRegisterProtocolDef(_protocol) SRouterRegisterProtocol(self, _protocol)

#define SRouterRegisterService(_classname) \
    [SROUTER_SHAREINSTANECE() routerRegisterServiceClass:_classname]

#define SRouterRegisterBlockInstance(_inst, _blk) \
    [SROUTER_SHAREINSTANECE() routerRegisterBlock:_blk withInstance:_inst];
/**
 *  解除注册实例
 *
 *  @param _classname 类名
 *
 */
#define SRouterUnRegisterService(_classname) \
    [SROUTER_SHAREINSTANECE() routerUnregisterServiceClass:_classname]
#define SROUTER_UNREGISTER_BLOCK(_classname) \
    [SROUTER_SHAREINSTANECE() routerUnregisterBlockWithKeyname:_classname];
#define SROUTER_UNREGISTER_RPOTOCOL(_inst, _protocol) \
    [SROUTER_SHAREINSTANECE() routerUnregisterProtocol:@protocol(_protocol) withInstance:_inst];

#define SROUTER_UNREGISTER_BLOCK_INSTANCE(_inst) \
    [SROUTER_SHAREINSTANECE() routerUnregisterBlockWithInstance:_inst];


//本地调用
#pragma mark - 本地调用

#define SRouterPush(_target) [SROUTER_SHAREINSTANECE() routerPushLocal:_target caller:self]
#define SRouterPushWithParams(_target, _params) [SROUTER_SHAREINSTANECE() routerPushLocal:_target caller:self params:_params]
#define SRouterPresent(_target) [SROUTER_SHAREINSTANECE() routerPresentLocal:_target caller:self]
#define SRouterPresentWithParams(_target, _params) [SROUTER_SHAREINSTANECE() routerPresentLocal:_target caller:self params:_params]

//远程调用
#pragma mark - 远程调用
#define SROUTER_PUSH_REMOTE(_target) [SROUTER_SHAREINSTANECE() routerPushRemote:_target caller:self]
#define SROUTER_PUSH_PARAMS_REMOTE(_target, _params) [SROUTER_SHAREINSTANECE() routerPushRemote:_target caller:self params:_params]
#define SROUTER_PRESENT_REMOTE(_target) [SROUTER_SHAREINSTANECE() routerPresentRemote:_target caller:self]
#define SROUTER_PRESENT_PARAMS_REMOTE(_target, _params) [SROUTER_SHAREINSTANECE() routerPresentRemote:_target caller:self params:_params]


#define _SROUTER_ACTION_LOCAL_BLOCK(_action, _target, _block) do{\
    id _SROUTER_PUSH_LOCAL_BLOCK_obj = nil; \
    if((_param) == nil) \
    _SROUTER_PUSH_LOCAL_BLOCK_obj = _action(_target); \
    if(_SROUTER_PUSH_LOCAL_BLOCK_obj == nil){\
        NSAssert(NO, @"SROUTER_PUSH_LOCAL_BLOCK return value is NULL"); \
    } else {\
        SRouterRegisterBlockInstance(_SROUTER_PUSH_LOCAL_BLOCK_obj, _block) \
    } \
}while(0)
#define _SROUTER_ACTION_LOCAL_BLOCK_PARAM(_action, _target, _param, _block) do{\
    id _SROUTER_PUSH_LOCAL_BLOCK_obj = nil; \
    _SROUTER_PUSH_LOCAL_BLOCK_obj = _action(_target, _param); \
    if(_SROUTER_PUSH_LOCAL_BLOCK_obj == nil){\
        NSAssert(NO, @"SROUTER_PUSH_LOCAL_BLOCK return value is NULL"); \
    } else {\
        SRouterRegisterBlockInstance(_SROUTER_PUSH_LOCAL_BLOCK_obj, _block) \
    } \
}while(0)


#define SROUTER_PUSH_BLOCK_LOCAL(_target, _block) _SROUTER_ACTION_LOCAL_BLOCK(SROUTER_PUSH_LOCAL, _target, nil, _block)
#define SRouterPushParamsWithBlock(_target, _param, _block) _SROUTER_ACTION_LOCAL_BLOCK_PARAM(SRouterPushWithParams, _target, _param, _block)
#define SROUTER_PRESENT_BLOCK_LOCAL(_target, _block) _SROUTER_ACTION_LOCAL_BLOCK(SRouterPresent, _target, nil, _block)
#define SROUTER_PRESENT_PARAMS_BLOCK_LOCAL(_target, _param, _block) _SROUTER_ACTION_LOCAL_BLOCK(SRouterPresentWithParams, _target, _param, _block)


#define SROUTER_PUSH_BLOCK_REMOTE(_target, _block) _SROUTER_ACTION_LOCAL_BLOCK(SROUTER_PUSH_REMOTE, _target, nil, _block)
#define SROUTER_PUSH_PARAMS_BLOCK_REMOTE(_target, _param, _block) _SROUTER_ACTION_LOCAL_BLOCK(SROUTER_PUSH_PARAMS_REMOTE, _target, _param, _block)
#define SROUTER_PRESENT_BLOCK_REMOTE(_target, _block) _SROUTER_ACTION_LOCAL_BLOCK(SROUTER_PRESENT_REMOTE, _target, nil, _block)
#define SROUTER_PRESENT_PARAMS_BLOCK_REMOTE(_target, _param, _block) _SROUTER_ACTION_LOCAL_BLOCK(SROUTER_PRESENT_PARAMS_REMOTE, _target, _param, _block)


//其它一些实用宏
/**
 *  定义声明一个变量
 *
 *  @param _key  变量名
 *  @param _name 字符串
 *
 */
#define _SRouterDeclared(_key, _classname) NSString *const _key = _classname
#define SRouterDeclared(_key, _classname) static NSString *const _key = _classname
/**
 *  引用一个变量
 *
 *  @param _name 变量名
 *
 */
#define SRouterExtern(_key) extern NSString *const _key;
#pragma mark - 其它一些实用宏

#define SROUTER_DEBUG

#ifdef SROUTER_DEBUG
//#define SRouterErrLog(_t) NSLog(@"文件：%@ 函数：%s(%d)--%@", [[NSString stringWithUTF8String: __FILE__] lastPathComponent], __func__, __LINE__, _t)
#define __SRouterLog(_t, _err) do{\
        if([SRouterConfig shareInstance].alwaysException && _err) {\
            @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:_t userInfo:nil]; \
        } else { \
            NSLog(@"文件：%@ 函数：%s(%d)--%@", [[NSString stringWithUTF8String: __FILE__] lastPathComponent], __func__, __LINE__, _t); \
        }\
    }while(0)



#else
#define __SRouterLog(_t, _err) {}
#endif

#define SRouterErrLog(_t) __SRouterLog(_t, YES)
#define SRouterLog(_t) __SRouterLog(_t, NO)

#ifndef SROUTER_WeakSelf
#define SROUTER_WeakSelf(_v) autoreleasepool{} __weak typeof (_v) _v##_weakSelf = _v
#endif

#ifndef SROUTER_strongSelf
#define SROUTER_strongSelf(_v) try{} @finally{} __strong typeof(_v) _v = _v##_weakSelf
#endif

//#define SROUTER_SUB_CMD(_dict) [_dict objectForKey:keySRouter__Param_Cmd]
//#define SROUTER_SUB_VALUE(_dict) [_dict objectForKey:keySRouter__Param_Value]

//其它扩展命令子命令，命令keySRouter_QueryCmd_Param_Cmd，参数keySRouter_QueryCmd_Param_Value
SRouterExtern(keySRouter__Param_Cmd);
SRouterExtern(keySRouter__Param_Value);
SRouterExtern(keySRouter__Param_ExtraParams);
SRouterExtern(keySRouter_RegisterCmd_Param);
SRouterExtern(keySRouter_RegisterCmd_Instance);
SRouterExtern(keySRouter_RegisterCmd_TargeName);
//其它扩展命令参数打包
//带参数的
#define SROUTER_PACK_CV(_cmd, _value) (@{keySRouter__Param_Cmd:[NSNumber numberWithInteger:_cmd], keySRouter__Param_Value:_value})
//不带参数的
#define SROUTER_PACK_C(_cmd) (@{keySRouter__Param_Cmd:[NSNumber numberWithInteger:_cmd]})
#define SRouter_Unpack_Cmd(_dictparam) [[_dictparam objectForKey:keySRouter__Param_Cmd] integerValue]
#define SRouter_Unpack_Value(_dictparam) [_dictparam objectForKey:keySRouter__Param_Value]

#endif /* publicInf_macro_h */
