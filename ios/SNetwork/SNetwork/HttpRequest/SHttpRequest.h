//
//  SRequest.h
//  SNetworkDemo
//
//  Created by cs on 16/5/12.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "SHttpBaseRequest.h"

/**
 *  通用实现，不需要继承Request类，只需要设置一些属性值就可以起飞了
 *  如果需要更多的自定义属性，请自行继承实现
 */
@interface SHttpRequest : SHttpBaseRequest
@property (nonatomic, strong)   id requestParams;
@property (nonatomic, copy)     NSString *requestUrl;
@property (nonatomic, assign)   SHttpRequestMethod requestMethod;
@property (nonatomic, assign)   SHttpRequestSerizlization requestSerizlization;
@property (nonatomic, assign)   SHttpResponseSerialization responseSerizlization;
@property (nonatomic, copy)     NSArray *requestAuthorization;
@property (nonatomic, copy)     NSDictionary *requestExtendHeader;
@property (nonatomic, assign)   BOOL cacheOpen;
@property (nonatomic, copy)     NSString *requestClassName;
@property (nonatomic, copy)     NSString *baseUrl;
@property (nonatomic, assign)   NSTimeInterval requestTimeoutInterval;
@property (nonatomic, assign)   SHttpRequestDataType requestDataType;

@end







