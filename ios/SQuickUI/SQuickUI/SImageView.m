//
//  SImageView.m
//  SQuickUI
//
//  Created by cs on 17/9/13.
//  Copyright © 2017年 cs. All rights reserved.
//

#import "SImageView.h"
#import "SPanel+Geometry.h"

@implementation SImageView

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
