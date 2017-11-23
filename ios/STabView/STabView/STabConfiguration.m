//
//  STabConfiguration.m
//  STabViewDemo
//
//  Created by cs on 16/11/29.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "STabConfiguration.h"

@implementation STabConfiguration

+ (instancetype)shareInstance
{
    static STabConfiguration *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [STabConfiguration new];
    });
    
    return config;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupValue];
    }
    
    return self;
}

- (void)setupValue
{
    _tabIndicator = YES;
    _tabMask = YES;
    _tabIndicatorEqualTitleWidth = YES;
    
    _tabIndicatorHeight = 1.0;
    _tabHeight = 40.0;
    
    _tabIndicatorBackgroundHeight = 1.0;
    _tabindicatorBackgroundOffset = 1.0;
    
    _tabTitleFont = [UIFont systemFontOfSize:14];
    
    _tabBackgroundColor = [UIColor lightGrayColor];
    
    _tabIndicatorColor = [UIColor greenColor];
    _tabIndicatorBackgroundColor = [UIColor blueColor];
    
    _tabTitleNormalColor = [UIColor whiteColor];
    _tabMaskColor = [UIColor redColor];
    
    _preLoad = NO;
    _autoAdjustsScrollViewInsets = YES;
    
    _tabTopOffset = 0;
    
    _tabMargin = 20;
    _titleAutoFill = YES;
    
    _tabWidth = 0;
    _tabIndicatorWidth = 0;
    _tabIndicatorImageMode = STabIndicatorImageModeNone;
}

@end
