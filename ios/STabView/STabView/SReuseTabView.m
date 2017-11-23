//
//  STabView.m
//  STabView
//
//  Created by cs on 16/7/12.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "SReuseTabView.h"
#import "SReuseTabViewCell.h"

#import "SReuseTabViewFlowLayout.h"


@interface SReuseTabView()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray<Class> *cellClassArray;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation SReuseTabView
{
    BOOL _bFirst;
}

#pragma mark - lifecycle

+ (instancetype)tabView:(NSArray<NSString *> *)titles withCellClasses:(NSArray<Class> *)cellClasses withFrame:(CGRect)frame
{
    return [self tabView:titles withCellClasses:cellClasses initIndex:0 withFrame:frame];
}

+ (instancetype)tabView:(NSArray<NSString *> *)titles withCellClasses:(NSArray<Class> *)cellClasses initIndex:(NSInteger)index withFrame:(CGRect)frame
{
    NSAssert(titles.count != 0 && cellClasses.count != 0, @"数据有误");
    
    SReuseTabView *tabView = [self tabViewWithFrame:frame];
    
    [tabView.titles addObjectsFromArray:titles];
    [tabView.cellClassArray addObjectsFromArray:cellClasses];

    [tabView baseTabViewSetupUI];
    tabView.initIndex = index;
    
    return tabView;
}

#pragma mark - 公共方法
- (void)setTabTitles:(NSArray<NSString *> *)titles withClasses:(NSArray<Class> *)cellClasses;
{
    NSAssert(self.params != nil, @"请先设置好param");
    
    if (titles == nil || cellClasses == nil) {
        return;
    }
    
    [self.titles removeAllObjects];
    [self.cellClassArray removeAllObjects];
    
    [self.titles addObjectsFromArray:titles];
    [self.cellClassArray addObjectsFromArray:cellClasses];
    
    [self baseTabViewSetupUI];

    [self baseTabViewReloadValue:self.params];
}

- (void)addTabTitle:(NSString *)title withClass:(Class)cellClass
{
    if (title == nil || cellClass == Nil) {
        return;
    }
    

    [self baseTabViewSetupButton:title];
    [self.cellClassArray addObject:cellClass];

    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - SBaseTabViewProtocol
- (void)tabViewRequestSetupUI:(SBaseTabView *)parentView
{    
    [self.collectionView reloadData];
}

- (void)tabViewRequestSetupData:(SBaseTabView *)parentView
{
    _bFirst = YES;
    self.clickedState = YES;
}

- (void)tabViewRequestCallFun:(SBaseTabView *)parentView withIndex:(NSInteger)index
{
    if (!self.params.preLoad) {
        SReuseTabViewCell *cell = (SReuseTabViewCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        [self callbackFun:cell atRow:index];
    } else if (self.clickedState) {
        self.clickedState = NO;
        
        [self.collectionView reloadData];
    }
}

- (void)tabViewRequestLayoutSubViews:(SBaseTabView *)parentView
{
}

- (UIScrollView *)tabViewRequestContentView
{
    return self.collectionView;
}


#pragma mark - UITableViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.titles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SReuseTabViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cs_cs" forIndexPath:indexPath];

    if (self.params.preLoad && self.clickedState == NO) {
        [self callbackFun:cell atRow:indexPath.row];
    } else if (_bFirst && indexPath.row == self.currentIndex) {
        [self callbackFun:cell atRow:indexPath.row];
        _bFirst = NO;
        self.clickedState = NO;
    }

    return cell;
}



#pragma mark - 私有方法
- (Class)cellClassAtRow:(NSInteger)row
{
    Class cellClass = Nil;
    if (self.cellClassArray.count == 1){
        cellClass = self.cellClassArray[0];
    } else if (self.cellClassArray.count > row) {
        cellClass = self.cellClassArray[row];
    }
    
    return cellClass;
}

- (void)callbackFun:(SReuseTabViewCell *)cell atRow:(NSInteger)row
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabView:didTabView:atIndex:)]) {
        [self.delegate tabView:self didTabView:cell atIndex:row];
    }
}

#pragma mark - getter
- (NSMutableArray<Class> *)cellClassArray
{
    if (_cellClassArray == nil) {
        _cellClassArray = [NSMutableArray array];
    }
    
    return _cellClassArray;
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        SReuseTabViewFlowLayout *layout = [[SReuseTabViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = NO;
        Class cellClass = [self cellClassAtRow:0];
        [_collectionView registerClass:cellClass forCellWithReuseIdentifier:@"cs_cs"];
    }
    
    return _collectionView;
}

@end
