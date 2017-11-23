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
    RouterHandlerOther          //其他扩展命令
};
typedef NS_ENUM(NSInteger, RouterHandlerQueryCmds){
    RouterHandlerQueryViewController,
    RouterHandlerQueryProtocol,
    RouterHandlerQueryBlock,
    RouterHandlerQueryOther
};

typedef NS_ENUM(NSInteger, RouterHandlerJumpCmds){
    RouterHandlerJumpPush,
    RouterHandlerJumpPresent,
    RouterHandlerJumpPushWithParams,
    RouterHandlerJumpPresentWithParams,
    RouterHandlerJumpOther
};

typedef NS_ENUM(NSInteger, RouterHandlerRegisterCmds){
    RouterHandlerRegisterBlock,
    RouterHandlerRegisterProtocol,
    RouterHandlerRegisterService,
    RouterHandlerRegisterMapname,
    RouterHandlerRegisterOther
};
typedef NS_ENUM(NSInteger, RouterHandlerUnregisterCmds){
    RouterHandlerUnregisterBlock = RouterHandlerRegisterBlock,
    RouterHandlerUnregisterProtocol = RouterHandlerRegisterProtocol,
    RouterHandlerUnregisterService = RouterHandlerRegisterService,
    RouterHandlerUnregisterMapname = RouterHandlerRegisterMapname,
    RouterHandlerUnregisterOther = RouterHandlerRegisterOther
};


//module命令
typedef NS_ENUM(NSInteger, RouterModuleCmds) {
    RouterModuleParams,           //参数传递
    RouterModuleQueryViewControlelr,  //vc获取

    RouterModuleOtherCmd              //其他扩展命令
};


#endif /* Header_h */
