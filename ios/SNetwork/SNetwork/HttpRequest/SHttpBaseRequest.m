//
//  SBaseRequest.m
//  SNetworkDemo
//
//  Created by cs on 16/5/12.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "SHttpBaseRequest.h"
#import "SHttpRequestAgent.h"


@implementation SRequestStatus
@end
//==================

////================
//#pragma mark -
//#pragma mark - SResponseData Class
//@interface SResponseData()
//@property (nonatomic, weak) id<SDataReformerDelegate> child;
//@end
//
//@implementation SResponseData
//
//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        if ([self conformsToProtocol:@protocol(SDataReformerDelegate)]) {
//            self.child = (id<SDataReformerDelegate>)self;
//        } else {
//            NSAssert(0, @"请实现SDataReformerDelegate协议");
//        }
//    }
//    
//    return self;
//}
//
//@end
@interface SResponseData ()

@end
@implementation SResponseData

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    
    return self;
}

#pragma mark - SDataReformerDelegate
- (void)setOrignalData:(id)orignalData
{
    self.reformedData = nil;
    _orignalData = orignalData;
}
- (id)reformedData
{
    if (_reformedData == nil) {
        if (self.reformerDelegate && [self.reformerDelegate respondsToSelector:@selector(reformerData:)]){
            _reformedData = [self.reformerDelegate  reformerData:self.orignalData];
        }
    }
    
    return _reformedData;
}


@end









//================
#pragma mark - 
#pragma mark - SBaseRequest Class
@interface SHttpBaseRequest()

//@property (nonatomic, weak) id<SBaseRequestProtocol> child;
//内部用
@property (nonatomic, strong, readwrite) SResponseData  *responseData;
@property (nonatomic, strong, readwrite) SRequestStatus *status;
@property (nonatomic, weak, readwrite) SNetworkConfig *httpConfig;

@property (nonatomic, copy) SRequestBlockFinished callbackBlockFinished;
@property (nonatomic, copy) SRequestBlockFailed callbackBlockFailed;
@property (nonatomic, copy) SRequestBlockProgress callbackBlockProgress;
@end
@implementation SHttpBaseRequest
{
    NSTimeInterval _cacheTimeoutStop;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        if ([self conformsToProtocol:@protocol(SBaseRequestProtocol)]) {
//            self.child = (id<SBaseRequestProtocol>)self;
//            
//            
//        } else {
//            NSAssert(0, @"请实现协议SBaseRequestProtocol");
//        }
        [self setupBlock];
    }
    
    return self;
}

- (void)dealloc
{
    NSLog(@"SHttpBaseRequest dealloc");
}


#pragma mark - public method
- (void)startWithCompletionBlock:(SRequestBlockFinished)finishBlock progress:(SRequestBlockProgress)progress failed:(SRequestBlockFailed)failed
{
    self.callbackBlockFailed = failed;
    self.callbackBlockFinished = finishBlock;
    self.callbackBlockProgress = progress;
    
    [self start];
}
#pragma mark - private method
- (void)setupBlock
{
    
    @weakSelf(self);
    
    _blockFinished = ^(SHttpBaseRequest *request, id object){
        @strongSelf(self);
        
        self.responseData.orignalData = object;
        
        if (self.requestStatusDelegate && [self.requestStatusDelegate respondsToSelector:@selector(requestFinished:)]) {
            [self.requestStatusDelegate requestFinished:self];
        }
        
        if (self.callbackBlockFinished) {
            self.callbackBlockFinished(request, object);
        }
        
    };
    _blockFailed = ^(SHttpBaseRequest *request, NSError *error){
        @strongSelf(self);
        
        self.status.requestError = error;
        
        if (self.requestStatusDelegate && [self.requestStatusDelegate respondsToSelector:@selector(requestFailed:)]) {
            [self.requestStatusDelegate requestFailed:self];
        }
        
        if (self.callbackBlockFailed) {
            self.callbackBlockFailed(request, error);
        }
        
        //失败了重置缓存时间
        [self resetCacheTimeout];
    };
    _blockProgress = ^(SHttpBaseRequest *request, NSProgress *progress){
        @strongSelf(self);
        if (self.requestStatusDelegate && [self.requestStatusDelegate respondsToSelector:@selector(requestProgress:withProgress:)]) {
            [self.requestStatusDelegate requestProgress:self withProgress:progress];
        }
        
        if (self.callbackBlockProgress) {
            self.callbackBlockProgress(request, progress);
        }
    };
}

- (void)resetCacheTimeout
{
    _cacheTimeoutStop = 0;
}

- (BOOL)isCacheExpired
{
    if (_cacheTimeoutStop <= 0 && [self requestCacheTimeout] > 0) {
        _cacheTimeoutStop = [self requestCacheTimeout] + [NSDate timeIntervalSinceReferenceDate];
    }
    
    if (_cacheTimeoutStop - [NSDate timeIntervalSinceReferenceDate] > 0) {
        return NO;
    }
    
    [self resetCacheTimeout];
    return YES;
}
#pragma mark - SBaseRequestProtocol
- (void)start
{
    if ([self isCacheExpired]) {
        [[SHttpRequestAgent shareInstance] addRequest:self];
    }
}
- (void)startWithoutCache
{
    [self resetCacheTimeout];
    [[SHttpRequestAgent shareInstance] addRequest:self];
}
- (void)stop
{
    [[SHttpRequestAgent shareInstance] cancelRequest:self];
}

- (NSTimeInterval)requestCacheTimeout
{
    return 0;
}
- (id)requestParams
{
    return nil;
}
- (NSString *)requestUrl
{
    return nil;
}
- (SHttpRequestMethod)requestMethod
{
    return SHttpRequestMethodPost;
}
- (BOOL)cacheOpen
{
    return NO;
}


- (SHttpRequestSerizlization)requestSerizlization
{
    return SHttpRequestSerializerHttp;
}
- (SHttpResponseSerialization)responseSerizlization
{
    return SHttpResponseSerializationJson;
}

- (void)requestConstructBody:(id)object
{

}
- (NSString *)requestDownloadPath
{
    return nil;
}
- (NSArray *)requestAuthorization
{
    return nil;
}


- (NSDictionary *)requestExtendHeader
{
    return nil;
}


- (NSString *)requestClassName
{
    return NSStringFromClass([self class]);
}



- (NSString *)baseUrl
{
    return self.httpConfig.baseUrl;
}



- (NSTimeInterval)requestTimeoutInterval
{
    return self.httpConfig.timeout;
}


- (SHttpRequestDataType)requestDataType
{
    return SHttpRequestDataTypeData;
}


#pragma mark - setter and getter
- (SResponseData *)responseData
{
    if (_responseData == nil) {
        _responseData = [SResponseData new];
    }
    return _responseData;
}


- (SRequestStatus *)status
{
    //如果请求结束了就不用去最下层取数据了，直接用缓存数据
    if (_status == nil) {
        _status = [SRequestStatus new];
    }
    
    if (_status.requestSessionState != SHttpRequestSessionStateCompleted) {
        _status.requestSessionState = [[[SHttpRequestAgent shareInstance] queryValue:0 andRequest:self] integerValue];
    }
    
    
    return _status;
}
- (SNetworkConfig *)httpConfig
{
    if (_httpConfig == nil) {
        _httpConfig = [SNetworkConfig shareInstance];
    }
    
    return _httpConfig;
}
@end
