//
//  SPanelAsyncLayer.m
//  SQuickUI
//
//  Created by cs on 17/9/19.
//  Copyright © 2017年 cs. All rights reserved.
//

#import "SPanelAsyncLayer.h"
#import <libkern/OSAtomic.h>
#import <stdatomic.h>


@interface _Senginel : NSObject

@property (nonatomic, readonly) int32_t value;

- (int32_t)increase;

@end

@implementation _Senginel
{
    int32_t _value;
}

- (int32_t)value
{
    return _value;
}

- (int32_t)increase
{
    if (_value >= INT32_MAX) {
        OSAtomicXor32Barrier(_value, &_value);
    }
    
    return OSAtomicIncrement32Barrier(&_value);
}

@end






@implementation SPanelAsyncLayer
{
    _Senginel *_sentin;
}

- (instancetype)init
{

    self = [super init];
    static CGFloat scale;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scale = [UIScreen mainScreen].scale;
    });
    self.contentsScale = scale;
    _displaysAsynchronously = YES;
    _sentin = [_Senginel new];
    
    return self;
}

- (void)dealloc
{
    [_sentin increase];
}

- (void)setNeedsDisplay
{
    [self _cancelAsyncDisplay];
    [super setNeedsDisplay];
}

- (void)display
{
    [self _displayAsync:_displaysAsynchronously];
}

- (void)_displayAsync:(BOOL)async
{
    __strong id<SPanelAsyncLayerProtocol> delegate = (id)self.delegate;
    SPanelAsyncLayerDisplayTask *task = [delegate newAsyncDisplayTask];
    if (!task.display) {
        self.contents = nil;
        return;
    }
    
    if (async) {
        if (task.willDisplay) {
            task.willDisplay(self);
        }
        
        _Senginel *sent = _sentin;
        int32_t value = _sentin.value;
        BOOL (^isCancelled)() = ^BOOL(){
            return value != sent.value;
        };
        
        CGSize size = self.bounds.size;
        BOOL opaque = self.opaque;
        CGFloat scale = self.contentsScale;
        CGColorRef backgroundColor = (opaque && self.backgroundColor) ? CGColorRetain(self.backgroundColor) : NULL;
        if (size.width < 1 || size.height < 1) {
            CGImageRef image = (__bridge_retained CGImageRef)(self.contents);
            self.contents = nil;
            if (image) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                    CFRelease(image);
                });
            }
            if (task.didDisplay)
                task.didDisplay(self, YES);
            CGColorRelease(backgroundColor);
            return;
        }
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            if (isCancelled()) {
                CGColorRelease(backgroundColor);
                return;
            }
            
            UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
            CGContextRef context = UIGraphicsGetCurrentContext();
            if (opaque) {
                CGContextSaveGState(context);
                if (!backgroundColor || CGColorGetAlpha(backgroundColor) < 1) {
                    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
                    CGContextAddRect(context, CGRectMake(0, 0, size.width * scale, size.height * scale));
                    CGContextFillPath(context);
                }
                
                if (backgroundColor) {
                    CGContextSetFillColorWithColor(context, backgroundColor);
                    CGContextAddRect(context, CGRectMake(0, 0, size.width * scale, size.height * scale));
                    CGContextFillPath(context);
                }
                CGContextRestoreGState(context);
                CGColorRelease(backgroundColor);
            }
            
            task.display(context, size, isCancelled);
            if (isCancelled()) {
                UIGraphicsEndImageContext();
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (task.didDisplay) {
                        task.didDisplay(self, NO);
                    }
                });
                return;
            }
            
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            if (isCancelled()) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (task.didDisplay) {
                        task.didDisplay(self, NO);
                    }
                });
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (isCancelled()) {
                    if (task.didDisplay)
                        task.didDisplay(self, NO);
                } else {
                    self.contents = (__bridge id)(image.CGImage);
                    if (task.didDisplay)
                        task.didDisplay(self, YES);
                }
            });
        });
    } else {
        [_sentin increase];
        if (task.willDisplay) task.willDisplay(self);
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, self.contentsScale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        if (self.opaque) {
            CGSize size = self.bounds.size;
            size.width *= self.contentsScale;
            size.height *= self.contentsScale;
            CGContextSaveGState(context); {
                if (!self.backgroundColor || CGColorGetAlpha(self.backgroundColor) < 1) {
                    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
                    CGContextAddRect(context, CGRectMake(0, 0, size.width, size.height));
                    CGContextFillPath(context);
                }
                if (self.backgroundColor) {
                    CGContextSetFillColorWithColor(context, self.backgroundColor);
                    CGContextAddRect(context, CGRectMake(0, 0, size.width, size.height));
                    CGContextFillPath(context);
                }
            } CGContextRestoreGState(context);
        }
        task.display(context, self.bounds.size, ^{return NO;});
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.contents = (__bridge id)(image.CGImage);
        if (task.didDisplay) task.didDisplay(self, YES);
    }
}

- (void)_cancelAsyncDisplay
{
    [_sentin increase];
}

@end


@implementation SPanelAsyncLayerDisplayTask


@end
