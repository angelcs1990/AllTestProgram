//
//  SSockBaseRequest.h
//  SNetworkDemo
//
//  Created by cs on 16/5/24.
//  Copyright © 2016年 cs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SNetworkConfig.h"


////收到数据
typedef void(^SSockResponseData)(id responseData);
////数据处理进度
//typedef void(^SSockRequestBlockProgress)(id object);
////连接断开
//typedef void(^SSockRequestBlockDisconnect)(NSError *);
////连接ok
//typedef void(^SSockRequestBlockConnect)();


//返回数据无法传递给单个request，因为无法区分每个request请求
//除非服务器能给每个request增加标识,



@protocol SSockBaseRequestProtocol <NSObject>
@required
/**
 *  与服务器定义好的消息type
 *
 *  @return 消息Type
 */
- (NSInteger)requestMsgType; //消息返回类型

/**
 *  请求的数据类型
 *
 *  @return 数据类型
 */
- (NSInteger)requestDataType;
@optional
/**
 *  请求的参数
 *
 *  @return 自定义请求参数对象
 */
- (id)requestParams;

/**
 *  请求的服务器IP地址//IP address(暂时请用ip，不用dns)
 *
 *  @return 服务器ip
 */
- (NSString *)requestServerIP;

/**
 *  请求的服务器端口
 *
 *  @return  端口
 */
- (NSInteger)requestPort;

/**
 *  当前请求的类名
 *
 *  @return 类名
 */
- (NSString *)requestClassName;

/**
 *  请求间隔时间
 *
 *  @return 间隔时间
 */
- (NSTimeInterval)requestCacheTimeout;

/**
 *  还没有实现该api
 *
 *  @return 路径
 */
- (NSString *)requestDownloadPath;
@end

@interface SSockBaseRequest : NSObject<SSockBaseRequestProtocol>

//全局参数配置
@property (nonatomic, weak, readonly) SNetworkConfig *networkConfig;

//请求返回数据回调
@property (nonatomic, copy) SSockResponseData responseDataBlock;

//开始请求
- (void)start;
- (void)startWithoutCache;
- (void)startWithCompletionHandler:(SSockResponseData)block withoutCache:(BOOL)cache;
- (void)stop;   //stop取消一个连接，就是收到数据不会解析数据返回了，并不断开连接(注意：如果不需要该请求了，请主动调用stop）
- (void)disconnect;  //跟stop不同，他是断开一个连接，由于有多个request对应一个连接，因此断开连接后，其它的请求会失败
- (void)disconnectAll;   //断开所有连接,如果只有一个连接，那么该函数跟disconnect一样效果
@end
