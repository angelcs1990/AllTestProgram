//
//  GGCSTableView.h
//  STableViewFrame
//
//  Created by cs on 16/10/13.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "STableViewHeader.h"


//@class GGNoDataView;
//@class GGNoNetworkView;

/////////////////////////////////////////////////////////
//  普通的tableView
/////////////////////////////////////////////////////////
@interface GGNormalTableView : STableView
@property (nonatomic, strong) Class csCellClass;
@end



/////////////////////////////////////////////////////////
//  带分组的tableView
/////////////////////////////////////////////////////////
@interface GGGroupTableView : STableView
//@property (nonatomic, weak) id<GGCSTableBaseViewDelegate> csDelegate;
@end


/////////////////////////////////////////////////////////
//  能上下拉刷新的tableView,自己实现
/////////////////////////////////////////////////////////
typedef NS_ENUM(NSInteger, GGTableViewState){
    GGTableViewStateNoData,
    GGTableViewStateNoNetwork,
    GGTableViewStateOk
};

@interface GGSTableView : STableView<UITableViewDelegate>

@property (nonatomic, strong) UIView *noDataView;
@property (nonatomic, strong) UIView *noNetworkView;

@end
