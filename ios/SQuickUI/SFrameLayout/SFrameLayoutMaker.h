//
//  SFrameLayoutMaker.h
//  DrawSelfTest
//
//  Created by cs on 17/9/7.
//  Copyright © 2017年 cs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SFrameLayoutConstraint.h"

#import "SPanel.h"
#import "SFrameLayoutDefine.h"



@interface SFrameLayoutMaker : NSObject

@property (nonatomic, strong, readonly) SFrameLayoutConstraint *left;
@property (nonatomic, strong, readonly) SFrameLayoutConstraint *top;
@property (nonatomic, strong, readonly) SFrameLayoutConstraint *right;
@property (nonatomic, strong, readonly) SFrameLayoutConstraint *bottom;
@property (nonatomic, strong, readonly) SFrameLayoutConstraint *width;
@property (nonatomic, strong, readonly) SFrameLayoutConstraint *height;
@property (nonatomic, strong, readonly) SFrameLayoutConstraint *centerX;
@property (nonatomic, strong, readonly) SFrameLayoutConstraint *centerY;

@property (nonatomic, strong, readonly) SFrameLayoutConstraint *size;

@property (nonatomic, strong, readonly) SFrameLayoutConstraint *edges;

@property (nonatomic, strong, readonly) SFrameLayoutConstraint *center;

- (void)install;

- (id)initWithView:(SPanel *)view;

- (SFrameLayoutConstraint *)addConstraintWithLayoutAttr:(MASAttribute)layoutAttr ;

@end
