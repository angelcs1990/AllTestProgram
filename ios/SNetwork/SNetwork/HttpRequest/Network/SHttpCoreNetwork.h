//
//  SCoreNetwork.h
//  SNetworkDemo
//
//  Created by cs on 16/5/12.
//  Copyright © 2016年 cs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SHttpNetworkProtocol.h"



/**
 *  网络实现类
 */
@interface SHttpNetwork : SHttpCoreNetwork

@property (nonatomic, weak) id<SNetworkExtraConfigDelegate> paramExtraDelegate;

+ (instancetype)shareInstance;
@end
