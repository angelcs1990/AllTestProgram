//
//  SSockNetworkProtocol.m
//  SNetworkDemo
//
//  Created by cs on 16/5/26.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "SSockNetworkProtocol.h"


//@implementation SSockCoreNetwork
//
//- (void)sendRequest:(SSockBaseRequest *)request
//{}
//- (void)cancelRequest:(SSockBaseRequest *)request
//{}
//- (void)disconnectRequest:(SSockBaseRequest *)request
//{}
//
//@end

@implementation SSockNetworkPackageLengthInfo

+ (instancetype)packageLengthInfo
{
    SSockNetworkPackageLengthInfo *info = [SSockNetworkPackageLengthInfo new];
    return info;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _packageIgnore = NO;
    }
    
    return self;
}

@end