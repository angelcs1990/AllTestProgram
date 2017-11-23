//
//  SDebugTools.m
//  STabViewDemo
//
//  Created by cs on 16/10/28.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "SDebugTools.h"

extern void _objc_autoreleasePoolPrint();

@implementation SDebugTools

+ (void)showAutoreleasePool
{
#ifdef DEBUG
    _objc_autoreleasePoolPrint();
#endif
}

@end
