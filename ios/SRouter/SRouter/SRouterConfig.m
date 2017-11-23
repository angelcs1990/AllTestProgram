//
//  SRouterConfig.m
//  TestRouter
//
//  Created by cs on 16/12/16.
//  Copyright © 2016年 chensi. All rights reserved.
//

#import "SRouterConfig.h"

@implementation SRouterConfig

+ (instancetype)shareInstance
{
    static SRouterConfig *cig = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cig = [SRouterConfig new];
    });
    
    return cig;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupData];
    }
    
    return self;
}

- (void)setupData
{
    self.checkAll = NO;
    self.onlyCheckLocal = YES;
    self.onlyCheckRegiste = YES;
    self.alwaysException = NO;
}

@end
