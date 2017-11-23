//
//  SNetworkProtocol.m
//  SNetworkDemo
//
//  Created by cs on 16/5/16.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "SHttpNetworkProtocol.h"
#import "MacroDef.h"

#pragma mark -
#pragma mark - SCoreNetwork
@interface SHttpCoreNetwork ()

//@property (nonatomic, weak) id<SDataReformerDelegate> dataReformer;




@end
@implementation SHttpCoreNetwork
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}


- (void)sendRequest:(SHttpBaseRequest *)request
{
    
    _FUN_IMPLEMENT_ASSERT();
}
- (void)cancelRequest:(SHttpBaseRequest *)request
{
    _FUN_IMPLEMENT_ASSERT();
}
- (void)cancelAllRequests
{
    _FUN_IMPLEMENT_ASSERT();
}
- (id)queryValue:(int)type andRequest:(SHttpBaseRequest *)request
{
    _FUN_IMPLEMENT_ASSERT();
    return nil;
}
#pragma mark - private method

#pragma mark - getter and setter

//- (NSMutableDictionary *)requestRecord
//{
//    if (_requestRecord == nil) {
//        _requestRecord = [NSMutableDictionary dictionary];
//    }
//
//    return _requestRecord;
//}
- (SNetworkConfig *)config
{
    if (_config == nil) {
        _config = [SNetworkConfig shareInstance];
    }
    
    return _config;
}

@end
