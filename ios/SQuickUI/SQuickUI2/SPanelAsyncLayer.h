//
//  SPanelAsyncLayer.h
//  SQuickUI
//
//  Created by cs on 17/9/19.
//  Copyright © 2017年 cs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@class SPanelAsyncLayerDisplayTask;

@interface SPanelAsyncLayer : CALayer

@property (nonatomic) BOOL displaysAsynchronously;

@end


@protocol SPanelAsyncLayerProtocol <NSObject>

- (SPanelAsyncLayerDisplayTask *)newAsyncDisplayTask;

@end



@interface SPanelAsyncLayerDisplayTask : NSObject

@property (nullable, nonatomic, copy) void (^willDisplay)(CALayer *layer);

@property (nullable, nonatomic, copy) void (^display)(CGContextRef context, CGSize size, BOOL(^isCancelled)(void));

@property (nullable, nonatomic, copy) void (^didDisplay)(CALayer *layer, BOOL finished);

@end
NS_ASSUME_NONNULL_END
