//
//  MyDataSource.h
//  STableViewFrame
//
//  Created by cs on 16/10/12.
//  Copyright © 2016年 cs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STableViewHeader.h"

@interface MyDataSource : NSObject<STableViewDataSourceDelegate>

@end

@interface Rerfomer : NSObject<STableViewDataReformer>

@end

@interface DataSource : STableViewDataSource<UITableViewDataSource>

@end
