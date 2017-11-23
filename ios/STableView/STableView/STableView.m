//
//  GGCSBaseTableView.m
//  STableViewFrame
//
//  Created by cs on 16/10/13.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "STableViewHeader.h"


@interface STableView()<UITableViewDelegate>

@end

@implementation STableView

@synthesize cs_DataSource = _cs_DataSource;
@synthesize cs_DelegatesProxy = _cs_DelegatesProxy;
#pragma mark - 生命周期
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupProperty];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - 公共函数
- (id)csConfigurationData:(id)data type:(STableDataConfigType)type
{
    return [self.cs_DataSource csConfigurationData:data type:type];
}

#pragma mark - 私有函数（初始化)
static NSMutableDictionary *_g_cache;
- (void)setupData:(id<UITableViewDelegate>)clssid
{
    if(clssid == nil)
        return;
    
    if (!_g_cache) {
        _g_cache = [NSMutableDictionary dictionary];
    }
    if ([_g_cache objectForKey:NSStringFromClass([clssid class])] != nil) {
        return;
    }
    
    BOOL bRet = MethodSwizzle([clssid class], @selector(tableView:willDisplayCell:forRowAtIndexPath:), @selector(cs_tableView:willDisplayCell:forRowAtIndexPath:));
    MethodSwizzle([clssid class], @selector(tableView:heightForRowAtIndexPath:), @selector(cs_tableView:heightForRowAtIndexPath:));
    if(bRet)
        _g_cache[NSStringFromClass([clssid class])] = @0;

}


- (void)setupProperty
{
    self.showsVerticalScrollIndicator   = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
}

#pragma mark - 私有函数（通用）


#pragma mark - UITableViewDelegate
- (void)cs_tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
}

- (CGFloat)cs_tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [((STableView*)tableView).cs_DataSource csCellHeightForRow:(STableView*)tableView atIndexPath:indexPath];
}

#pragma mark - setter and getter
- (void)setDelegate:(id<UITableViewDelegate>)delegate
{
    [self setupData:delegate];
    [super setDelegate:delegate];
}

- (void)setDataSource:(id<UITableViewDataSource>)dataSource
{
    if ([dataSource isKindOfClass:[STableViewDataSource class]]) {
        [super setDataSource:dataSource];
    } else {
        NSAssert(dataSource == nil, @"请用GGCSBaseDataSource或是他的子类赋值");
    }
}

- (void)setCs_DataSource:(STableViewDataSource *)csDataSource
{
    _cs_DataSource = csDataSource;

    self.dataSource = csDataSource;
    if (self.cs_CellClasses != nil) {
        self.cs_DataSource.cs_cellClasses = _cs_CellClasses.mutableCopy;
    }
    
}

- (STableViewDataSource *)cs_DataSource
{
    if (_cs_DataSource == nil) {
        _cs_DataSource = [STableViewDataSource csDataSource];

        
        self.dataSource = _cs_DataSource;
    }
    
    return _cs_DataSource;
}

- (void)setCs_CellClasses:(NSArray<Class> *)csCellClasses
{
    NSAssert([csCellClasses isKindOfClass:[NSArray class]], @"请用数组赋值");
    
    _cs_CellClasses = csCellClasses;
    self.cs_DataSource.cs_cellClasses = _cs_CellClasses.mutableCopy;
}

- (STableViewDelegateProxy *)cs_DelegatesProxy
{
    if (_cs_DelegatesProxy == nil) {
        _cs_DelegatesProxy = [STableViewDelegateProxy csDelegatesProxy];
        
        self.cs_DataSource.cs_DelegatesProxy = _cs_DelegatesProxy;
        self.delegate = self;
    }
    return _cs_DelegatesProxy;
}
- (void)setCs_DelegatesProxy:(STableViewDelegateProxy *)csTableInf
{
    _cs_DelegatesProxy = csTableInf;
    self.cs_DataSource.cs_DelegatesProxy = _cs_DelegatesProxy;
}

//- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
//    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
//    if (!signature) {
//        for (id target in self.allDelegates) {
//            if ((signature = [target methodSignatureForSelector:aSelector])) {
//                break;
//            }
//        }
//    }
//    return signature;
//}
//
//- (void)forwardInvocation:(NSInvocation *)anInvocation{
//    for (id target in self.allDelegates) {
//        if ([target respondsToSelector:anInvocation.selector]) {
//            [anInvocation invokeWithTarget:target];
//        }
//    }
//}

//- (id)forwardingTargetForSelector:(SEL)aSelector
//{
//    if (aSelector == @selector(tableView:heightForRowAtIndexPath:) || aSelector == @selector(cs_tableView:heightForRowAtIndexPath:)) {
//        return self;
//    }
//    if (aSelector == @selector(tableView:willDisplayCell:forRowAtIndexPath:) || aSelector == @selector(cs_tableView:willDisplayCell:forRowAtIndexPath:)) {
//        return self;
//    }
//    return [super forwardingTargetForSelector:aSelector];
//}
//+ (BOOL)resolveInstanceMethod:(SEL)sel
//{
//    if (sel == @selector(tableView:heightForRowAtIndexPath:) || sel == @selector(cs_tableView:heightForRowAtIndexPath:)) {
//        NSLog(@"sdfs");
//    }
//    return [super resolveInstanceMethod:sel];
//}
@end
