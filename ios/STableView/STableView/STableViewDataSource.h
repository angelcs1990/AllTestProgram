//
//  GGCSBaseDataSource.h
//  STableViewFrame
//
//  Created by cs on 16/10/13.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "STableViewDelegateProxy.h"

#ifndef GGCSTABLEBASEDATASOURCE_UNVALIDVALUE
#define GGCSTABLEBASEDATASOURCE_UNVALIDVALUE -1
#endif



@class SDataSourceGroups;

@interface STableViewDataSource : NSObject<UITableViewDataSource>

/**
 *  组的缓存
 */
@property (nonatomic, strong) SDataSourceGroups *cs_groups;

/**
 *  每个cell的高度缓存
 */
@property (nonatomic, strong) NSMutableDictionary *cs_cellHeightCache;

/**
 *  cell的类
 */
@property (nonatomic, copy) NSMutableArray *cs_cellClasses;

/**
 *  代理
 */
@property (nonatomic, weak) STableViewDelegateProxy *cs_DelegatesProxy;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

/**
 *  数据源实例
 *
 *
 *  @return 实例对象
 */
+ (instancetype)csDataSource;

/**
 *  原始数据处理
 *
 *  @param data 未经过处理的原始数据
 *  @param type 数据类型（是上拉还是下拉获取的）
 *
 *  @return 自定义返回值
 */
- (id)csConfigurationData:(id)data type:(STableDataConfigType)type;

/**
 *  cell的高度获取
 *
 *  @param tableView tableView对象
 *  @param indexPath cell所在位置
 *
 *  @return 获取到的cell高度
 */
- (CGFloat)csCellHeightForRow:(STableView *)tableView atIndexPath:(NSIndexPath *)indexPath;

/**
 *  同上，只是简化了一些逻辑
 *
 *  @param indexPath cell所在位置
 *
 *  @return 获取到的cell高度
 */
- (CGFloat)csFastQueryCellHeightAtIndexPath:(NSIndexPath *)indexPath;

@end
