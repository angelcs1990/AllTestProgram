//
//  GGCSTableBaseCell.h
//  GameGuess_CN
//
//  Created by cs on 16/7/15.
//  Copyright © 2016年 gaoqi. All rights reserved.
//


#import <UIKit/UIKit.h>

@class STableViewCellModel;
@class STableViewCell;

@interface STableViewCell : UITableViewCell

/**
 *  数据model
 */
@property (nonatomic, strong, readonly) STableViewCellModel *cs_model;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

/**
 *  重用cell的获取
 *
 *  @param tableView tableView对象
 *
 *  @return 获取到的cell
 */
+ (STableViewCell *)csCellWithTableView:(STableView *)tableView;

/**
 *  cell数据配置
 *
 *  @param model 数据
 *
 */
- (void)csConfigurationItem:(STableViewCellModel *)model;

@end
