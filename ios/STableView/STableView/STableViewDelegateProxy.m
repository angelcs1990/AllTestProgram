//
//  GGCSTableFrameInterface.m
//  STableViewFrame
//
//  Created by cs on 16/10/12.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "STableViewDelegateProxy.h"
#import "STableView.h"
#import "SDataErrorHandler.h"
#import <objc/runtime.h>


BOOL MethodSwizzle(Class c, SEL oriSEl, SEL newSel)
{
    Method oriMethod = class_getInstanceMethod(c, oriSEl);

    if (oriMethod == nil) {
        if ([c conformsToProtocol:@protocol(UITableViewDelegate)]) {
            //增加函数
            oriMethod = class_getInstanceMethod([STableView class], newSel);
        }
        if (oriMethod == nil) {
            NSLog(@"%@ 没有找到", NSStringFromSelector(oriSEl));
            return NO;
        }
        
        
    } else {
        return YES;
    }

    if (class_addMethod(c, oriSEl, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod))) {
        return YES;
    }
    
    return NO;
}

@implementation STableViewDelegateProxy

+ (instancetype)csDelegatesProxy
{
    STableViewDelegateProxy *tableInf = [[[self class] alloc] init];
//    tableInf.cs_errHandler = [SDataErrorHandler shareInstance];
    return tableInf;
}

- (void)dealloc
{
    NSLog(@"%@ dealloc", self);
}


#pragma mark - getter
#define DELEGATE_GETTER(_proto, _proname, _tip) \
- (id<_proto>)_proname{\
        if(_##_proname == nil){ \
            if ([self conformsToProtocol:@protocol(_proto)]) {\
                return (id<_proto>)self;\
            } else {\
                NSAssert(0, @_tip);\
            } \
            return nil;\
        }else{return _##_proname;}\
}
//DELEGATE_GETTER(GGCSTableBaseCellProtocol, cellDelegate, "please completion GGCSTableBaseCellProtocol")
DELEGATE_GETTER(STableViewDataSourceDelegate, cs_dataSourceInf, "please completion STableViewDataSourceDelegate")
DELEGATE_GETTER(STableViewRefreshDelegate, cs_refreshInf, "please completion STableViewRefreshDelegate")
DELEGATE_GETTER(STableViewDataReformer, cs_reformer, "please completion STableViewDataReformer")
//DELEGATE_GETTER(STableViewDataErrorDelegate, cs_errHandler, "please completion STableViewDataErrorDelegate")

- (id<STableViewDataErrorDelegate>)cs_errHandler
{
    if (_cs_errHandler == nil) {
        if ([self conformsToProtocol:@protocol(STableViewDataErrorDelegate)]) {
            return (id<STableViewDataErrorDelegate>)self;
        } else {
//            NSAssert(0, @"please completion STableViewDataErrorDelegate");
        }
        return nil;
    }
    
    return _cs_errHandler;
}
//- (id<STableViewDataSourceDelegate>)cs_dataSourceInf
//{
//    if (_cs_dataSourceInf == nil) {
//        if ([self conformsToProtocol:@protocol(STableViewDataSourceDelegate)]) {
//            return (id<STableViewDataSourceDelegate>)self;
//        } else {
//            NSAssert(0, @"please completion GGCSTableBaseDataSourceProtocol");
//        }
//        return nil;
//    } else {
//        return _cs_dataSourceInf;
//    }
//}
//- (id<STableViewDataReformer>)cs_reformer
//{
//    if (_cs_reformer == nil) {
//        if ([self conformsToProtocol:@protocol(STableViewDataReformer)]) {
//            return (id<STableViewDataReformer>)self;
//        } else {
//            NSAssert(0, @"please completion STableViewDataReformer");
//        }
//        return nil;
//    } else {
//        return _cs_reformer;
//    }
//}

@end
