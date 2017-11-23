//
//  SRouterConfig.h
//  TestRouter
//
//  Created by cs on 16/12/16.
//  Copyright © 2016年 chensi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SROUTER_DEFAULT_PLIST @"SRouterDefault"

@interface SRouterConfig : NSObject
/**
 *  是否自动载入配置,默认配置文件是SRouterDefault.plist,default:NO
 */
@property (nonatomic) BOOL  autoLoadPlist;

/**
 *  是否验证所有,default:NO
 */
@property (nonatomic) BOOL checkAll;

/**
 *  是否只验证注册的操作，default：YES
 */
@property (nonatomic) BOOL onlyCheckRegiste;

/**
 *  是否只验证本地调用，default：YES
 */
@property (nonatomic) BOOL onlyCheckLocal;

/**
 *  是否总是抛出异常，如果不设置，那么只会log输出，设置后总是抛出异常，
 *  只在debug模式下有用，default：NO
 */
@property (nonatomic) BOOL alwaysException;

+ (instancetype)shareInstance;

@end
