//
//  SPanel.h
//  SQuickUI
//
//  Created by cs on 17/9/13.
//  Copyright © 2017年 cs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#import "SPanelDefine.h"

@interface SPanel : NSObject

@property (nonatomic) BOOL userInteractionEnabled;

@property (nonatomic) NSInteger tag;

- (instancetype)initWithFrame:(CGRect)frame;

@end

@interface SPanel (SPanelGeometry)

@property (nonatomic) CGRect frame;

@property (nonatomic) CGRect bounds;

@property (nonatomic) CGPoint center;

- (SPanel *)hitTest:(CGPoint)point;

- (BOOL)pointInside:(CGPoint)point;

@end


@interface SPanel (SPanelHierarchy)

@property (nonatomic, weak, readonly) SPanel *superPanel;

@property (nonatomic, readonly) NSMutableArray<SPanel *> *subNodes;

- (void)removeFromSuperpanel;
- (void)addSubPanel:(SPanel *)panel;

@end

@interface SPanel (SPanelRendering)

@property (nonatomic) CGFloat cornerRadius;

@property (nonatomic) CGFloat borderWidth;

@property (nonatomic) UIColor *borderColor;

@property (nonatomic) CGFloat alpha;

@property (nonatomic) BOOL hidden;

@property (nonatomic) BOOL clipsToBounds;

@property(nonatomic)  UIViewContentMode contentMode;

@property (nonatomic, copy) UIColor *backgroundColor;

@property (nonatomic, strong) UIImage *imageContent;

@property (nonatomic, strong) UIView *destView;

//这个是给系统调用了
- (void)renderWithContext:(CGContextRef)context withRect:(CGRect)rect;

//这个是重载实现
- (void)drawRect:(CGRect)rect withContext:(CGContextRef)context;

- (void)setNeedUpdate;

@end
