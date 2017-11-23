//
//  GGCSBaseDataSource+group.h
//  STableViewFrame
//
//  Created by cs on 16/10/13.
//  Copyright © 2016年 cs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STableViewDataSource.h"

@class SDataSourceGroup;

@interface STableViewDataSource (group)

/**
 *  添加组数据到头部
 *
 *  @param group 组数据
 *
 */
- (void)csAddGroupHead:(SDataSourceGroup *)group;

/**
 *  添加组数据到尾部
 *
 *  @param group 组数据
 *
 */
- (void)csAddGroupTail:(SDataSourceGroup *)group;

/**
 *  有多少组数据
 *
 *
 *  @return 数量
 */
- (NSInteger)csGroupCount;

/**
 *  根据key查找组
 *
 *  @param key 关键词
 *
 *  @return 组对象
 */
- (SDataSourceGroup *)csGroupFromKey:(NSString *)key;

/**
 *  根据组的位置查找组数据
 *
 *  @param section 位置
 *
 *  @return 组对象
 */
- (SDataSourceGroup *)csGroupAtSection:(NSUInteger)section;

/**
 *  清除所有数据
 *
 *
 */
- (void)csClearAll;

/**
 *  根据indexpath查找数据Model
 *
 *  @param indexPath 数据位置
 *
 *  @return 某条数据的model
 */
- (STableViewCellModel *)csModelAtIndexPath:(NSIndexPath *)indexPath;

@end
