//
//  SCoreNetwork.m
//  SNetworkDemo
//
//  Created by cs on 16/5/12.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "SHttpCoreNetwork.h"






//========================
#pragma mark -
#pragma mark - _SNetworkSessionManagerCache
@interface _SNetworkSessionCache : NSObject
@property (nonatomic, strong) NSCache *sessionManagerRecord;
@property (nonatomic, strong) NSMutableDictionary *sessionTaskRecord;

@end

@implementation _SNetworkSessionCache

- (void)dealloc
{
    [self removeAllTasks];
    [self removeAllSessionManagers];
}
#pragma mark - public method
- (NSString *)hashKeyForObject:(id)obj
{
    return [NSString stringWithFormat:@"%lu", [obj hash]];
}
- (NSString *)hashKeyForUInteger:(NSUInteger)key
{
    return [NSString stringWithFormat:@"%lu", key];
}

/**
 *  网络任务
 *
 *  @param task    nil
 *  @param request nil
 */
- (void)addTask:(NSURLSessionTask *)task withRequest:(SHttpBaseRequest *)request
{
    [self.sessionTaskRecord setObject:task forKey:[self hashKeyForObject:request]];
}
- (NSURLSessionTask *)taskWithRequest:(SHttpBaseRequest *)request
{
    return [self.sessionTaskRecord objectForKey:[self hashKeyForObject:request]];
}
- (void)removeTaskWithRequest:(SHttpBaseRequest *)request
{
    [self.sessionTaskRecord removeObjectForKey:[self hashKeyForObject:request]];
}
- (void)removeAllTasks
{
    [self.sessionTaskRecord removeAllObjects];
}
/**
 *  AFHTTPSessionManager共享链接相关函数（3.0后支持）
 *
 *  @param manager AFHTTPSessionManager
 *  @param url     基地址
 */
- (void)addSessionManager:(AFHTTPSessionManager *)manager withBaseUrl:(NSString *)url
{
    [self.sessionManagerRecord setObject:manager forKey:url];
}
- (AFHTTPSessionManager *)sessionManagerWithUrl:(NSString *)url
{
    return [self.sessionManagerRecord objectForKey:url];
}
- (void)removeSessionManagerWithUrl:(NSString *)url
{
    [self.sessionManagerRecord removeObjectForKey:url];
}
- (void)removeAllSessionManagers
{
    [self.sessionManagerRecord removeAllObjects];
}

#pragma mark - setter and getter
- (NSCache *)sessionManagerRecord
{
    if (_sessionManagerRecord == nil) {
        _sessionManagerRecord = [NSCache new];
        _sessionManagerRecord.countLimit = 30;
    }
    
    return _sessionManagerRecord;
}
- (NSMutableDictionary *)sessionTaskRecord
{
    if (_sessionTaskRecord == nil) {
        _sessionTaskRecord = [NSMutableDictionary dictionary];
    }
    
    return _sessionTaskRecord;
}
@end
//=========================
#pragma mark - 
#pragma mark - SNetwork

@interface SHttpNetwork ()
@property(nonatomic, strong) _SNetworkSessionCache *sessionManagerCache;

@end

@implementation SHttpNetwork
{
    dispatch_queue_t _requestQueue;
}

+ (instancetype)shareInstance
{
    static SHttpNetwork *network;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        network = [SHttpNetwork new];
    });
    
    return network;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _requestQueue = dispatch_queue_create("com.cs.http.request.queue", DISPATCH_QUEUE_SERIAL);
    }
    
    return self;
}

- (void)dealloc
{
    
}
#pragma mark -
- (void)sendRequest:(SHttpBaseRequest *)request
{
    dispatch_async(_requestQueue, ^{
        [self runRequest:request];
    });
}
- (void)cancelRequest:(SHttpBaseRequest *)request
{
    dispatch_async(_requestQueue, ^{
        [self runCancelRequest:request];
    });
}
- (id)queryValue:(int)type andRequest:(SHttpBaseRequest *)request;
{
    NSURLSessionTask *taskRequest = [self.sessionManagerCache taskWithRequest:request];
    NSURLSessionTaskState state = taskRequest.state;
    
    return @(state);
}
//- (NSInteger)requestState:(SHttpBaseRequest *)request;
//{
//    NSURLSessionTask *taskRequest = [self.sessionManagerCache taskWithRequest:request];
//    NSURLSessionTaskState state = taskRequest.state;
//    
//    return state;
//}

#pragma mark - private method
//取消
- (void)runCancelRequest:(SHttpBaseRequest *)request
{
    NSURLSessionTask *taskRequest = [self.sessionManagerCache taskWithRequest:request];
    [self clearAfterReqeust:request];
    if (taskRequest) {
        [taskRequest cancel];
    }
}
//请求
- (void)runRequest:(SHttpBaseRequest *)request
{
    
    
    //同一个request请求未完成
    if ([self.sessionManagerCache taskWithRequest:request]) {
        //请求过快处理
        //[self dealRequestFash];
        return;
    }
    
    
    NSURLSessionTask *taskRequest = [self runTaskRequest:request];
    
    if (taskRequest) {
        [self.sessionManagerCache addTask:taskRequest withRequest:request];
    }
    
}

- (NSURLSessionTask *)runTaskRequest:(SHttpBaseRequest *)request
{
    NSURLSessionTask *taskRequest;
    AFHTTPSessionManager *sessionManager = [self sessionManagerWithRequest:request];
    SHttpRequestMethod method = [request requestMethod];
    id params = [request requestParams];
    NSString *requestUrl = [self urlConstructWithRequest:request];

    //额外没提供的参数设置
    if (request.blockNetworkManager != nil) {
        request.blockNetworkManager(sessionManager);
    }
    
    
    @weakSelf(self);
    
#ifndef SHTTPREQUEST_ACTION_WITHBODY
#define SHTTPREQUEST_ACTION_WITHBODY(_action, _body) [sessionManager _action:requestUrl \
                                                            parameters:params \
                                             constructingBodyWithBlock:_body \
                                                              progress:^(NSProgress * _Nonnull uploadProgress) { \
                                                                    @strongSelf(self); \
                                                                    [self handleProgressWithRequest:request withProgress:uploadProgress]; \
                                                            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) { \
                                                                    @strongSelf(self); \
                                                                    [self handleSuccessWithRequest:request withResponseObject:responseObject]; \
                                                            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) { \
                                                                    @strongSelf(self); \
                                                                    [self handleFailedWithRequest:request withError:error]; \
                                                            }];
#endif
    
#ifndef SHTTPREQUEST_ACTION
#define SHTTPREQUEST_ACTION(_action) [sessionManager _action:requestUrl \
                                             parameters:params \
                                               progress:^(NSProgress * _Nonnull uploadProgress) { \
                                                    @strongSelf(self); \
                                                    [self handleProgressWithRequest:request withProgress:uploadProgress]; \
                                              } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) { \
                                                    @strongSelf(self); \
                                                    [self handleSuccessWithRequest:request withResponseObject:responseObject]; \
                                              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) { \
                                                    @strongSelf(self); \
                                                    [self handleFailedWithRequest:request withError:error]; \
                                              }];
#endif
#ifndef SHTTPREQUEST_ACTION_OTHER
#define SHTTPREQUEST_ACTION_OTHER(_action) [sessionManager _action:requestUrl \
parameters:params \
 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) { \
@strongSelf(self); \
[self handleSuccessWithRequest:request withResponseObject:responseObject]; \
} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) { \
@strongSelf(self); \
[self handleFailedWithRequest:request withError:error]; \
}];
#endif

    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    switch (method) {
        case SHttpRequestMethodGet:
        {
            if ([request requestDataType] == SHttpRequestDataTypeData) {
                taskRequest = SHTTPREQUEST_ACTION(GET);
            } else if([request requestDataType] == SHttpRequestDataTypeFile) {
                
                NSURL *URL = [NSURL URLWithString:requestUrl];
                NSURLRequest *requestDownloadURL = [NSURLRequest requestWithURL:URL];
                
                taskRequest = [sessionManager downloadTaskWithRequest:requestDownloadURL
                                                             progress:^(NSProgress * _Nonnull downloadProgress) {
                                                                @strongSelf(self);
                                                                [self handleProgressWithRequest:request withProgress:downloadProgress];
                                                             } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                                                                 NSURL *tt =  [self downloadFilePathConstruct:request];
                                                                 return tt;
                                                             } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                                                                 @strongSelf(self);
                                                                [self handleSuccessWithRequest:request withResponseObject:filePath.absoluteString];
                                                             }];
                [taskRequest resume];
            }

        }
            break;
        case SHttpRequestMethodPut:
        {
            taskRequest = SHTTPREQUEST_ACTION_OTHER(PUT);
        }
            break;
        case SHttpRequestMethodHead:
        {
            taskRequest = [sessionManager HEAD:requestUrl
                                    parameters:params
                                       success:nil
                                       failure:nil];
        }
            break;
        case SHttpRequestMethodPost:
        {
            if ([request requestDataType] == SHttpRequestDataTypeData) {
                taskRequest = SHTTPREQUEST_ACTION(POST);
            } else if ([request requestDataType] == SHttpRequestDataTypeFile) {
                //文件上传
                void (^blockConstruct)(id <AFMultipartFormData> formData) = ^(id <AFMultipartFormData> formData){
                    [request requestConstructBody:formData];
                };
                
                taskRequest = SHTTPREQUEST_ACTION_WITHBODY(POST, blockConstruct);
            }
        }
            break;
        case SHttpRequestMethodPatch:
        {
            taskRequest = SHTTPREQUEST_ACTION_OTHER(PATCH);
        }
            break;
        case SHttpRequestMethodDelete:
        {
            taskRequest = SHTTPREQUEST_ACTION_OTHER(DELETE);
        }
            break;
        default:
            break;
    }
    

    
    return taskRequest;
}

- (NSURL *)downloadFilePathConstruct:(SHttpBaseRequest *)request
{
    NSString *reqeustUrl = [request requestDownloadPath];
    
    if ([reqeustUrl hasPrefix:@"file://"]) {
        return [NSURL URLWithString:reqeustUrl];
    }
    
    return [NSURL fileURLWithPath:reqeustUrl];
}


- (AFHTTPSessionManager *)sessionManagerWithRequest:(SHttpBaseRequest *)request
{
    NSString *baseUrl = [self requestBaseUrlWithRequest:request];
    
    AFHTTPSessionManager *mgr = [self.sessionManagerCache sessionManagerWithUrl:baseUrl];
    if (mgr == nil) {
        mgr = [self createSessionManagerWithRequest:request];
        
        [self.sessionManagerCache addSessionManager:mgr withBaseUrl:baseUrl];
    }
    
    return mgr;
}

- (AFHTTPSessionManager *)createSessionManagerWithRequest:(SHttpBaseRequest *)request
{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer = [self httpRequestSerializerWithRequest:request];
    mgr.requestSerializer.timeoutInterval = [request requestTimeoutInterval];
    mgr.responseSerializer = [self httpResponseSerializerWithRequest:request];
    
    //登陆名跟密码
    NSArray *authorization = [request requestAuthorization];
    if (authorization != nil) {
        [mgr.requestSerializer setAuthorizationHeaderFieldWithUsername:(NSString *)authorization.firstObject password:(NSString *)authorization.lastObject];
    }
    
    //header设置
    NSDictionary *headerFieldValue = [request requestExtendHeader];
    if (headerFieldValue != nil) {
        for (id httpHeaderField in headerFieldValue.allKeys) {
            id value = headerFieldValue[httpHeaderField];
            if ([httpHeaderField isKindOfClass:[NSString class]] && [value isKindOfClass:[NSString class]]) {
                [mgr.requestSerializer setValue:(NSString *)value forHTTPHeaderField:(NSString *)httpHeaderField];
            } else {
                NSLog(@"Error, headerFieldValue should be NSString");
            }
        }
    }
//    [mgr setSecurityPolicy:[self customSecurityPolicy]];
    //额外的没关照到的参数设置
    if (self.paramExtraDelegate && [self.paramExtraDelegate respondsToSelector:@selector(networkExtraConfig:)]) {
        [self.paramExtraDelegate networkExtraConfig:mgr];
    }
    
    return mgr;
}

- (AFSecurityPolicy *)customSecurityPolicy {
    

    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES;
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = YES;
    

    
    return securityPolicy;
}
- (AFHTTPResponseSerializer *)httpResponseSerializerWithRequest:(SHttpBaseRequest *)request
{
    SHttpResponseSerialization httpSerType = [request responseSerizlization];
    AFHTTPResponseSerializer *httpSer;
    switch (httpSerType) {
        case SHttpResponseSerializationHttp:
            httpSer = [AFHTTPResponseSerializer serializer];
            break;
        case SHttpResponseSerializationJson:
            httpSer = [AFJSONResponseSerializer serializer];
            break;
        case SHttpResponseSerializationXML:
            httpSer = [AFXMLParserResponseSerializer serializer];
            break;
        case SHttpResponseSerializationPropertyList:
            httpSer = [AFPropertyListResponseSerializer serializer];
            break;
        case SHttpResponseSerializationImage:
            httpSer = [AFImageResponseSerializer serializer];
            break;
        case SHttpResponseSerializationNone:
        default:
            break;
    }
    
    return httpSer;
}
- (AFHTTPRequestSerializer *)httpRequestSerializerWithRequest:(SHttpBaseRequest *)request
{
    SHttpRequestSerizlization httpSerType = [request requestSerizlization];
    AFHTTPRequestSerializer *httpSer;
    switch (httpSerType) {
        case SHttpRequestSerializerHttp:
            httpSer = [AFHTTPRequestSerializer serializer];
            break;
        case SHttpRequestSerializerJson:
            httpSer = [AFJSONRequestSerializer serializer];
            break;
        case SHttpRequestSerializerPropertyList:
            httpSer = [AFPropertyListRequestSerializer serializer];
            break;
        case SHttpRequestSerizlizationNone:
        default:
            break;
    }
    
    return httpSer;
}

- (NSString *)urlConstructWithRequest:(SHttpBaseRequest *)request
{
    return [NSString stringWithFormat:@"%@%@", request.baseUrl ,request.requestUrl];
}
- (NSString *)requestBaseUrlWithRequest:(SHttpBaseRequest *)request
{
    NSString *baseUrl = request.baseUrl ;
    
    NSURL *theUrl = [NSURL URLWithString:baseUrl];
    NSURL *root = [NSURL URLWithString:@"/" relativeToURL:theUrl];
    
    return [NSString stringWithFormat:@"%@", root.absoluteString];
}

- (void)responseCode:(SHttpBaseRequest *)request
{
    NSURLSessionTask *dataTask = [self.sessionManagerCache taskWithRequest:request];
    if ([dataTask.response isMemberOfClass:[NSHTTPURLResponse class]]) {
        NSInteger responseCode = ((NSHTTPURLResponse *)dataTask.response).statusCode;
        request.status.responseStatusCode = responseCode;
    }
}


- (void)clearAfterReqeust:(SHttpBaseRequest *)request
{
    [self.sessionManagerCache removeTaskWithRequest:request];
}
#pragma mark - private method(处理网络返回)
- (void)handleProgressWithRequest:(SHttpBaseRequest *)request withProgress:(NSProgress * _Nonnull)progress
{
    request.blockProgress(request, progress);
}
- (void)handleSuccessWithRequest:(SHttpBaseRequest *)request withResponseObject:(id)obj
{
    [self responseCode:request];
    [self clearAfterReqeust:request];
    request.blockFinished(request, obj);
}
- (void)handleFailedWithRequest:(SHttpBaseRequest *)request withError:(NSError *)error
{
    [self responseCode:request];
    [self clearAfterReqeust:request];
    request.blockFailed(request, error);
}
#pragma mark - setter and getter
- (_SNetworkSessionCache *)sessionManagerCache
{
    if (_sessionManagerCache == nil) {
        _sessionManagerCache = [_SNetworkSessionCache new];
    }
    
    return _sessionManagerCache;
}

@end
