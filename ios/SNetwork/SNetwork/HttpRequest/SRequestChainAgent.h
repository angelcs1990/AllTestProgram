//
//  SRequestChainAgent.h
//  SNetworkDemo
//
//  Created by cs on 16/5/12.
//  Copyright © 2016年 cs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBaseRequest.h"

@protocol SRequestChainDelegate <NSObject>



@end

@interface SRequestChainAgent : NSObject
- (id)initWithRequestArray:(NSArray *)requestArray;
- (void)start;
- (void)cancel;
@end
