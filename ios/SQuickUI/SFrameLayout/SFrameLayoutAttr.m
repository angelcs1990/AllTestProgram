//
//  SFrameLayoutAttr.m
//  DrawSelfTest
//
//  Created by cs on 17/9/7.
//  Copyright © 2017年 cs. All rights reserved.
//

#import "SFrameLayoutAttr.h"
#import "SFrameLayoutMaker.h"


@implementation SFrameLayoutAttr

- (id)initWithPanel:(SPanel *)panel layoutAttr:(MASAttribute)layoutAttr
{
    self = [super init];
    if (self) {
        self.panel = panel;
        self.layoutAttr = layoutAttr;
    }
    
    return self;
}

@end
