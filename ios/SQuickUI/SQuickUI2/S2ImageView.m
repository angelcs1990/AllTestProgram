//
//  S2ImageView.m
//  SQuickUI
//
//  Created by cs on 17/9/20.
//  Copyright © 2017年 cs. All rights reserved.
//

#import "S2ImageView.h"

@implementation S2ImageView

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        self.image = image;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect withContext:(CGContextRef)context
{
    //画自己
    if (self.image) {
        //        UIGraphicsPushContext(context);
        [self.image drawInRect:rect];
        //        UIGraphicsPopContext();
    }
    
}

@end
