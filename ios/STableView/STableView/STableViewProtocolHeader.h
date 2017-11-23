//
//  GGCSTableFrameProtocol.h
//  STableViewFrame
//
//  Created by cs on 16/10/12.
//  Copyright © 2016年 cs. All rights reserved.
//





//#import "STableViewDataSource.h"
#import <UIKit/UIKit.h>

@class STableViewCellModel;
@class STableViewDataSource;
@class STableViewCell;
@class STableView;

/*========================================*
 *  tableViewCell要实现该协议
 *========================================*/
@protocol STableViewCellDelegate <NSObject>

@optional
/**
 *  cell中自定义控件添加的地方
 *
 *  @param tableCell 基类cell
 *
 */
- (void)requestInitView:(STableViewCell *)tableCell;

@required
/**
 *  cell中控件的数据配置
 *
 *  @param tableCell 基类cell
 *  @param model 数据源model
 *
 */
- (void)requestConfigurationItem:(STableViewCell *)tableCell model:(STableViewCellModel *)model;

@end


/*========================================*
 *  数据源相关协议
 *========================================*/
@protocol STableViewDataSourceDelegate <NSObject>

@optional
/**
 *  如果cell都是同样大小的话，可以设置一个原型cell，以便按此模板自动计算高度
 *
 *  @param dataSource 数据源
 *  @param indexPath 位置
 *
 *  @return 原型cell
 */
- (STableViewCell *)requestCellPrototype:(STableViewDataSource*)dataSource AtIndexPath:(NSIndexPath *)indexPath;

/**
 *  cell高度获取
 *
 *  @param dataSource 数据源
 *  @param indexPath cell所在位置
 *
 *  @return cell高度
 */
- (CGFloat)requestCellHeight:(STableViewDataSource*)dataSource AtIndexPath:(NSIndexPath *)indexPath;

/**
 *  cell实例化的类模板数组
 *
 *  @param dataSource 数据源
 *
 *  @return 类数组
 */
- (NSArray *)requestCellClass:(STableViewDataSource*)dataSource;

/**
 *  初始化可以在此浓
 *
 *  @param dataSource 数据源
 *
 */
- (void)requestInit:(STableViewDataSource*)dataSource;

@end


/*========================================*
 *  刷新控件协议
 *========================================*/
@protocol STableViewRefreshDelegate <NSObject>

@optional
/**
 *  下拉刷新协议
 *
 *  @param tableView tableView
 *  @param blockRet 回调
 *
 */
- (void)requestMoreData:(STableView *)tableView retBlock:(void(^)(int type))blockRet;

/**
 *  上拉刷新协议
 *
 *  @param tableView tableView
 *  @param blockRet 回调
 *
 */
- (void)requestInitData:(STableView *)tableView retBlock:(void(^)(int type))blockRet;

@end


typedef NS_ENUM(NSInteger, STableDataConfigType){
    STableDataConfigUp,
    STableDataConfigDown
};


/*========================================*
 *  原始数据处理协议
 *========================================*/
@protocol STableViewDataReformer <NSObject>

@optional
/**
 *  数据处理
 *
 *  @param dataSource 数据源类
 *  @param oriData 原始数据
 *  @param type 上下拉刷新状态
 *
 *  @return 自定义数据返回
 */
- (id)reformDataSource:(STableViewDataSource*)dataSource withData:(id)oriData withType:(STableDataConfigType)type;

@end


/*========================================*
 *  错误处理代理方法，如果要错误处理可以实现该协议
 *========================================*/
@protocol STableViewDataErrorDelegate <NSObject>

@optional
/**
 *  错误处理
 *
 *  @param dataSource 数据源类
 *  @param oriData 原始数据
 *  @param type 上下拉刷新状态
 *
 *  @return 错误状态
 */
- (BOOL)handleError:(STableViewDataSource *)dataSource withData:(id)oriData withType:(NSInteger)type;

@end

