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

@class SReuseTabView;
@class SReuseTabViewCell;

@protocol SReuseTabViewDelegate <NSObject>

@optional
- (void)tabView:(SReuseTabView *)tabView didTabView:(SReuseTabViewCell *)didView atIndex:(NSInteger)tabIndex;

@end




@interface SReuseTabView : SBaseTabView<SBaseTabViewProtocol>

+ (instancetype)tabView:(NSArray<NSString *> *)titles withCellClasses:(NSArray<Class> *)cellClasses withFrame:(CGRect)frame;
+ (instancetype)tabView:(NSArray<NSString *> *)titles withCellClasses:(NSArray<Class> *)cellClasses initIndex:(NSInteger)index withFrame:(CGRect)frame;

- (void)setTabTitles:(NSArray<NSString *> *)titles withClasses:(NSArray<Class> *)cellClasses;
- (void)addTabTitle:(NSString *)title withClass:(Class)cellClass;

@property (nonatomic, weak) id<SReuseTabViewDelegate> delegate;

@end
