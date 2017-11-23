//
//  SHttpRequestProtocol.h
//  SNetworkDemo
//
//  Created by cs on 16/5/16.
//  Copyright © 2016年 cs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHttpRequestPublicDefine.h"






//@protocol SHttpRequestConstructBody <NSObject>
//
//- (void)httpRequestConstructBody:(id)object;
//
//@end

//=============================
#pragma mark -
/**
 *  基本接口协议
 */
@protocol SHttpRequestProtocol <NSObject>

@required
/**
 *  请求的参数，没有可以返回空
 *
 *  @return 请求参数
 */
- (id)requestParams;

/**
 *  请求的路径
 *
 *  @return 路径地址
 */
- (NSString *)requestUrl;

/**
 *  请求的操作类型
 *
 *  @return 操作类型
 */
- (SHttpRequestMethod)requestMethod;



@optional
- (BOOL)cacheOpen;

/**
 *  序列化类型
 *
 *  @return 序列化类型
 */
- (SHttpRequestSerizlization)requestSerizlization;
- (SHttpResponseSerialization)responseSerizlization;


/**
 *  请求成功后的缓存时间，只有超过该时间才会再次请求
 *
 *  @return 缓存时间
 */
- (NSTimeInterval)requestCacheTimeout;
- (NSString *)requestDownloadPath;
- (void)requestConstructBody:(id)object;
/**
 *  请求服务器的用户名和密码
 *
 *  @return 用户名密码
 */
- (NSArray *)requestAuthorization;

/**
 *  请求头扩展
 *
 *  @return 扩展的请求头数据
 */
- (NSDictionary *)requestExtendHeader;

/**
 *  请求类的类名，在网络模块中可以根据具体的类名进行其它扩展操作
 *
 *  @return 类名
 */
- (NSString *)requestClassName;


/**
 *  网络URL地址，如果实现了会替换全局设置的URL地址
 *
 *  @return URL地址
 */
- (NSString *)baseUrl;


/**
 *  超时时间，如果实现了会替换全局设置的超时时间
 *
 *  @return 超时时间
 */
- (NSTimeInterval)requestTimeoutInterval;

/**
 *  数据请求类型
 *
 *  @return 数据请求类型
 */
- (SHttpRequestDataType)requestDataType;

/**
 *  请求的开始与取消
 */
- (void)start;
- (void)startWithoutCache;
- (void)stop;

@end
