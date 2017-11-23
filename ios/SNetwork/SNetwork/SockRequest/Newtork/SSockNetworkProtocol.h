//
//  SSockNetworkProtocol.h
//  SNetworkDemo
//
//  Created by cs on 16/5/26.
//  Copyright © 2016年 cs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSockBaseRequest.h"

@protocol SSockNetworkProtocol <NSObject>


- (void)sendRequest:(SSockBaseRequest *)request;
- (void)cancelRequest:(SSockBaseRequest *)request;

- (void)disconnectRequest:(SSockBaseRequest *)request;
- (void)disconnectAll;
@end





///**
// *  数据解析后进行消息分发
// */
//@protocol SSockMsgDispatchDelegate <NSObject>
//
///**
// *  消息分发
// *
// *  @param data 解码后的数据
// */
//- (void)msgDispatch:(id)data;
//
//@end

@interface SSockNetworkPackageLengthInfo : NSObject
+ (instancetype)packageLengthInfo;
//包的长度
@property (nonatomic) NSUInteger packageLength;
//包长度所占字节数
@property (nonatomic) NSUInteger packageOffset;
//是否忽略该包
@property (nonatomic) BOOL  packageIgnore;
@end

@protocol SSockNetworkPackageDelegate <NSObject>
@required
/**
 *  消息分发
 *
 *  @param data 解码后的数据
 */
- (void)msgDispatch:(id)data;

/**
 *  数据长度信息获取
 *
 *  @param data 原始数据
 *
 *  @return 数据长度信息
 */
- (SSockNetworkPackageLengthInfo *)packageLength:(id)data;
@optional
/**
 *  数据编码
 *
 *  @param oriData 未编码数据
 *
 *  @return 编码后的数据
 */
- (id)sockDataEncode:(id)oriData;

/**
 *  数据解码
 *
 *  @param oriData 未解码的数据
 *
 *  @return 解码后的数据
 */
- (id)sockDataDecode:(id)oriData;
@end



//@protocol SSockDataEncodeDelegate <NSObject>
//
//- (id)sockDataEncode:(id)oriData;
//
//@end
//
//@protocol SSockDataDecodeDelegate <NSObject>
//
//- (id)sockDataDecode:(id)oriData;
//
//@end




