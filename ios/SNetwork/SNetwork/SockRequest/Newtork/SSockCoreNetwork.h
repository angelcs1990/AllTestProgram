//
//  SSockCoreNetwork.h
//  SNetworkDemo
//
//  Created by cs on 16/5/24.
//  Copyright © 2016年 cs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSockNetworkProtocol.h"


@interface TestRequest : SSockBaseRequest
@property (nonatomic, copy) NSString *sendData;
@property (nonatomic) NSInteger type;
@end


@protocol SSockRequestDelegate;

@interface SSockPackage : NSObject<SSockNetworkPackageDelegate>

@end
@interface SSockCoreNetwork : NSObject<SSockNetworkProtocol>
//@property (nonatomic, strong) id<SSockDataEncodeDelegate> encode;
//@property (nonatomic, strong) id<SSockDataDecodeDelegate> decode;
//@property (nonatomic, strong) id<SSockMsgDispatchDelegate> msgDispatch;
@property (nonatomic, strong) id<SSockNetworkPackageDelegate> packageDelegate;
@property (nonatomic, weak) id<SSockRequestDelegate> responseDelegate;
@end