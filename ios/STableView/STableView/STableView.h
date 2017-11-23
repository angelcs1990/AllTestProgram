//
//  GGCSBaseTableView.h
//  STableViewFrame
//
//  Created by cs on 16/10/13.
//  Copyright © 2016年 cs. All rights reserved.
//




#import "STableViewProtocolHeader.h"
#import "STableViewConfig.h"

#define CS_INVALID_VALUE (-1)

@class STableViewDelegateProxy;
@class STableViewDataSource;


@interface STableView : UITableView

/**
 *  各种处理操作的代理
 */
@property (nonatomic, strong) STableViewDelegateProxy *cs_DelegatesProxy;

/**
 *  如果要实现原生的数据源方法，就要设置该值了
 */
@property (nonatomic, strong) STableViewDataSource *cs_DataSource;

/**
 *  cell的类
 */
@property (nonatomic, strong) NSArray<Class> *cs_CellClasses;
//@property (nonatomic, strong) STableViewConfig *cs_Config;

/**
 *  数据源配置
 *
 *  @param data 数据源
 *  @param type 上拉还是下拉的数据类型
 *
 *  @return 自定义返回值
 */
- (id)csConfigurationData:(id)data type:(STableDataConfigType)type;

@end
