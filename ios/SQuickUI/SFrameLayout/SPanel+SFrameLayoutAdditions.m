//
//  SPanel+SFrameLayoutAdditions.m
//  DrawSelfTest
//
//  Created by cs on 17/9/7.
//  Copyright © 2017年 cs. All rights reserved.
//

#import "SPanel+SFrameLayoutAdditions.h"

@implementation SPanel (SFrameLayoutAdditions)

- (void)fl_makeConstraints:(void (^)(SFrameLayoutMaker *))block {
    SFrameLayoutMaker *maker = [[SFrameLayoutMaker alloc] initWithView:self];
    block(maker);
    [maker install];
}

- (SFrameLayoutAttr *)fl_right {
//    return (self.fl_attr.x + self.fl_attr.width);
    return [[SFrameLayoutAttr alloc] initWithPanel:self layoutAttr:MASAttributeRight];
}

- (SFrameLayoutAttr *)fl_top {
//    return self.fl_attr.y;
    return [[SFrameLayoutAttr alloc] initWithPanel:self layoutAttr:MASAttributeTop];
}

- (SFrameLayoutAttr *)fl_left {
//    return self.fl_attr.x;
    return [[SFrameLayoutAttr alloc] initWithPanel:self layoutAttr:MASAttributeLeft];
}

- (SFrameLayoutAttr *)fl_bottom {
//    return self.fl_attr.y + self.fl_attr.height;
    return [[SFrameLayoutAttr alloc] initWithPanel:self layoutAttr:MASAttributeBottom];
}

- (SFrameLayoutAttr *)fl_width {
//    return self.fl_attr.width;
    return [[SFrameLayoutAttr alloc] initWithPanel:self layoutAttr:MASAttributeWidth];
}

- (SFrameLayoutAttr *)fl_height {
//    return self.fl_attr.height;
    return [[SFrameLayoutAttr alloc] initWithPanel:self layoutAttr:MASAttributeHeight];
}

- (SFrameLayoutAttr *)fl_centerX {
//    return (self.fl_attr.x + (self.fl_attr.width / 2.0f));
    return [[SFrameLayoutAttr alloc] initWithPanel:self layoutAttr:MASAttributeCenterX];
}

- (SFrameLayoutAttr *)fl_centerY {
//    return (self.fl_attr.y + (self.fl_attr.height / 2.0f));
    return [[SFrameLayoutAttr alloc] initWithPanel:self layoutAttr:MASAttributeCenterY];
}

@end
