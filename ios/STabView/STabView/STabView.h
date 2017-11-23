//
//  STabView.h
//  STabView
//
//  Created by cs on 16/7/12.
//  Copyright © 2016年 cs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STabViewParams.h"
#import "SBaseTabView.h"


@class STabView;

@protocol STabViewDelegate <NSObject>

@optional
- (void)tabView:(STabView *)tabView didTabIndex:(NSInteger)tabIndex;

@end





@interface STabView : SBaseTabView<SBaseTabViewProtocol>

+ (instancetype)tabView:(NSArray *)titles withViews:(NSArray *)views withFrame:(CGRect)frame;
+ (instancetype)tabView:(NSArray *)titles withViews:(NSArray *)views initIndex:(NSInteger)index withFrame:(CGRect)frame;

/**
 *  初始化入口
 *
 *  @param titles tab的标题
 *  @param views  tab的内容
 *  @param frame  大小
 *
 *  @return 实例对象
 */
- (void)addTabTitle:(NSString *)title withView:(UIView *)view;
- (void)setTabTitles:(NSArray<NSString *> *)titles withViews:(NSArray<UIView *> *)views;

@property (nonatomic, weak) id<STabViewDelegate> delegate;

@property (nonatomic, weak, readonly) UIView *currentView;

@property (nonatomic, weak, readonly) UIView *preView;

@end
