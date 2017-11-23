//
//  ErrManager.m
//  TestRouter
//
//  Created by cs on 16/12/6.
//  Copyright © 2016年 chensi. All rights reserved.
//

#import "ErrManager.h"
#import <UIKit/UIKit.h>
#import "UIView+Toast.h"

//_SRouterDeclared(keyModuleErrModule, @"ErrManager");

@implementation ErrManager

- (void)showToast:(id)widget withMsg:(NSString *)msg
{
    if ([widget isKindOfClass:[UIView class]]) {
        [widget makeToast:msg];
    }
}
- (void)slotRecive:(NSString *)msg
{
    NSLog(@"%@", msg);
}
- (void)disposeErrMessage:(NSDictionary *)dict withType:(ErrModuleType)type
{
    id obj = [dict objectForKey:@(ErrModuleParamsObject)];
    NSString *msg = [dict objectForKey:@(ErrModuleParamsMsg)];
    switch (type) {
        case ErrModuleSystem:
        {
            NSString *msgAdd = [NSString stringWithFormat:@"system :%@", msg];
            [self showToast:obj withMsg:msgAdd];
        }
            break;
        case ErrModuleUser:
        {
            NSString *msgAdd = [NSString stringWithFormat:@"user :%@", msg];
            [self showToast:obj withMsg:msgAdd];
        }
            break;
        default:
            break;
    }
}

- (id)command:(NSInteger)cmd andParams:(NSDictionary *)dictParam
{
    switch (cmd) {
        case RouterModuleOtherCmd:
        {
            NSInteger subCmd = SRouter_Unpack_Cmd(dictParam);
            NSDictionary *params = SRouter_Unpack_Value(dictParam);
            [self disposeErrMessage:params withType:subCmd];
        }
            break;
            
        default:
            break;
    }
    
    return nil;
}
- (void)dealloc
{
    NSLog(@"errmodule dealloc");
}

@end
