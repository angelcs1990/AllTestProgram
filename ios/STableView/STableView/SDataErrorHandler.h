//
//  GGCSDataErrorHandler.h
//  GameGuess_CN
//
//  Created by cs on 16/8/11.
//  Copyright © 2016年 gaoqi. All rights reserved.
//


#import "STableViewProtocolHeader.h"

@interface SDataErrorHandler : NSObject<STableViewDataErrorDelegate>

+ (instancetype)shareInstance;

@end
