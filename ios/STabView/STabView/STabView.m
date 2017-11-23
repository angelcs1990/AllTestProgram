//
//  STabView.m
//  STabView
//
//  Created by cs on 16/7/12.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "STabView.h"

#pragma makr -
#pragma mark - STabView
@interface STabView()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *views;
@property (nonatomic, strong) UIScrollView *contentScrollView;

@end

@implementation STabView

#pragma mark - lifecycle
+ (instancetype)tabView:(NSArray *)titles withViews:(NSArray *)views withFrame:(CGRect)frame
{
    return [self tabView:titles withViews:views initIndex:0 withFrame:frame];
}

+ (instancetype)tabView:(NSArray *)titles withViews:(NSArray *)views initIndex:(NSInteger)index withFrame:(CGRect)frame
{
    NSAssert(titles.count == views.count, @"数据有误");
    
    STabView *tabView = [self tabViewWithFrame:frame];
    
    [tabView.titles addObjectsFromArray:titles];
    [tabView.views addObjectsFromArray:views];
    
    [tabView baseTabViewSetupUI];
    tabView.initIndex = index;
    
    return tabView;
}

- (void)setTabTitles:(NSArray<NSString *> *)titles withViews:(NSArray<UIView *> *)views
{
    NSAssert(self.params != nil, @"请先设置好param");
    
    if (titles == nil || views == nil) {
        return;
    }
    
    [self.titles removeAllObjects];
    [self.views removeAllObjects];
    
    [self.titles addObjectsFromArray:titles];
    [self.views addObjectsFromArray:views];
    
    [self baseTabViewSetupUI];
    [self baseTabViewReloadValue:self.params];
}

- (void)addTabTitle:(NSString *)title withView:(UIView *)view
{
    if (title == nil || view == nil) {
        return;
    }
    

    [self.views addObject:view];
    [self.contentScrollView addSubview:view];
    [self baseTabViewSetupButton:title];

    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - SBaseTabViewProtocol
- (void)tabViewRequestCallFun:(SBaseTabView *)parentView withIndex:(NSInteger)index
{
    [self callbackFun:index];
}

- (void)tabViewRequestLayoutSubViews:(SBaseTabView *)parentView
{
    self.contentScrollView.contentSize = CGSizeMake(self.titles.count * self.bounds.size.width, 0);
    
    for (int i = 0; i < self.titles.count; ++i) {
        UIView *view = [self.views objectAtIndex:i];
        view.frame = CGRectMake(i * self.contentScrollView.frame.size.width, 0, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height);
    }
}

- (void)tabViewRequestSetupUI:(SBaseTabView *)parentView
{    
    for (int i = 0; i < self.titles.count; ++i) {
        UIView *view = [self.views objectAtIndex:i];
        [self.contentScrollView addSubview:view];
    }
}

- (void)tabViewRequestSetupData:(SBaseTabView *)parentView
{
    self.preIndex = -1;
}

- (UIScrollView *)tabViewRequestContentView
{
    return self.contentScrollView;
}

#pragma mark - 私有方法
- (void)callbackFun:(NSInteger)index
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabView:didTabIndex:)]) {
        [self.delegate tabView:self didTabIndex:index];
    }
}


#pragma mark - getter
- (UIView *)currentView
{
    if (self.currentIndex < self.views.count) {
        return self.views[self.currentIndex];
    }
    return nil;
}

- (UIView *)preView
{
    if (self.preIndex < self.views.count) {
        return self.views[self.preIndex];
    }
    return nil;
}

- (NSMutableArray *)views
{
    if (_views == nil) {
        _views = [NSMutableArray array];
    }
    
    return _views;
}

- (UIScrollView *)contentScrollView
{
    if (_contentScrollView == nil) {
        _contentScrollView = [UIScrollView new];
        
        _contentScrollView.backgroundColor = [UIColor greenColor];
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.bounces = NO;
        _contentScrollView.delegate = self;
        _contentScrollView.contentSize = CGSizeMake(self.titles.count * self.bounds.size.width, 0);
    }
    
    return _contentScrollView;
}

@end
