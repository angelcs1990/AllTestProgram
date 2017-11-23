//
//  publicDefine.h
//  TestRouter
//
//  Created by cs on 16/12/6.
//  Copyright © 2016年 chensi. All rights reserved.
//

#ifndef publicDefine_h
#define publicDefine_h

#import <UIKit/UIKit.h>
#import "SRouter.h"

//SRouterExtern(keyModuleErrModule);
SRouterDeclared(keyModuleErrModule, @"ErrManager");

typedef NS_ENUM(NSInteger, ErrModuleType){
    ErrModuleSystem = RouterModuleOtherCmd + 1,
    ErrModuleUser
};

typedef NS_ENUM(NSInteger, ErrModuleParams){
    ErrModuleParamsObject = RouterModuleOtherCmd + 1,
    ErrModuleParamsMsg
};

#define ErrModuleTell(_view, _type, _msg) SRouterHandlerOtherCmd(keyModuleErrModule, SROUTER_PACK_CV(_type, (@{@(ErrModuleParamsObject):_view, @(ErrModuleParamsMsg):@_msg})));
#endif /* publicDefine_h */
