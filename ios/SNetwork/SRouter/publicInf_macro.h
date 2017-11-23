//
//  publicInf_macro.h
//  TestRouter
//
//  Created by cs on 16/4/19.
//  Copyright © 2016年 cs. All rights reserved.
//

#ifndef publicInf_macro_h
#define publicInf_macro_h

#import "RouterHandlerInf.h"
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

#define SROUTER_LOG(_t) NSLog(@"%@", _t)

#ifndef SROUTER_WeakSelf
#define SROUTER_WeakSelf(_v) autoreleasepool{} __weak typeof (_v) _v##_weakSelf = _v
#endif

#ifndef SROUTER_strongSelf
#define SROUTER_strongSelf(_v) try{} @finally{} __strong typeof(_v) _v = _v##_weakSelf
#endif
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
 *                 示例：1.SROUTER_HANDLER_OTHERCMD_LOCAL(@"targetClass", SROUTER_OTHERCMD_PACK(cmd_1, value_1))
 *                      2.SROUTER_HANDLER_OTHERCMD_LOCAL(@"targetClass", SROUTER_OTHERCMD_PACK_NOPARAM(cmd_1))
 *
 *  @return 所需对象(id)
 */
#define SROUTER_HANDLER_OTHERCMD_LOCAL(_target, _params) _SROUTER_HANDLER_OTHERCMD(_target, _params, SRouterCmdFromLocal)


//类名映射
#pragma mark - 类名映射
/**
 *  执行远程调用时候必须调用该宏注册方可调用成功
 *
 *  @param _sname 自定义一个简短的字符串对应原类名(NSString *)（在远程调用的时候可以用该字符串代替原类名调用）
 *  @param _fname 原类名(NSString *)
 *
 */
#define SROUTER_REGISTER_SHORTNAME(_sname, _fname) [SROUTER_SHAREINSTANECE() routerRegisterMapName:_sname target:_fname]
/**
 *  同上
 *
 *  @param _dict 如果有多个简短字符对应类名，可以自己用Dictionary完成映射(NSDictionary *)
 *               示例：SROUTER_REGISTER_SHORTNAME_FOR_DICT((@{@"B":keyModuleClassB, @"C":keyModuleClassC, @"D":keyModuleClassD}));
 *               注意：如例子所示，需要多加一层括号
 *
 */
#define SROUTER_REGISTER_SHORTNAME_FOR_DICT(_dict) [SROUTER_SHAREINSTANECE() routerRegisterMapNameForDict:_dict]




//变量声明引用
#pragma mark - 变量声明引用
/**
 *  定义声明一个变量
 *
 *  @param _key  变量名
 *  @param _name 字符串
 *
 */
#define SROUTER_DECLARED_NAME(_key, _name) NSString *const _key = _name
/**
 *  引用一个变量
 *
 *  @param _name 变量名
 *
 */
#define SROUTER_EXTERN_NAME(_key) extern NSString *const _key;



//本地调用
#pragma mark - 本地调用

#define SROUTER_PUSH_LOCAL(_target) [SROUTER_SHAREINSTANECE() routerPushLocal:_target caller:self]
#define SROUTER_PUSH_PARAMS_LOCAL(_target, _params) [SROUTER_SHAREINSTANECE() routerPushLocal:_target caller:self params:_params]
#define SROUTER_PRESENT_LOCAL(_target) [SROUTER_SHAREINSTANECE() routerPresentLocal:_target caller:self]
#define SROUTER_PRESENT_PARAMS_LOCAL(_target, _params) [SROUTER_SHAREINSTANECE() routerPresentLocal:_target caller:self params:_params]

//远程调用
#pragma mark - 远程调用
#define SROUTER_PUSH_REMOTE(_target) [SROUTER_SHAREINSTANECE() routerPushRemote:_target caller:self]
#define SROUTER_PUSH_PARAMS_REMOTE(_target, _params) [SROUTER_SHAREINSTANECE() routerPushRemote:_target caller:self params:_params]
#define SROUTER_PRESENT_REMOTE(_target) [SROUTER_SHAREINSTANECE() routerPresentRemote:_target caller:self]
#define SROUTER_PRESENT_PARAMS_REMOTE(_target, _params) [SROUTER_SHAREINSTANECE() routerPresentRemote:_target caller:self params:_params]



//获取协议，block等
#define SROUTER_QUERY_VIEWCONTROLLER(_value) _SROUTER_QUERY_(RouterHandlerQueryViewController, _value)
#define SROUTER_QUERY_PROTOCOL(_value) _SROUTER_QUERY_(RouterHandlerQueryProtocol, @protocol(_value))
#define SROUTER_QUERY_BLOCK(_value) _SROUTER_QUERY_(RouterHandlerQueryBlock, _value)
#define SROUTER_QUERY_BLOCK_SIMP() _SROUTER_QUERY_(RouterHandlerQueryBlock, NSStringFromClass([self class]))


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
#define SROUTER_REGISETER_BLOCK(_name, _blk) \
    [SROUTER_SHAREINSTANECE() routerRegister:_name block:_blk];
#define SROUTER_REGISTER_PROTOCOL(_inst, _protocol) \
    [SROUTER_SHAREINSTANECE() routerRegister:_inst protocol:@protocol(_protocol)];
#define SROUTER_REGISTER_PROTOCOL_SELF(_protocol) SROUTER_REGISTER_PROTOCOL(self, _protocol)

#define SROUTER_REGISTER_INSTANCE(_classname) \
    [SROUTER_SHAREINSTANECE() routerRegisterServiceClass:_classname]

/**
 *  解除注册实例
 *
 *  @param _classname 类名
 *
 */
#define SROUTER_UNREGISTER_INSTANCE(_classname) \
    [SROUTER_SHAREINSTANECE() routerUnregisterServiceClass:_classname]
#define SROUTER_UNREGISTER_BLOCK(_classname) \
    [SROUTER_SHAREINSTANECE() routerUnregisterBlock:_classname];
#define SROUTER_UNREGISTER_RPOTOCOL(_inst, _protocol) \
    [SROUTER_SHAREINSTANECE() routerUnregisterProtocl:_inst protocl:@protocol(_protocol)];

//其它扩展命令子命令，命令keySRouter_QueryCmd_Param_Cmd，参数keySRouter_QueryCmd_Param_Value
SROUTER_EXTERN_NAME(keySRouter__Param_Cmd);
SROUTER_EXTERN_NAME(keySRouter__Param_Value);
SROUTER_EXTERN_NAME(keySRouter_RegisterCmd_Param);
SROUTER_EXTERN_NAME(keySRouter_RegisterCmd_Instance);
SROUTER_EXTERN_NAME(keySRouter_RegisterCmd_TargeName);
//其它扩展命令参数打包
#define SROUTER_OTHERCMD_PACK(_cmd, _value) (@{keySRouter__Param_Cmd:[NSNumber numberWithInteger:_cmd], keySRouter__Param_Value:_value})
#define SROUTER_OTHERCMD_PACK_NOPARAM(_cmd) (@{keySRouter__Param_Cmd:[NSNumber numberWithInteger:_cmd]})






#endif /* publicInf_macro_h */
