//
//  E_ModuleMgr.m
//  TestRouter
//
//  Created by cs on 16/4/20.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "E_ModuleMgr.h"
#import "SRouterCmds.h"
#import "TestViewController.h"
#import "SRouter.h"

NSString *const keyModuleClassE = @"E_ModuleMgr";

@implementation E_ModuleMgr

- (instancetype)init
{
    self = [super init];
    if (self) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            SRouter_NotifySubscribers(1, @{@"ret":@"hahah"});
        });
    }
    
    return self;
}
- (id)command:(NSInteger)cmd andParams:(NSDictionary *)dictParam
{
    switch (cmd) {
        case RouterModuleQueryViewControlelr:
            return [TestViewController new];
            break;
            //没必要处理该分支，因为SRouter_NotifySubscribers在该实例中任何地方都可以调用,
        case RouterModuleSubscriberCmd:
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                SRouter_NotifySubscribers(1, @{@"ret":@"hahah"});
            });
        }
            break;
        default:
            break;
    }
    
    return nil;
}

- (void)dealloc
{
    NSLog(@"dealloc");
}
@end
