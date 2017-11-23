//
//  SBaseRequest.h
//  SNetworkDemo
//
//  Created by cs on 16/5/12.
//  Copyright © 2016年 cs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHttpRequestProtocol.h"
#import "SNetworkConfig.h"

#pragma mark -
@class SHttpBaseRequest;

/**
 *  数据转换协议
 */
@protocol SDataReformerDelegate <NSObject>

@optional
//- (id)reformerDatafromRequest:(SHttpBaseRequest *)request;
- (id)reformerData:(id)data;
//- (id)reformerData;
@end


#pragma mark -
/**
 *  网络状态信息
 */
@interface SRequestStatus : NSObject
@property (nonatomic, assign) SHttpRequestSessionState requestSessionState;
@property (nonatomic, strong) NSError *requestError;
@property (nonatomic, assign) NSInteger responseStatusCode;
@end

#pragma mark -
/**
 *  返回数据的
 */
@interface SResponseData : NSObject
@property (nonatomic, weak) id<SDataReformerDelegate> reformerDelegate;
@property (nonatomic, copy) id orignalData;    //原始数据
@property (nonatomic, strong) id reformedData;
@end






#pragma mark -
/**
 *  请求状态协议
 */
@protocol SRequestDelegate <NSObject>

@optional
- (void)requestFinished:(SHttpBaseRequest *)request;
- (void)requestFailed:(SHttpBaseRequest *)request;
- (void)requestProgress:(SHttpBaseRequest *)request withProgress:(NSProgress *)progress;

@end


typedef void(^SRequestBlockFinished)(SHttpBaseRequest *, id object);
typedef void(^SRequestBlockFailed)(SHttpBaseRequest *, NSError *);
typedef void(^SRequestBlockProgress)(SHttpBaseRequest *, NSProgress *);

#pragma mark -
typedef void(^SRequestBlockNetworkManagerObject)(id obj);



/**
 *  请求基类
 */
@interface SHttpBaseRequest : NSObject<SHttpRequestProtocol>


//内部用的
@property (nonatomic, copy, readonly) SRequestBlockFinished blockFinished;
@property (nonatomic, copy, readonly) SRequestBlockFailed blockFailed;
@property (nonatomic, copy, readonly) SRequestBlockProgress blockProgress;

//公开用的
/**
 *  如果需需直接设置具体网络类的参数，用该block实现，block参数即是具体网络实例类
 */
@property (nonatomic, copy) SRequestBlockNetworkManagerObject blockNetworkManager;

@property (nonatomic, weak, readonly) SNetworkConfig *httpConfig;
@property (nonatomic, weak) id<SRequestDelegate> requestStatusDelegate;

@property (nonatomic, strong, readonly) SRequestStatus *status;
@property (nonatomic, strong, readonly) SResponseData  *responseData;

- (void)startWithCompletionBlock:(SRequestBlockFinished)finishBlock progress:(SRequestBlockProgress)progress failed:(SRequestBlockFailed)failed;
@end
