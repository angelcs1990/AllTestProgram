//
//  SPanel.m
//  SQuickUI
//
//  Created by cs on 17/9/13.
//  Copyright © 2017年 cs. All rights reserved.
//

#import "SPanel.h"
#import "SPanel+Geometry.h"

#import <objc/runtime.h>
#import "SDrawBuffer.h"

@interface SPanel ()

//Geometry
@property (nonatomic) CGRect frame;

@property (nonatomic) CGRect bounds;

@property (nonatomic) CGPoint center;

//Hierarchy
@property (nonatomic, weak, readwrite) SPanel *superPanel;

@property (nonatomic, strong, readwrite) NSMutableArray<SPanel *> *subNodes;

//rendering
@property (nonatomic) CGFloat cornerRadius;

@property (nonatomic) CGFloat borderWidth;

@property (nonatomic) UIColor *borderColor;

@property (nonatomic) CGFloat alpha;

@property (nonatomic) BOOL hidden;

@property (nonatomic) BOOL clipsToBounds;

@property(nonatomic)  UIViewContentMode contentMode;

@property (nonatomic, copy) UIColor *backgroundColor;

@property (nonatomic, strong) UIView *destView;

@end

@implementation SPanel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        self.frame = frame;
        self.size = frame.size;
        self.center = CGPointMake(self.x + self.width / 2.0f, self.y + self.height / 2.0f);
    
        [self setupInit];
    }
    
    return self;
}

- (void)setupInit
{
    self.userInteractionEnabled = YES;
    self.tag = 0;
}

@end


#pragma mark - SPanelRendering
@implementation SPanel (SPanelRendering)

- (void)renderWithContext:(CGContextRef)context withRect:(CGRect)rect
{
    BOOL haveDrawBorder = NO;
    
    //设置背景色
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    
    //如果有边框设置边框属性
    if (self.borderColor && self.borderWidth > 0) {
        CGContextSetStrokeColorWithColor(context, self.borderColor.CGColor);
        CGContextSetLineWidth(context, self.borderWidth);
        haveDrawBorder = YES;
    }
    
    //如果有圆角画圆角
    if (self.cornerRadius > 0) {
        CGSize corSize = CGSizeMake(self.cornerRadius, self.cornerRadius);
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
    CGRect chgRect = rect;
    if ([self isKindOfClass:NSClassFromString(@"SLabel")]) {
        chgRect = CGRectMake(rect.origin.x, rect.origin.y, self.width, self.height);
    }
    
    for (SPanel *subPanel in self.subNodes) {
        [subPanel renderWithContext:context withRect:chgRect];
    }
}

- (void)drawRect:(CGRect)rect withContext:(CGContextRef)context
{
    
}




- (void)renderSubsWithContext:(CGContextRef)context withRect:(CGRect)rect
{
    //坐标调整
    CGRect bounds = CGRectMake(self.x + rect.origin.x, self.y + rect.origin.y, rect.size.width, rect.size.height);
    
    //画儿子
    [self.subNodes enumerateObjectsUsingBlock:^(SPanel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj renderWithContext:context withRect:bounds];
    }];
}
- (void)setNeedUpdate
{
    [[SDrawBuffer shareInstance] addPanel:self];
}

- (void)setImageContent:(UIImage *)imageContent
{
    objc_setAssociatedObject(self, @selector(imageContent), imageContent, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)imageContent
{
    return objc_getAssociatedObject(self, _cmd);
}

@end




#pragma mark - SPanelHierarchy
@implementation SPanel (SPanelHierarchy)

- (void)removeFromSuperpanel
{
    [self.superPanel.subNodes removeObject:self];
    
    _superPanel = nil;
}

- (void)addSubPanel:(SPanel *)panel
{
    panel.superPanel = self;
    
    [self.subNodes addObject:panel];
}

@end




#pragma mark - SPanelGeometry
@implementation SPanel (SPanelGeometry)

- (SPanel *)hitTest:(CGPoint)point
{
    if (!self.userInteractionEnabled || self.hidden || self.alpha <= 0.01) {
        return nil;
    }
    
    if ([self pointInside:point]) {
        CGPoint subPt = CGPointMake(point.x - self.x, point.y - self.y);
        for (SPanel *subPanel in self.subNodes) {
            SPanel *hitTestPanel = [subPanel hitTest:subPt];
            if (hitTestPanel) {
                return hitTestPanel;
            }
        }
        
        return self;
    }
    return nil;
}

- (BOOL)pointInside:(CGPoint)point
{
    if (CGRectContainsPoint(self.frame, point)) {
        return YES;
    }
    
    return NO;
}

- (CGRect)bounds
{
    return CGRectMake(0, 0, self.width, self.height);
}

- (CGPoint)center
{
    return CGPointMake(self.x + self.width / 2.0f, self.y + self.height/ 2.0f);
}

- (void)setBounds:(CGRect)bounds
{
    self.size = bounds.size;
}

- (void)setCenter:(CGPoint)center
{
    self.origin = CGPointMake(center.x - self.width / 2.0f, center.y - self.height / 2.0f);
}

@end
