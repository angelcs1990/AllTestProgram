//
//  SNetworkConfig.h
//  SNetworkDemo
//
//  Created by cs on 16/5/12.
//  Copyright © 2016年 cs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNetworkConfig : NSObject

+ (instancetype)shareInstance;
@property (nonatomic, copy) NSString *baseUrl;
@property (nonatomic) NSTimeInterval timeout;
@property (nonatomic) NSUInteger port;
@end
