//
//  GGCSBaseDataSource+group.m
//  STableViewFrame
//
//  Created by cs on 16/10/13.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "SBaseDataSource+group.h"
#import "STableViewHeader.h"


//////////////////////////////
@implementation STableViewDataSource (group)

- (STableViewCellModel *)csModelAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.cs_groups csObjectForIndexPath:indexPath];
}

- (SDataSourceGroup *)csGroupFromKey:(NSString *)key
{
    return [self.cs_groups csGroupFromKey:key];
}

- (SDataSourceGroup *)csGroupAtSection:(NSUInteger)section
{
    return [self.cs_groups csGroupAtSection:section];
}

- (void)csAddGroupTail:(SDataSourceGroup *)group
{
    if (group != nil) {
        [self.cs_groups csAddGroups:group];
    }
}

- (NSInteger)csGroupCount
{
    return [self.cs_groups csGroupCount];
}

- (void)csAddGroupHead:(SDataSourceGroup *)group
{
    if (group != nil) {
        [self.cs_groups csInsertGroups:group];
    }
}

- (void)csClearAll
{
    [self.cs_groups csClearAll];
    [self.cs_cellHeightCache removeAllObjects];
}

@end
