//
//  NetworkProxy.m
//  SNetworkDemo
//
//  Created by cs on 16/5/19.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "NetworkProxy.h"
#import "SHttpBaseRequest.h"
#import "RegisterRequest.h"
#import "SHttpRequest.h"
#import "GetImageRequest.h"
#import "OtherTestRequest.h"




@interface NetworkProxy ()<SRequestDelegate, SDataReformerDelegate>

@property (nonatomic, strong) id<SHttpRequestProtocol> request;
@property (nonatomic, copy) SRouterHandler blk;

@property (nonatomic, strong) SHttpBaseRequest *re1;
@property (nonatomic, strong) SHttpBaseRequest *re2;
@end

@implementation NetworkProxy

- (instancetype)init
{
    self = [super init];
    if (self) {
        SNetworkConfig *config = [SNetworkConfig shareInstance];
//        config.baseUrl = @"http://192.168.10.242:8181/mlottery/core/";
        config.baseUrl = @"http://images.17173.com/2015/news/2015/11/11/";
        config.timeout = 2.0;
        
        
    }
    
    return self;
}

- (void)dealloc
{
    NSLog(@"dealloc");
}
#pragma mark - ModuleProtocol
- (id)command:(NSInteger)cmd andParams:(NSDictionary *)dictParam
{
    switch (cmd) {
        case RouterModuleOtherCmd:
        {
            NSInteger cmd = [dictParam[keySRouter__Param_Cmd] integerValue];
            switch (cmd) {
                case NetworkProxyCmdsSend:

                    [self networkSend];
                    break;
                case NetworkProxyCmdsGetObject:
                    return ((GetImageRequest*)self.request).image;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    
    return nil;
}

#pragma mark -
- (void)requestFinished:(SHttpBaseRequest *)request
{
//    self.imageView.image = ((GetImageRequest *)request).image;
//    NSDictionary *obj = ((SHttpBaseRequest *)request).responseData.reformedData;
//    NSLog(@"%@---%ld", obj, request.status.responseStatusCode);
//    self.blk = SROUTER_QUERY_BLOCK_SIMP();
    NSLog(@"Hee:%@", request);
    
    self.blk = SROUTER_QUERY_BLOCK(@"NetworkProxy_my_define");
    if (self.blk) {
        self.blk(@{@"obj":((GetImageRequest *)request).image});
    }
    
}

#pragma mark - private method
- (void)networkSend
{
//        self.request = [RegisterRequest new];
//        ((SHttpBaseRequest *)self.request).requestStatusDelegate = self;
//        ((SHttpBaseRequest *)self.request).responseData.reformerDelegate = ((SHttpBaseRequest *)self.request);
//        [self.request start];
    
    
    //    self.request = [SHttpRequest new];
    //    SHttpRequest *tmpPointer = (SHttpRequest *)self.request;
    //    tmpPointer.requestStatusDelegate = self;
    //    tmpPointer.responseData.reformerDelegate = self;
    //    tmpPointer.requestParams = @{@"lang":@"zh", @"version":@"200", @"appType":@"1"};
    ////    tmpPointer.requestMethod = SHttpRequestMethodPost;
    //    tmpPointer.requestUrl    = @"basketballMatch.findFinishedMatch.do";
    //    [tmpPointer start];
    

    
//    [self.request start];

//    for(int i = 0; i < 1; ++i)
    {
        RegisterRequest *_re1 = [RegisterRequest new];
//        ((RegisterRequest*)_re1).tag = i;
        //    _re2 = [OtherTestRequest new];
        _re1.requestStatusDelegate = _re1;

        //    _re2.requestStatusDelegate = self;
        [_re1 start];
    }

//    [_re2 start];
}

#pragma mark - setter and getter
- (id<SHttpRequestProtocol>)request
{
    if (_request == nil) {
        _request = [GetImageRequest new];
        SHttpBaseRequest *trequest = (SHttpBaseRequest *)_request;
        trequest.requestStatusDelegate = self;
    }
    
    return _request;
}
@end
