//
//  GGCSBaseDataSource.m
//  STableViewFrame
//
//  Created by cs on 16/10/13.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "STableViewDataSource.h"
#import "SBaseDataSource+group.h"
#import "SGroupsCache.h"
#import "STableViewCell.h"
#import "STableViewHeader.h"



////////////////////////
@interface STableViewDataSource()

//@property (nonatomic, weak) id<GGCSTableBaseDataSourceProtocol> child;

@end

@implementation STableViewDataSource

#pragma mark - 生命周期
+ (instancetype)csDataSource
{
    STableViewDataSource *dataSource = [[[self class] alloc] init];
    return dataSource;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        if ([self conformsToProtocol:@protocol(GGCSTableBaseDataSourceProtocol)]) {
//            _child = (id<GGCSTableBaseDataSourceProtocol>)self;
//        } else {
//            NSAssert(0, @"please incompletion GGCSTableBaseDataSourceProtocol");
//        }

//        self.reformer = self;
        [self setupInit];
    }
    
    return self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.cs_groups csGroupCount];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cs_groups csObjectCountAtGroupIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    STableViewCell *cell = [self cellFromClasses:(STableView *)tableView atIndex:indexPath.section];
    [cell csConfigurationItem:[self csModelAtIndexPath:indexPath]];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self csGroupAtSection:section].cs_GroupName;
}

#pragma mark - 公共方法
- (id)csConfigurationData:(id)data type:(STableDataConfigType)type
{
    BOOL handleContinue = YES;

    if (self.cs_DelegatesProxy.cs_errHandler && [self.cs_DelegatesProxy.cs_errHandler respondsToSelector:@selector(handleError:withData:withType:)]) {
        handleContinue = [self.cs_DelegatesProxy.cs_errHandler handleError:self withData:data withType:0];
    }
    if (handleContinue) {
        if (self.cs_DelegatesProxy.cs_reformer && [self.cs_DelegatesProxy.cs_reformer respondsToSelector:@selector(reformDataSource:withData:withType:)]) {
            return [self.cs_DelegatesProxy.cs_reformer reformDataSource:self withData:data withType:type];
        }
    }
    return nil;
}

- (CGFloat)csFastQueryCellHeightAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.cs_cellHeightCache[@(indexPath.section)] floatValue];
}

- (CGFloat)csCellHeightForRow:(STableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
    CGFloat retValue = GGCSTABLEBASEDATASOURCE_UNVALIDVALUE;

    if ([self.cs_DelegatesProxy.cs_dataSourceInf respondsToSelector:@selector(requestCellHeight:AtIndexPath:)]) {
        retValue = [self.cs_DelegatesProxy.cs_dataSourceInf requestCellHeight:self AtIndexPath:indexPath];
    }
    if (retValue == GGCSTABLEBASEDATASOURCE_UNVALIDVALUE) {
        if (self.cs_cellHeightCache[@(indexPath.section)] == nil) {
            UITableViewCell *cell = [self cellPrototypeForRow:tableView atIndexPath:indexPath];
            if (cell == nil) {
                CGSize size = [cell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
                self.cs_cellHeightCache[@(indexPath.section)] = @(1 + size.height);
                return 1 + size.height;
            } else {
                return 40;
            }
        }
        return [self.cs_cellHeightCache[@(indexPath.section)] floatValue];
    } else {
        return retValue;
    }
}

#pragma mark - 私有函数（初始化）
- (void)setupInit
{
    if ([self.cs_DelegatesProxy.cs_dataSourceInf respondsToSelector:@selector(requestInit:)]) {
        [self.cs_DelegatesProxy.cs_dataSourceInf requestInit:self];
    }
}

#pragma mark - 私有函数
- (UITableViewCell *)cellPrototypeForRow:(STableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
    if ([self.cs_DelegatesProxy.cs_dataSourceInf respondsToSelector:@selector(requestCellPrototype:AtIndexPath:)]) {
        return [self.cs_DelegatesProxy.cs_dataSourceInf requestCellPrototype:self AtIndexPath:indexPath];
    }
    STableViewCell *cell = [self cellFromClasses:tableView atIndex:indexPath.section];
    [cell csConfigurationItem:[self csModelAtIndexPath:indexPath]];
    return cell;
}

- (STableViewCell *)cellFromClasses:(STableView *)tableView atIndex:(NSInteger)index
{
    NSArray *Classes = nil;

    if ([self.cs_DelegatesProxy.cs_dataSourceInf respondsToSelector:@selector(requestCellClass:)]) {
        Classes = [self.cs_DelegatesProxy.cs_dataSourceInf requestCellClass:self];
    } else {
        Classes = _cs_cellClasses;
    }
    if (Classes != nil) {
        if (Classes.count == 1) {
            return [Classes[0] csCellWithTableView:tableView];
        } else {
            return [Classes[index] csCellWithTableView:tableView];
        }
    }

    S_NSAssert(0, @"要么实现requestCellClass代理，要么tableView.cs_CellClasses设置");
    return nil;
}

#pragma mark - getter and setter
- (SDataSourceGroups *)cs_groups
{
    if (_cs_groups == nil) {
        _cs_groups = [SDataSourceGroups csGroups];
    }
    
    return _cs_groups;
}

- (NSMutableDictionary *)cs_cellHeightCache
{
    if (_cs_cellHeightCache == nil) {
        _cs_cellHeightCache = @{}.mutableCopy;
    }
    
    return _cs_cellHeightCache;
}

@end
