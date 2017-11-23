//
//  GGCSDataErrorHandler.m
//  GameGuess_CN
//
//  Created by cs on 16/8/11.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "STableViewHeader.h"

@implementation SDataErrorHandler

+ (instancetype)shareInstance
{
    static SDataErrorHandler *errorHandler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        errorHandler = [[[self class] alloc] init];
    });
    
    return errorHandler;
}

- (BOOL)handleError:(STableViewDataSource *)dataSource withData:(id)oriData withType:(NSInteger)type
{
//    if (oriData != nil) {
//        NSString *code = [oriData objectForKey:@"code"];
//        NSInteger nCode = [code integerValue];
//        
//        switch (nCode) {
//            case 500:
////                [[UIApplication sharedApplication].windows.lastObject gg_showToastCenter:LOCALIZATION(IM_ServerError)];
//                return NO;
//            case 200:
//            default:
//                break;
//        }
//    }
    
    return YES;
}

@end
