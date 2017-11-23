//
//  SDrawBuffer.m
//  SQuickUI
//
//  Created by cs on 17/9/19.
//  Copyright © 2017年 cs. All rights reserved.
//

#import "SDrawBuffer.h"
#import "SPanel+Geometry.h"

@implementation SDrawBuffer

+ (instancetype)shareInstance
{
    static SDrawBuffer *buf;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        buf = [SDrawBuffer new];
    });
    
    return buf;
}

- (void)addPanel:(SPanel *)panel
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIGraphicsBeginImageContextWithOptions(panel.size, YES, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [panel renderWithContext:context withRect:panel.frame];
        panel.imageContent = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        dispatch_async(dispatch_get_main_queue(), ^{
            panel.destView.layer.contents = (__bridge id)(panel.imageContent).CGImage;
        });
    });
}

@end
