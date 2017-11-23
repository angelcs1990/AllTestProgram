//
//  NetworkProxyCmd.h
//  SNetworkDemo
//
//  Created by cs on 16/5/19.
//  Copyright © 2016年 cs. All rights reserved.
//

#ifndef NetworkProxyCmd_h
#define NetworkProxyCmd_h
#import "SRouter.h"

typedef NS_ENUM(NSInteger, NetworkProxyCmds){
    NetworkProxyCmdsSend = RouterModuleOtherCmd + 1,
    NetworkProxyCmdsGetObject
};

#endif /* NetworkProxyCmd_h */
