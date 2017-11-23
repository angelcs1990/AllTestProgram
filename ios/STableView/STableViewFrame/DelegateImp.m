//
//  DelegateImp.m
//  STableViewFrame
//
//  Created by cs on 16/10/14.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "DelegateImp.h"
#import "SBaseDataSource+group.h"
#import "MyCell.h"
#import "MyModel.h"

@implementation DelegateImp

- (id)reformDataSource:(STableViewDataSource *)dataSource withData:(id)oriData withType:(STableDataConfigType)type
{
    if (type == STableDataConfigUp) {
        SDataSourceGroup *group = [SDataSourceGroup csGroupWithName:nil desc:nil];
        [dataSource csAddGroupTail:group];
        
        for(int i = 0; i < 10; ++i)
        {
            MyModel *mod = [[MyModel alloc] init];
            mod.text = oriData;
            [group csAddData:mod];
        }
    } else {
        SDataSourceGroup *group1 = [SDataSourceGroup csGroupWithName:@"cs" desc:nil];
        SDataSourceGroup *group2 = [SDataSourceGroup csGroupWithName:@"test header" desc:nil];
        [dataSource csAddGroupTail:group1];
        [dataSource csAddGroupTail:group2];
        for(int i = 0; i < 10; ++i)
        {
            MyModel *mod = [[MyModel alloc] init];
            mod.text = oriData;
            [group1 csAddData:mod];
            if (i % 2 == 0) {
                [group2 csAddData:mod];
            }
        }
    }
    
    
    return nil;
}



- (CGFloat)requestCellHeight:(STableViewDataSource *)dataSource AtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
@end
