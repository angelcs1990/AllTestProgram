//
//  STableViewConfig.m
//  GameGuess_CN
//
//  Created by cs on 16/12/15.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "STableViewConfig.h"

@implementation STableViewConfig

+ (instancetype)tableViewConfig
{
    STableViewConfig *cig = [STableViewConfig new];
    return cig;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupValue];
    }
    
    return self;
}

- (void)setupValue
{
    self.canException = YES;
}

@end
