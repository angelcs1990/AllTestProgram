//
//  STableViewConfig.h
//  GameGuess_CN
//
//  Created by cs on 16/12/15.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STableViewConfig : NSObject

/**
 *  在没有按照常规实现某方法时，是否抛出异常,default:YES
 */
@property (nonatomic) BOOL canException;

+ (instancetype)tableViewConfig;

@end
