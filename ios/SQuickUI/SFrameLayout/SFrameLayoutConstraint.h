//
//  SConstraint.h
//  DrawSelfTest
//
//  Created by cs on 17/9/7.
//  Copyright © 2017年 cs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SFrameLayoutAttr.h"

#import "SFrameLayoutDefine.h"

@class SFrameLayoutMaker;


@interface SFrameLayoutResultConstraint : NSObject

@property (nonatomic, assign, readonly) CGRect out_frame;

@property (nonatomic, strong) SFrameLayoutAttr *secondAttr;

@property (nonatomic, assign) CGFloat layoutConstant;

- (void (^)(CGFloat offset))offset;

@end




@interface SFrameLayoutConstraint : NSObject <NSCopying>

- (SFrameLayoutResultConstraint * (^)(id attr))equalTo;

- (SFrameLayoutResultConstraint * (^)(id attr))fl_equalTo;

- (void)install;

- (void)uninstall;

- (id)initWithAttr:(SFrameLayoutAttr *)attr;

@property (nonatomic, strong, readonly) SFrameLayoutAttr *attr;

@property (nonatomic, assign, readonly) BOOL podValue;

@property (nonatomic, assign, readonly) SFL_Type type;

@end
