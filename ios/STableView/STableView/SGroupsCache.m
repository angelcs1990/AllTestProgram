//
//  GGCSGroupsCache.m
//  STableViewFrame
//
//  Created by cs on 16/10/13.
//  Copyright © 2016年 cs. All rights reserved.
//


#import "STableViewHeader.h"

////////////////////////
@interface SDataSourceGroup ()

@property (nonatomic, strong) NSMutableArray *groups;

@end

@implementation SDataSourceGroup

+ (instancetype)csGroupWithName:(NSString *)title desc:(NSString *)desc
{
    SDataSourceGroup *group = [[self alloc] init];
    group.cs_GroupName = title;
    group.cs_GroupDesc = desc;
    
    return group;
}

- (void)csAddData:(id)data
{
    if ([data isKindOfClass:[NSArray class]]) {
        [self.groups addObjectsFromArray:data];
    } else {
        [self.groups addObject:data];
    }
}

- (id)csObjectAtIndex:(NSUInteger)index
{
    return [self.groups objectAtIndex:index];
}

- (NSUInteger)count
{
    return self.groups.count;
}

#pragma mark - setter and getter
- (NSMutableArray *)groups
{
    if (_groups == nil) {
        _groups = @[].mutableCopy;
    }
    
    return _groups;
}

@end


/////////////////
@implementation SDataSourceGroups

+ (instancetype)csGroups
{
    return [[self alloc] init];
}

- (void)csClearAll
{
    [self.csGroupArray removeAllObjects];
    [self.csFastCache removeAllObjects];
}

- (void)csInsertGroups:(SDataSourceGroup *)group
{
    [self.csGroupArray insertObject:group atIndex:0];
    [self.csFastCache setObject:group forKey:group.cs_GroupName];
}

- (void)csAddGroups:(SDataSourceGroup *)group
{
    [self.csGroupArray addObject:group];
    [self.csFastCache setObject:group forKey:group.cs_GroupName];
}

- (SDataSourceGroup *)csGroupFromKey:(NSString *)key
{
    SDataSourceGroup *retValue = [self.csFastCache objectForKey:key];
    
    return retValue;
}

- (SDataSourceGroup *)csGroupAtSection:(NSUInteger)section
{
    if (self.csGroupArray.count <= section) {
        return nil;
    }
    return self.csGroupArray[section];
}

- (void)csAddObject:(id)data atGroupIndex:(NSUInteger)index
{
    NSInteger count = self.csGroupArray.count;
    if (count > index) {
        [self.csGroupArray[index] addObject:data];
    } else if (count + 1 < index) {
        [self.csGroupArray[count - 1] addObject:data];
    } else {
        NSMutableArray *array = @[].mutableCopy;
        [array addObject:data];
        [self.csGroupArray addObject:array];
    }
}

- (NSUInteger)csObjectCountAtGroupIndex:(NSUInteger)index
{
    index = (index >= self.csGroupArray.count) ? (self.csGroupArray.count - 1) : index;
    return [self.csGroupArray[index] count];
}

- (NSUInteger)csGroupCount
{
    NSInteger retValue = self.csGroupArray.count;
    return retValue;
}

- (id)csObjectForIndexPath:(NSIndexPath *)indexPath
{
    if (self.csGroupArray.count == 0) {
        return nil;
    }
    return [self.csGroupArray[indexPath.section] csObjectAtIndex:indexPath.row];
}

#pragma mark - gette and setter
- (NSMutableArray *)csGroupArray
{
    if (_cs_GroupArray == nil) {
        _cs_GroupArray = [NSMutableArray array];
    }
    
    return _cs_GroupArray;
}

- (NSMapTable *)csFastCache
{
    if (_cs_FastCache == nil) {
        _cs_FastCache = [NSMapTable weakToWeakObjectsMapTable];
    }
    
    return _cs_FastCache;
}

@end
