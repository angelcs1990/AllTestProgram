//
//  SPanel+SFrameLayoutAdditions.h
//  DrawSelfTest
//
//  Created by cs on 17/9/7.
//  Copyright © 2017年 cs. All rights reserved.
//

#import "SPanel.h"
#import "SFrameLayoutMaker.h"
#import "SFrameLayoutAttr.h"


@interface SPanel (SFrameLayoutAdditions)

@property (nonatomic, assign, readonly) SFrameLayoutAttr *fl_left;

@property (nonatomic, assign, readonly) SFrameLayoutAttr *fl_top;

@property (nonatomic, assign, readonly) SFrameLayoutAttr *fl_right;

@property (nonatomic, assign, readonly) SFrameLayoutAttr *fl_bottom;

@property (nonatomic, assign, readonly) SFrameLayoutAttr *fl_width;

@property (nonatomic, assign, readonly) SFrameLayoutAttr *fl_height;

@property (nonatomic, assign, readonly) SFrameLayoutAttr *fl_centerX;

@property (nonatomic, assign, readonly) SFrameLayoutAttr *fl_centerY;

- (void)fl_makeConstraints:(void(^)(SFrameLayoutMaker *make))block;

@end
