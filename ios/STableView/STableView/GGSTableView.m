//
//  GGCSTableView.m
//  STableViewFrame
//
//  Created by cs on 16/10/13.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "GGSTableView.h"
//#import "GGNoNetworkView.h"
//#import "GGNoDataView.h"

//@import MJRefresh;

/////////////////////////////////////////////////////////
//  普通的tableView
/////////////////////////////////////////////////////////
@implementation GGNormalTableView
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}
- (void)setCsCellClass:(Class)csCellClass
{
    _csCellClass = csCellClass;
    self.cs_CellClasses = @[csCellClass];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    NSLog(@"scroll");
}
@end





/////////////////////////////////////////////////////////
//  带分组的tableView
/////////////////////////////////////////////////////////
@implementation GGGroupTableView

//#pragma mark - 事件
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//}
//
//
//#pragma mark - 私有函数
//- (void)requestInitData
//{
//    if (self.csTableInf && [self.csDelegate respondsToSelector:@selector(requestInitData:retBlock:)]) {
//        [self.csDelegate requestInitData:self retBlock:^(int type) {
//            
//        }];
//    }
//}
//- (void)requestMoreData
//{
//    if (self.csDelegate && [self.csDelegate respondsToSelector:@selector(requestMoreData:retBlock:)]) {
//        [self.csDelegate requestMoreData:self retBlock:^(int type) {
//            
//        }];
//    }
//}
//#pragma mark - setter and getter
//- (void)setCsDelegate:(id<GGCSTableBaseViewDelegate>)csDelegate
//{
//    if (self.csDelegate) {
//        if ([self.csDelegate respondsToSelector:@selector(requestInitData:retBlock:)]) {
//            
//        }
//        if ([self.csDelegate respondsToSelector:@selector(requestMoreData:retBlock:)]) {
//            
//        }
//    }
//}
@end


/////////////////////////////////////////////////////////
//  带上下拉刷新
/////////////////////////////////////////////////////////
@interface GGSTableView()

@end


@implementation GGSTableView

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshUp)];
//        self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshDown)];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.noDataView.frame = self.bounds;
    self.noNetworkView.frame = self.bounds;
}

- (void)refreshUp
{
    if (self.cs_DelegatesProxy.cs_refreshInf && [self.cs_DelegatesProxy.cs_refreshInf respondsToSelector:@selector(requestInitData:retBlock:)]) {
        [self.cs_DelegatesProxy.cs_refreshInf requestInitData:self retBlock:^(int type) {
            //处理返回值
//            //没有网络
//            if (type == GGTableViewStateNoNetwork) {
//                if ([self.cs_DataSource.cs_groups csGroupCount] == 0) {
//                    [self.noNetworkView show];
//                } else {
//                    [self gg_showToastCenter:LOCALIZATION(GG_NetworkError)];
//                }
//            }

        }];
    }
}

- (void)refreshDown
{
    if (self.cs_DelegatesProxy.cs_refreshInf && [self.cs_DelegatesProxy.cs_refreshInf respondsToSelector:@selector(requestInitData:retBlock:)]) {
        [self.cs_DelegatesProxy.cs_refreshInf requestMoreData:self retBlock:^(int type) {
//            //处理返回值
//            if (type == GGTableViewStateNoNetwork) {
//                if ([self.cs_DataSource.cs_groups csGroupCount] == 0) {
//                    [self.noNetworkView show];
//                } else {
//                    [self gg_showToastCenter:LOCALIZATION(GG_NetworkError)];
//                }
//            }
        }];
    }
}
#pragma mark - setter and getter
//- (GGNoNetworkView *)noNetworkView
//{
//    if (_noNetworkView == nil) {
//        GGWeakify(self);
//        _noNetworkView = [GGNoNetworkView noNetworkViewWithBlock:^{
//            GGStrongify(self);
//            [self.noNetworkView hide];
//            [self.mj_header beginRefreshing];
//        }];
//    }
//    
//    return _noNetworkView;
//}
//- (GGNoDataView *)noDataView
//{
//    if (_noDataView == nil) {
//        _noDataView = [GGNoDataView noDataViewWithText:LOCALIZATION(NO_Schedule)];
//    }
//    
//    return _noDataView;
//}


@end
