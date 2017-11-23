//
//  S2Panel.m
//  SQuickUI
//
//  Created by cs on 17/9/19.
//  Copyright © 2017年 cs. All rights reserved.
//

#import "S2Panel.h"
#import "S2Panel+Geometry.h"
#import "SPanelAsyncLayer.h"

@interface S2Panel () <SPanelAsyncLayerProtocol> {
    struct {
        unsigned int layoutNeedUpdate : 1;
        unsigned int contentsNeedFade : 1;
    } _state;
}



@end

@implementation S2Panel

+ (Class)layerClass
{
    return [SPanelAsyncLayer class];
}

#pragma mark - SPanelAsyncLayerProtocol
- (SPanelAsyncLayerDisplayTask *)newAsyncDisplayTask
{
    BOOL contentsNeedFade = _state.contentsNeedFade;
    BOOL layoutNeedUpdate = _state.layoutNeedUpdate;
    BOOL fadeForAsync = _displaysAsynchronously && _fadeOnAsynchronouslyDisplay;
    __block BOOL layoutUpdated = NO;
    
    SPanelAsyncLayerDisplayTask *task = [SPanelAsyncLayerDisplayTask new];
    
    task.willDisplay = ^(CALayer *layer) {
        [layer removeAnimationForKey:@"contents"];
    };
    
    task.display = ^(CGContextRef context, CGSize size, BOOL (^isCancelled)(void)) {
        if (isCancelled()) {
            return;
        }
        
        
        [self drawRect:CGRectMake(0, 0, size.width, size.height) withContext:context];
    };
    
    return task;
}

- (void)_updateIfNeed
{
    if (_state.layoutNeedUpdate) {
        _state.layoutNeedUpdate = NO;
        [self.layer setNeedsDisplay];
    }
}

- (void)clearContents
{
    CGImageRef image = (__bridge_retained CGImageRef)(self.layer.contents);
    self.layer.contents = nil;
    if (image) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            CFRelease(image);
        });
    }
}

- (void)setFrame:(CGRect)frame
{
    CGSize oldSize = self.bounds.size;
    [super setFrame:frame];
    CGSize newSize = self.bounds.size;
    if (!CGSizeEqualToSize(oldSize, newSize)) {
        if (_displaysAsynchronously && _clearContentsBeforeAsynchronouslyDisplay) {
            [self clearContents];
        }
        
        [self.layer setNeedsDisplay];
    }
}

- (void)setBounds:(CGRect)bounds
{
    CGSize oldSize = self.bounds.size;
    [super setBounds:bounds];
    CGSize newSize = self.bounds.size;
    if (!CGSizeEqualToSize(oldSize, newSize)) {
        
        if (_displaysAsynchronously && _clearContentsBeforeAsynchronouslyDisplay) {
            [self clearContents];
        }
        [self.layer setNeedsDisplay];
    }
}


- (void)renderWithContext:(CGContextRef)context withRect:(CGRect)rect
{
    BOOL haveDrawBorder = NO;
    
    //设置背景色
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    
    //如果有边框设置边框属性
    if (self.layer.borderColor && self.layer.borderWidth > 0) {
        CGContextSetStrokeColorWithColor(context, self.layer.borderColor);
        CGContextSetLineWidth(context, self.layer.borderWidth);
        haveDrawBorder = YES;
    }
    
    //如果有圆角画圆角
    if (self.layer.cornerRadius > 0) {
        CGSize corSize = CGSizeMake(self.layer.cornerRadius, self.layer.cornerRadius);
        UIBezierPath *berpath = [UIBezierPath bezierPathWithRoundedRect:self.frame byRoundingCorners:UIRectCornerAllCorners cornerRadii:corSize];
        CGContextAddPath(context, berpath.CGPath);
        
        //        CGContextClip
    }
    
    if (haveDrawBorder) {
        CGContextDrawPath(context, kCGPathFillStroke);
    } else {
        CGContextFillRect(context, self.frame);
    }
    
    
    //画自己
    [self drawRect:rect withContext:context];
    
    //画子节点
//    CGRect chgRect = rect;
//    if ([self isKindOfClass:NSClassFromString(@"SLabel")]) {
//        chgRect = CGRectMake(rect.origin.x, rect.origin.y, self.width, self.height);
//    }
//    
//    for (S2Panel *subPanel in self.subviews) {
//        if ([subPanel isKindOfClass:[S2Panel class]]) {
//            [subPanel renderWithContext:context withRect:chgRect];
//        }
//        
//    }
}

- (void)drawRect:(CGRect)rect withContext:(CGContextRef)context
{
    
}




- (void)renderSubsWithContext:(CGContextRef)context withRect:(CGRect)rect
{
    //坐标调整
    CGRect bounds = CGRectMake(self.x + rect.origin.x, self.y + rect.origin.y, rect.size.width, rect.size.height);
    
    //画儿子
    [self.subviews enumerateObjectsUsingBlock:^(S2Panel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj renderWithContext:context withRect:bounds];
    }];
}

@end
