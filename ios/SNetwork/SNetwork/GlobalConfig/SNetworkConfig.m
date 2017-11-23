//
//  SNetworkConfig.m
//  SNetworkDemo
//
//  Created by cs on 16/5/12.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "SNetworkConfig.h"

@implementation SNetworkConfig
+ (instancetype)shareInstance
{
    static SNetworkConfig *netconfig;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        netconfig = [SNetworkConfig new];
    });
    
    return netconfig;
}
@end
