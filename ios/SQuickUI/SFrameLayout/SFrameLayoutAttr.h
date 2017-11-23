//
//  SFrameLayoutAttr.h
//  DrawSelfTest
//
//  Created by cs on 17/9/7.
//  Copyright © 2017年 cs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SFrameLayoutDefine.h"


@class SPanel;
@class SFrameLayoutResultConstraint;

@interface SFrameLayoutAttr : NSObject



@property (nonatomic, strong) SFrameLayoutResultConstraint *item;


@property (nonatomic, weak) SPanel *panel;

@property (nonatomic, assign) MASAttribute layoutAttr;

- (id)initWithPanel:(SPanel *)panel layoutAttr:(MASAttribute)layoutAttr;

@end
