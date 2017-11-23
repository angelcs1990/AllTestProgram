//
//  MyDataSource.m
//  STableViewFrame
//
//  Created by cs on 16/10/12.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "MyDataSource.h"
#import "SBaseDataSource+group.h"
#import "MyModel.h"

@implementation MyDataSource
- (CGFloat)requestCellHeight:(STableViewDataSource *)dataSource AtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

@end


@implementation DataSource

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"footer";
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
//    NSString *ts = [super tableView:tableView titleForHeaderInSection:section];
//    ts =  [ts stringByAppendingString:@" DataSource "];
//    return ts;
    return @"MYDatSource";
}

@end



@implementation Rerfomer

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
        SDataSourceGroup *group1 = [SDataSourceGroup csGroupWithName:@"cs Header" desc:nil];
        SDataSourceGroup *group2 = [SDataSourceGroup csGroupWithName:@"cs Header" desc:nil];
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

@end
