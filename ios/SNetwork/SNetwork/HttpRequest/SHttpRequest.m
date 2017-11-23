//
//  SRequest.m
//  SNetworkDemo
//
//  Created by cs on 16/5/12.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "SHttpRequest.h"
#import "SHttpRequestAgent.h"

#define SHTTP_ASSERT(_v) NSAssert(0, ([NSString stringWithFormat:@"%@%@", _v, NSStringFromSelector(_cmd)]))
#define SHTTP_SETTER_OBJ(_type, _funname) -(_type)_funname{\
    if(_##_funname == nil) \
    {\
        _##_funname = [super _funname];\
    }\
    return _##_funname;\
};
#define SHTTP_SETTER_CONST(_type, _funname) -(_type)_funname{\
    if(_##_funname <= 0) \
    {\
        _##_funname = [super _funname];\
    }\
    return _##_funname;\
};

#define SHTTP_SETTER_BOOL(_funname) @synthesize _funname
@implementation SHttpRequest


#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        _requestMethod = [super requestMethod];
        _requestDataType = [super requestDataType];
        _requestSerizlization = [super requestSerizlization];
        _responseSerizlization = [super responseSerizlization];
        _cacheOpen = [super cacheOpen];
        
    }
    
    return self;
}

#pragma mark - getter and setter
//- (id)httpRequestParams
//{
//
//    if (_httpRequestParams == nil) {
//        SHTTP_ASSERT(@"请给该变量赋值");
//    }
//    return _httpRequestParams;
//}
SHTTP_SETTER_OBJ(id, requestParams);
SHTTP_SETTER_OBJ(NSString *, requestUrl);
SHTTP_SETTER_OBJ(NSArray *,requestAuthorization);
SHTTP_SETTER_OBJ(NSDictionary *,requestExtendHeader);
SHTTP_SETTER_OBJ(NSString *,requestClassName);
SHTTP_SETTER_OBJ(NSString *,baseUrl);

//SHTTP_SETTER_CONST(NSTimeInterval, requestTimeoutInterval);
//SHTTP_SETTER_CONST(SHttpRequestDataType, requestDataType);
//SHTTP_SETTER_CONST(SHttpRequestMethod, requestMethod);
//SHTTP_SETTER_CONST(SHttpRequestSerizlization, requestSerizlization);
//SHTTP_SETTER_CONST(SHttpResponseSerialization, responseSerizlization);








@end
