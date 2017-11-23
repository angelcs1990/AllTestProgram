//
//  GGCSTableFrameInterface.h
//  STableViewFrame
//
//  Created by cs on 16/10/12.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "STableViewProtocolHeader.h"


BOOL MethodSwizzle(Class c, SEL oriSEl, SEL newSel);


@interface STableViewDelegateProxy : NSObject<STableViewDataSourceDelegate,STableViewRefreshDelegate,STableViewDataReformer,STableViewDataErrorDelegate>

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
+ (instancetype)csDelegatesProxy;

//@property (nonatomic, weak) id<GGCSTableBaseCellProtocol> cellDelegate;

/**
 *  数据源代理，非UITablViewDataSource
 */
@property (nonatomic, weak) id<STableViewDataSourceDelegate> cs_dataSourceInf;

/**
 *  刷新代理，若没有刷新控件，则没有必要实现
 */
@property (nonatomic, weak) id<STableViewRefreshDelegate> cs_refreshInf;

/**
 *  数据处理代理，必须实现的好
 */
@property (nonatomic, weak) id<STableViewDataReformer> cs_reformer;

/**
 *  错误处理代理，如果不需要的话可以不要
 */
@property (nonatomic, weak) id<STableViewDataErrorDelegate> cs_errHandler;

@end
