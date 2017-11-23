//
//  STabViewParams.m
//  STabView
//
//  Created by cs on 16/10/23.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "STabViewParams.h"


@implementation STabViewParams

+ (instancetype)tabViewParams
{
    STabViewParams *params = [[[self class] alloc] init];
    [params setupValue];
    return params;
}

- (void)setupValue
{
    _tabIndicator = S_Configuration.tabIndicator;
    _tabMask = S_Configuration.tabMask;
    _tabIndicatorEqualTitleWidth = S_Configuration.tabIndicatorEqualTitleWidth;

    _tabIndicatorHeight = S_Configuration.tabIndicatorHeight;
    _tabHeight = S_Configuration.tabHeight;

    _tabIndicatorBackgroundHeight = S_Configuration.tabIndicatorBackgroundHeight;
    _tabindicatorBackgroundOffset = S_Configuration.tabindicatorBackgroundOffset;

    _tabTitleFont = S_Configuration.tabTitleFont;

    _tabBackgroundColor = S_Configuration.tabBackgroundColor;

    _tabIndicatorColor = S_Configuration.tabIndicatorColor;
    _tabIndicatorBackgroundColor = S_Configuration.tabIndicatorBackgroundColor;

    _tabTitleNormalColor = S_Configuration.tabTitleNormalColor;
    _tabMaskColor = S_Configuration.tabMaskColor;
    
    _preLoad = S_Configuration.preLoad;
    _autoAdjustsScrollViewInsets = S_Configuration.autoAdjustsScrollViewInsets;
    
    _tabTopOffset = S_Configuration.tabTopOffset;
    

    _tabIndicatorImageMode = S_Configuration.tabIndicatorImageMode;
    
}


- (CGFloat)tabIndicatorBackgroundHeight
{
    if (_tabIndicatorHeight > _tabIndicatorBackgroundHeight) {
        _tabIndicatorBackgroundHeight = _tabIndicatorHeight;
    }
    
    return _tabIndicatorBackgroundHeight;
}
//- (CGFloat)tabIndicatorHeight
//{
//    if (!self.tabIndicator) {
//        return 0;
//    }
//    
//    if (_tabIndicatorHeight > _tabIndicatorBackgroundHeight) {
//        _tabIndicatorBackgroundHeight = _tabIndicatorHeight;
//    }
//    
//    return _tabIndicatorHeight;
//}
@end

@implementation STabViewAutoParams
- (void)setupValue
{
    [super setupValue];
    
    _tabMargin = S_Configuration.tabMargin;
    _titleAutoFill = S_Configuration.titleAutoFill;
}
@end
@implementation STabViewEqualParams

@end

@implementation STabViewFixedParams

- (void)setupValue
{
    [super setupValue];
    _tabWidth = S_Configuration.tabWidth;
    _tabIndicatorWidth = S_Configuration.tabIndicatorWidth;
}

- (CGFloat)tabWidth
{
    if (self.tabIndicatorWidth > 1 && _tabWidth < self.tabIndicatorWidth) {
        self.tabIndicatorWidth = _tabWidth;
    }
    
    return _tabWidth;
}

- (void)setTabIndicatorWidth:(CGFloat)tabIndicatorWidth
{
    if(!self.tabIndicator) {
        _tabIndicatorWidth = 0;
    } else {
        if (tabIndicatorWidth > 1 && self.tabWidth < tabIndicatorWidth) {
            _tabIndicatorWidth = self.tabWidth;
        } else {
            _tabIndicatorWidth = tabIndicatorWidth;
        }
        
        self.tabIndicatorEqualTitleWidth = NO;
    }
}

@end
