//
//  SRouterSubscriberCenter.h
//  TestRouter
//
//  Created by cs on 16/12/5.
//  Copyright © 2016年 chensi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRouterModuleProtocol.h"

@class SRouterCache;

@interface SRouterSubscriberCenter : NSObject<SRouterModuleProtocol>

@property (nonatomic, weak) SRouterCache *dataContext;

+ (instancetype)shareInstance;

@end
