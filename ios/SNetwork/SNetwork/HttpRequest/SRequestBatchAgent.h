//
//  SRequestBatchAgent.h
//  SNetworkDemo
//
//  Created by cs on 16/5/12.
//  Copyright © 2016年 cs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBaseRequest.h"

@protocol SRequestBatchDelegate <NSObject>



@end

@interface SRequestBatchAgent : NSObject

- (id)initWithRequestArray:(NSArray *)requestArray;
- (void)start;
- (void)cancel;

@end
