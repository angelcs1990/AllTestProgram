//
//  SBaseTabView.h
//  STabViewDemo
//
//  Created by cs on 16/11/2.
//  Copyright © 2016年 cs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STabViewParams.h"

typedef NS_ENUM(NSInteger, STabTitleWidthType)
{
    //自动计算宽度
    STabTitleWidthAuto,
    //等值宽度
    STabTitleWidthEqual,
    //固定宽度 (此模式下要自己设置宽度）
    STabTitleWidthFixed,
};

#define STABVIEW_BUTTON_TAG_BASE 100

//(objc_subclassing_restricted) 禁止继承
@class SBaseTabView;

@protocol SBaseTabViewProtocol <NSObject>

@required
- (void)tabViewRequestSetupUI:(SBaseTabView *)parentView;
- (void)tabViewRequestSetupData:(SBaseTabView *)parentView;
- (void)tabViewRequestLayoutSubViews:(SBaseTabView *)parentView;
- (void)tabViewRequestCallFun:(SBaseTabView *)parentView withIndex:(NSInteger)index;
- (UIScrollView *)tabViewRequestContentView;


@end

@interface SBaseTabView : UIView

@property (nonatomic, strong) UIImageView *imageViewLine;
@property (nonatomic, strong) UIView *selectedView;
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *titleWidths;
@property (nonatomic, strong) UIView *more;
@property (nonatomic, strong) UIScrollView *scrollviewHeader;
@property (nonatomic, strong) NSMutableArray *splitsArray;
@property (nonatomic) STabTitleWidthType tabWidthType;

@property (nonatomic) NSInteger currentIndex;
@property (nonatomic) NSInteger preIndex;
@property (nonatomic) NSInteger initIndex;
@property (nonatomic) BOOL clickedState;


@property (nonatomic, strong) STabViewParams *params;
@property (nonatomic, weak) UIScrollView *scrollContentView;


/**
 *  是否正在划动
 */
@property (nonatomic) BOOL isScrolling;

+ (instancetype)tabViewWithFrame:(CGRect)frame;
+ (instancetype)tabViewWithFrame:(CGRect)frame withDefaultView:(UIView *)view;
//- (instancetype)initWithFrame:(CGRect)frame NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithFrame:(CGRect)frame withDefaultView:(UIView *)view NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCoder:(NSCoder *)aDecoder UNAVAILABLE_ATTRIBUTE;

- (UIView*)duplicate:(UIView*)view;
- (void)addTabMoreView:(UIView *)view;

- (void)baseTabViewMoveMaskToIndex:(CGFloat)index;
- (void)baseTabViewSetupButton:(NSString *)title;
- (void)baseTabViewReloadValue:(STabViewParams *)params;
- (void)baseTabViewSetupUI;

@end
