//
//  GGCSGroupsCache.h
//  STableViewFrame
//
//  Created by cs on 16/10/13.
//  Copyright © 2016年 cs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDataSourceGroup : NSObject

/**
 *  组的title
 */
@property (nonatomic, copy) NSString *cs_GroupName;


/**
 *  组的tail
 */
@property (nonatomic, copy) NSString *cs_GroupDesc;


/**
 *  该组中数据的数量
 */
@property (nonatomic, readonly) NSUInteger count;

/**
 *  根据title和tail实例化组对象，可以为nil
 *
 *  @param title 组的标题
 *  @param desc 组的尾部标题
 *
 *  @return 组的实例化对象
 */
+ (instancetype)csGroupWithName:(NSString *)title desc:(NSString *)desc;

/**
 *  根据indexpath查找数据Model
 *
 *  @param data 将要增加的数据
 *
 */
- (void)csAddData:(id)data;

/**
 *  根据indexpath查找数据Model
 *
 *  @param index 数据位置
 *
 *  @return 某条数据的model
 */
- (id)csObjectAtIndex:(NSUInteger)index;

@end


//////////////
@interface SDataSourceGroups : NSObject

@property (nonatomic, strong) NSMutableArray *cs_GroupArray;
@property (nonatomic, strong) NSMapTable *cs_FastCache;

/**
 *  组对象实例化
 *
 *
 *  @return 实例化的对象
 */
+ (instancetype)csGroups;

/**
 *  组中数据清空
 *
 *
 */
- (void)csClearAll;

/**
 *  添加数据到首位
 *
 *  @param group 组
 *
 */
- (void)csInsertGroups:(SDataSourceGroup *)group;

/**
 *  添加数据到尾部
 *
 *  @param group 组
 *
 */
- (void)csAddGroups:(SDataSourceGroup *)group;

/**
 *  根据关键词查找组数据
 *
 *  @param key 关键词
 *
 *  @return 某组数据
 */
- (SDataSourceGroup *)csGroupFromKey:(NSString *)key;

/**
 *  根据序数查找组数据
 *
 *  @param section 组数据序数
 *
 *  @return 某组数据
 */
- (SDataSourceGroup *)csGroupAtSection:(NSUInteger)section;

/**
 *  添加数据到某组中去
 *
 *  @param data 将用添加的数据
 *  @param index 组的序号
 *
 */
- (void)csAddObject:(id)data atGroupIndex:(NSUInteger)index;

/**
 *  某组数据的数量
 *
 *  @param index 组的序号
 *
 *  @return 组中数据的数量
 */
- (NSUInteger)csObjectCountAtGroupIndex:(NSUInteger)index;

/**
 *  组的数量
 *
 *
 *  @return 组的数量
 */
- (NSUInteger)csGroupCount;

/**
 *  根据indexpath查找具体数据
 *
 *  @param indexPath 数据位置
 *
 *  @return 某条数据
 */
- (id)csObjectForIndexPath:(NSIndexPath *)indexPath;

@end
