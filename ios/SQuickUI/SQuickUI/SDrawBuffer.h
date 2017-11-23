//
//  SDrawBuffer.h
//  SQuickUI
//
//  Created by cs on 17/9/19.
//  Copyright © 2017年 cs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SPanel.h"

@interface SDrawBuffer : NSObject

+ (instancetype)shareInstance;

- (void)addPanel:(SPanel *)panel;

@end
