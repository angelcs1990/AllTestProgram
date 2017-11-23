//
//  ErrManager.h
//  TestRouter
//
//  Created by cs on 16/12/6.
//  Copyright © 2016年 chensi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "publicDefine.h"



@interface ErrManager : NSObject<SRouterModuleProtocol>


- (void)slotRecive:(NSString *)msg;
@end
