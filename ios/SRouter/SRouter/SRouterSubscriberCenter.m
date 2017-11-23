//
//  SRouterSubscriberCenter.m
//  TestRouter
//
//  Created by cs on 16/12/5.
//  Copyright © 2016年 chensi. All rights reserved.
//

#import "SRouterSubscriberCenter.h"
#import "SRouterCmds.h"
#import "SRouterLocal.h"
#import "SRouterMacro.h"
#import "SRouterCache.h"



@implementation SRouterSubscriberCenter

+ (instancetype)shareInstance
{
    static SRouterSubscriberCenter *routerCtr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        routerCtr = [SRouterSubscriberCenter new];
    });
    
    return routerCtr;
}
//- (NSInteger)_subCmd:(RouterHandlerContext *)ctx
//{
//    NSInteger cmd = [ctx.dictParam[keySRouter__Param_Cmd] integerValue];
//    return cmd;
//}
//
//- (id)_subParams:(RouterHandlerContext *)ctx
//{
//    id params = ctx.dictParam[keySRouter__Param_Value];
//    return params;
//}
//- (void)routerUnSubscribe:(RouterHandlerContext *)context
//{
//    NSInteger msg = [[self _subParams:context] integerValue];
//    id target = context.callee;
//    if (target == nil) {
//        //        target = self;
//        return;
//    }
//    
//    [self.dataContext unregisterSubscriberInstance:context.caller withDestObj:target withMsg:msg];
//}
//
//- (id)routerNotifySubscriber:(RouterHandlerContext *)context
//{
//    NSInteger msg = [self _subCmd:context];
//    
//    NSArray *arrayRet = [self.dataContext subscriberObjects:context.caller withMsg:msg];
//    NSDictionary *params = [self _subParams:context];
//    [arrayRet enumerateObjectsUsingBlock:^(NSValue  * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [[obj nonretainedObjectValue] command:RouterModuleNotifySubscriberCmd andParams:params];
//    }];
//    
//    return nil;
//}
//
//- (id)routerSubscribe:(RouterHandlerContext *)context
//{
//    NSInteger msg = [[self _subParams:context] integerValue];
//    id target = context.callee;
//    if (target == nil) {
//        //        target = self;
//        return nil;
//    }
//    
//    if ([target conformsToProtocol:@protocol(SRouterModuleProtocol)] == NO) {
//        return nil;
//    }
//    
//    [self.dataContext registerSubscriberInstance:context.caller withDestObj:target withMsg:msg];
//    
//    //    NSDictionary *dictParams = context.dictParam[keySRouter__Param_ExtraParams];
//    
//    [target command:RouterModuleSubscriberCmd andParams:nil];
//    return nil;
//}
#pragma mark - ModuleProtocol
- (id)command:(NSInteger)cmd andParams:(NSDictionary *)dictParam
{
    switch (cmd) {
        case RouterModuleSubscriberCmd:
            
            break;
        case RouterModuleNotifySubscriberCmd:
            break;
        default:
            break;
    }
    
    return nil;
}

@end
