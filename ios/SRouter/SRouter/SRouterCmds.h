//
//  Header.h
//  TestRouter
//
//  Created by cs on 16/4/19.
//  Copyright © 2016年 cs. All rights reserved.
//

#ifndef publicInf_cmds_h
#define publicInf_cmds_h

//handler提交命令
typedef NS_ENUM(NSInteger, RouterHandlerCmds){
    RouterHandlerRegister,      //注册命令 [包含子命令RouterHandlerRegisterCmds］
    RouterHandlerUnregister,    //反注册   [包含子命令RouterHandlerUnregisterCmds]
    RouterHandlerJump,          //跳转动作 [包含子命令RouterHandlerJumpCmds]
    RouterHandlerQuery,         //查询     [包含子命令RouterHandlerQueryCmds]
    RouterHandlerNotifySubscriber,     //通知所有已经订阅的
    RouterHandlerRuleFiles,     //像plist文件中的一样，做验证用
    RouterHandlerOther          //其他扩展命令
};

typedef NS_ENUM(NSInteger, RouterHandlerRuleFileCmds){
    SubRuleRouterHandleAdd,
    SubRuleRouterHandleClear,
    SubRuleRouterHandleRemove,
    SubRuleRouterHandleOther
};

typedef NS_ENUM(NSInteger, RouterHandlerQueryCmds){
    SubQueryRouterHandlerViewController,
    SubQueryRouterHandlerProtocol,
    SubQueryRouterHandlerBlock,
    SubQueryRouterHandlerOther
};

typedef NS_ENUM(NSInteger, RouterHandlerJumpCmds){
    SubJumpRouterHandlerPush,
    SubJumpRouterHandlerPresent,
    SubJumpRouterHandlerPushWithParams,
    SubJumpRouterHandlerPresentWithParams,
    SubJumpRouterHandlerOther
};

typedef NS_ENUM(NSInteger, RouterHandlerRegisterCmds){
    SubRegisterRouterHandlerBlock,
    SubRegisterRouterHandlerProtocol,
    SubRegisterRouterHandlerService,
    SubRegisterRouterHandlerMapname,
    SubRegisterRouterHandlerSubscribe,     //订阅
    SubRegisterRouterHandlerOther
};

typedef NS_ENUM(NSInteger, RouterHandlerUnregisterCmds){
    SubUnregisterRouterHandlerBlock = SubRegisterRouterHandlerBlock,
    SubUnregisterRouterHandlerProtocol = SubRegisterRouterHandlerProtocol,
    SubUnregisterRouterHandlerService = SubRegisterRouterHandlerService,
    SubUnregisterRouterHandlerMapname = SubRegisterRouterHandlerMapname,
    SubUnregisterRouterHandlerSubscribe = SubRegisterRouterHandlerSubscribe,     //订阅
    SubUnregisterRouterHandlerOther = SubRegisterRouterHandlerOther
};

//module命令
typedef NS_ENUM(NSInteger, RouterModuleCmds) {
    RouterModuleParams,           //参数传递
    RouterModuleQueryViewControlelr,  //vc获取
    RouterModuleSubscriberCmd,
    RouterModuleNotifySubscriberCmd,
    RouterModuleOtherCmd              //其他扩展命令
};

#endif /* Header_h */
