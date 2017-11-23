//
//  SSockCoreNetwork.m
//  SNetworkDemo
//
//  Created by cs on 16/5/24.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "SSockCoreNetwork.h"
#import "SSockBaseRequest.h"
#import "GCDAsyncSocket.h"
#import "SSockRequestAgent.h"
#import <libkern/OSAtomic.h>

#define NO_SINGLE_REQUEST_RESPONSE
//#pragma mark - 
//#pragma mark - MsgDispatch
//@implementation SSockMsgDispatch
//- (void)msgDispatch:(id)data
//{
//    
//}
//@end

#pragma mark - 
#pragma mark - Encode or Decode
@implementation SSockPackage
- (void)msgDispatch:(id)data
{
    //分发消息给上层
    NSDictionary *msg = (NSDictionary *)data;
    NSInteger type = [msg[@"type"] integerValue];
    switch (type) {
        case 1:
            
            break;
        case 2:
            break;
        default:
            break;
    }
}
- (SSockNetworkPackageLengthInfo *)packageLength:(id)data
{
    NSUInteger packLen = 0;
    [data getBytes:&packLen length:4];
    
    SSockNetworkPackageLengthInfo *sinfo = [SSockNetworkPackageLengthInfo packageLengthInfo];
    sinfo.packageLength = packLen;
    sinfo.packageOffset = 4;
    
    char startFlag[3] = {0};
    [data getBytes:startFlag range:NSMakeRange(4, 2)];
    if (strcmp(startFlag, "cs") != 0) {
        sinfo.packageIgnore = YES;
    }
    
    return sinfo;
}
- (id)sockDataEncode:(id)oriData
{
//    return nil;
    
    NSString *content = [oriData objectForKey:@"content"];
    
    NSData *data = [content dataUsingEncoding: NSUTF8StringEncoding];
    char *startFlag = "cs";
    char *endFlag = "sc";
    NSUInteger dataLen = [data length];
    NSUInteger packLen = dataLen + 2 + 2 + 4 + 4;
    NSUInteger operType = [[oriData objectForKey:@"type"] unsignedLongValue];
    
    NSMutableData *sendData = [[NSMutableData alloc] init];
    [sendData appendBytes:&packLen length:4];
    [sendData appendBytes:startFlag length:2];
    [sendData appendBytes:&operType length:4];
    [sendData appendBytes:&dataLen length:4];
    [sendData appendData:data];
    [sendData appendBytes:endFlag length:2];
    return sendData;
}
- (id)sockDataDecode:(id)oriData
{
    //    NSData *tmpData = oriData;
    //    return [[NSString alloc] initWithData:oriData encoding:NSUTF8StringEncoding];
    NSData *data = oriData;
    NSUInteger operType = 0;
//    char *param = NULL;
    char param[1024] = {0};
    NSUInteger packLen = 0;
    NSUInteger dataLen = 0;
    char startFlag[3] = {0};
    char endFlag[3] = {0};
    int idx = 4;
    [data getBytes:&packLen length:idx];
    [data getBytes:startFlag range:NSMakeRange(idx,2)];
    BOOL bOk  = NO;
    
    @try {
        if (packLen > 0 && strcmp(startFlag, "cs") == 0) {
            idx += 2;
            [data getBytes:&operType range:NSMakeRange(idx, 4)];
            idx += 4;
            [data getBytes:&dataLen range:NSMakeRange(idx, 4)];
            idx += 4;
            
//            param = calloc(dataLen + 1, sizeof(char));
            if (dataLen > 1024) {
                NSException* exception = [NSException exceptionWithName:@"Big num" reason:@"数据超过1024了" userInfo:nil];
                @throw exception;
            }
            [data getBytes:param range:NSMakeRange(idx, dataLen)];
            idx += dataLen;
            [data getBytes:endFlag range:NSMakeRange(idx, 2)];
            idx += 2;
            
            if (strcmp(endFlag, "sc") == 0) {
                bOk = YES;
                
//                [oriData setData:[data subdataWithRange:NSMakeRange(idx, data.length - idx)]];
            }
            
            
            
        }
    } @catch (NSException *exception) {
        
    } @finally {
        if (bOk) {
            NSString *paramstr = [[NSString alloc] initWithUTF8String:param];
            return @{@"type":@(operType), @"param":paramstr};
        } else {
            return nil;
        }
    }
    
}
@end
//@implementation SSockDataDecode
//
//- (id)sockDataDecode:(id)oriData
//{
////    NSData *tmpData = oriData;
////    return [[NSString alloc] initWithData:oriData encoding:NSUTF8StringEncoding];
//    NSData *data = oriData;
//    NSUInteger operType = 0;
//    char param[1024] = {0};
//    NSUInteger packLen = 0;
//    NSUInteger dataLen = 0;
//    char startFlag[3] = {0};
//    char endFlag[3] = {0};
//    int idx = 4;
//    [data getBytes:&packLen length:idx];
//    [data getBytes:startFlag range:NSMakeRange(idx,2)];
//    BOOL bOk  = NO;
//
//    @try {
//        if (packLen > 0 && strcmp(startFlag, "cs") == 0) {
//            idx += 2;
//            [data getBytes:&operType range:NSMakeRange(idx, 4)];
//            idx += 4;
//            [data getBytes:&dataLen range:NSMakeRange(idx, 4)];
//            idx += 4;
//            
//            [data getBytes:&param[0] range:NSMakeRange(idx, dataLen)];
//            idx += dataLen;
//            [data getBytes:endFlag range:NSMakeRange(idx, 2)];
//            idx += 2;
//            
//            if (strcmp(endFlag, "sc") == 0) {
//                bOk = YES;
//                
//                [oriData setData:[data subdataWithRange:NSMakeRange(idx, data.length - idx)]];
//            }
//            
//            
//            
//        } else {
//            int i = 0;
//        }
//    } @catch (NSException *exception) {
//
//    } @finally {
//        if (bOk) {
//            NSString *paramstr = [[NSString alloc] initWithUTF8String:param];
//            return @{@"type":@(operType), @"param":paramstr};
//        } else {
//            return nil;
//        }
//    }
//
//}
//
//@end












//=================================
#define LOCK_OPEN
#ifdef LOCK_OPEN
#define SSOCK_SPIN_INIT(_l) _l = OS_SPINLOCK_INIT
#define SSOCK_SPIN_LOCK(_l) OSSpinLockLock(&_l)
#define SSOCK_SPIN_UNLOCK(_l) OSSpinLockUnlock(&_l);
#else
#define SSOCK_SPIN_INIT(_l)
#define SSOCK_SPIN_LOCK(_l)
#define SSOCK_SPIN_UNLOCK(_l)
#endif

#pragma mark -
#pragma mark - _SSockSessionCache
@interface _SSockSessionCache : NSObject
@property (nonatomic, strong) NSMutableDictionary *sessionRecords; //sock纪录 hashKey(url)-socket
@property (nonatomic, strong) NSMutableDictionary *tagRequestRecords; //tag映射  tag-request
@property (nonatomic, strong) NSMutableDictionary<NSString * ,NSMutableArray *> *requestSendQueue;   //发送队列(hashKey(url)-request)


@end

@implementation _SSockSessionCache
{
    OSSpinLock _spinLockSession;
    OSSpinLock _spinLockRequest;
    OSSpinLock _spinLockSend;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
//        _spinLockSession = OS_SPINLOCK_INIT;
//        _spinLockRequest = OS_SPINLOCK_INIT;
//        _spinLockSend = OS_SPINLOCK_INIT;
        SSOCK_SPIN_INIT(_spinLockSession);
        SSOCK_SPIN_INIT(_spinLockRequest);
        SSOCK_SPIN_INIT(_spinLockSend);
    }
    
    return self;
}
- (void)cleanAll
{
//    [self.sessionRecords removeAllObjects];
//    [self.tagRequestRecords removeAllObjects];
//    [self.requestSendQueue removeAllObjects];
    
    [self cleanSession];
    [self cleanRequestCache];
    [self cleanRequestAndTag];
    
    
}
#pragma mark -
- (void)pushRequest:(SSockBaseRequest *)request sock:(NSString *)hashkey
{
    SSOCK_SPIN_LOCK(_spinLockSend);
    if ([self.requestSendQueue objectForKey:hashkey] ) {
        [[self.requestSendQueue objectForKey:hashkey] addObject:request];
    } else {
        [self.requestSendQueue setObject:[NSMutableArray arrayWithObject:request] forKey:hashkey];
    }
    SSOCK_SPIN_UNLOCK(_spinLockSend);
}
- (SSockBaseRequest *)popRequest
{
    SSOCK_SPIN_LOCK(_spinLockSend);
    if (self.requestSendQueue.count <= 0) {
        SSOCK_SPIN_UNLOCK(_spinLockSend);
        return nil;
    }
    
    __block SSockBaseRequest *request;
    [self.requestSendQueue enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSMutableArray * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.count > 0) {
            request = [obj objectAtIndex:0];
            [obj removeObjectAtIndex:0];
            *stop = YES;
        } else {
            [_requestSendQueue removeObjectForKey:key];
        }
    }];
    
    SSOCK_SPIN_UNLOCK(_spinLockSend);
    return request;
}
- (void)removeRequest:(SSockBaseRequest *)request
{
    SSOCK_SPIN_LOCK(_spinLockSend);
    if (request) {
        NSString *hashKey = [_SSockSessionCache hashKeyFromRequest:request];

        [[self.requestSendQueue objectForKey:hashKey] removeObject:request];
        
        if ([self.requestSendQueue objectForKey:hashKey].count == 0) {
            [self.requestSendQueue removeObjectForKey:hashKey];
        }
    }
    SSOCK_SPIN_UNLOCK(_spinLockSend);
}
- (void)removeRequestByKey:(NSString *)key
{
    SSOCK_SPIN_LOCK(_spinLockSend);
    if (key) {
        [self.requestSendQueue removeObjectForKey:key];
    }
    SSOCK_SPIN_UNLOCK(_spinLockSend);
}
- (void)cleanRequestCache
{
    SSOCK_SPIN_LOCK(_spinLockSend);
    [self.requestSendQueue removeAllObjects];
    SSOCK_SPIN_UNLOCK(_spinLockSend);
}
- (BOOL)requestCacheEmpty
{
    SSOCK_SPIN_LOCK(_spinLockSend);
    BOOL b =  (self.requestSendQueue.count == 0);
    SSOCK_SPIN_UNLOCK(_spinLockSend);
    return b;
}
#pragma mark -
- (void)addSessionTask:(GCDAsyncSocket *)task withKey:(NSString *)key
{
//    NSString *key = [self hashKeyFromRequest:request];
    SSOCK_SPIN_LOCK(_spinLockSession);
    if (task == nil || key == nil) {
        SSOCK_SPIN_UNLOCK(_spinLockSession);
        return;
    }
    [self.sessionRecords setObject:task forKey:key];
    SSOCK_SPIN_UNLOCK(_spinLockSession);
}
- (GCDAsyncSocket *)taskSession:(NSString *)key
{
    SSOCK_SPIN_LOCK(_spinLockSession);
    GCDAsyncSocket *sock = [self.sessionRecords objectForKey:key];
    SSOCK_SPIN_UNLOCK(_spinLockSession);
    return sock;
}
- (void)removeTaskSession:(GCDAsyncSocket *)sock
{
    SSOCK_SPIN_LOCK(_spinLockSession);
    [self.sessionRecords enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isEqual:sock]) {
            [self.sessionRecords removeObjectForKey:key];
            *stop = YES;
        }
    }];
    SSOCK_SPIN_UNLOCK(_spinLockSession);
}
- (void)removeSessionTaskWithKey:(NSString *)key
{
    SSOCK_SPIN_LOCK(_spinLockSession);
    if (key) {
        [self.sessionRecords removeObjectForKey:key];
    }
    SSOCK_SPIN_UNLOCK(_spinLockSession);
    
}
- (void)cleanSession
{
    SSOCK_SPIN_LOCK(_spinLockSession);
    [self.sessionRecords removeAllObjects];
    SSOCK_SPIN_UNLOCK(_spinLockSession);
}
#pragma mark -

//移动到request类
- (void)addRequest:(SSockBaseRequest *)request withTag:(NSString *)tag
{
    
    SSOCK_SPIN_LOCK(_spinLockRequest);
    if (request == nil || tag == nil) {
        SSOCK_SPIN_UNLOCK(_spinLockRequest);
        return;
    }
    [self.tagRequestRecords setObject:request forKey:tag];
    SSOCK_SPIN_UNLOCK(_spinLockRequest);
}
- (SSockBaseRequest *)requestForTag:(NSString *)tag;
{
    SSOCK_SPIN_LOCK(_spinLockRequest);
    SSockBaseRequest *request = [self.tagRequestRecords objectForKey:tag];
    SSOCK_SPIN_UNLOCK(_spinLockRequest);
    return request;
}
- (void)removeRequestTag:(NSString *)tag
{
    SSOCK_SPIN_LOCK(_spinLockRequest);
    [self.tagRequestRecords removeObjectForKey:tag];
    SSOCK_SPIN_UNLOCK(_spinLockRequest);
}
- (void)cleanRequestAndTag
{
    SSOCK_SPIN_LOCK(_spinLockRequest);
    [self.tagRequestRecords removeAllObjects];
    SSOCK_SPIN_UNLOCK(_spinLockRequest);
}

#pragma mark - tool method
+ (NSString *)tagFromRequest:(SSockBaseRequest *)request
{
    return [NSString stringWithFormat:@"%lu", [request hash]];
}
+ (NSString *)hashKeyFromRequest:(SSockBaseRequest *)request
{
    NSString *serverIP = [request requestServerIP];
    NSInteger port = [request requestPort];
    NSString *hashKey = [_SSockSessionCache hashKeyForUrl:serverIP port:port];
    
    return hashKey;
}
+ (NSString *)hashKeyForUrl:(NSString *)url port:(NSInteger)port
{
    NSString *hashString = [NSString stringWithFormat:@"%@:%ld", url, port];
    
    return [NSString stringWithFormat:@"%lu", [hashString hash]];
}

#pragma mark - setter and getter
- (NSMutableDictionary *)sessionRecords
{
    if (_sessionRecords == nil) {
        _sessionRecords = [NSMutableDictionary dictionary];
    }
    
    return _sessionRecords;
}
- (NSMutableDictionary *)tagRequestRecords
{
    if (_tagRequestRecords == nil) {
        _tagRequestRecords = [NSMutableDictionary dictionary];
    }
    
    return _tagRequestRecords;
}
- (NSMutableDictionary*)requestSendQueue
{
    if (_requestSendQueue == nil) {
        _requestSendQueue = [NSMutableDictionary dictionary];
    }
    
    return _requestSendQueue;
}
@end


//============================
#pragma mark -
#pragma mark - SSockCoreNetwork
@interface SSockCoreNetwork ()<GCDAsyncSocketDelegate>

//@property (nonatomic, strong) GCDAsyncSocket *ssocketAsync;
@property (nonatomic, strong) _SSockSessionCache *sessionCache;
@property (nonatomic, strong) NSMutableData *recvData;   //处理未完成粘包

@end
@implementation SSockCoreNetwork
{
    dispatch_queue_t _requestQueue;
    dispatch_queue_t _recvDealQueue;
}

#pragma mark - lifecycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        _requestQueue = dispatch_queue_create("com.cs.sock.request.queue", DISPATCH_QUEUE_SERIAL);
        _recvDealQueue = dispatch_queue_create("com.cs.sock.recvdata.queue", DISPATCH_QUEUE_SERIAL);
//        _recvData = [NSMutableData data];
    }
    
    return self;
}

#pragma mark - public method
- (void)sendRequest:(SSockBaseRequest *)request
{
    dispatch_async(_requestQueue, ^{
        [self runRequest:request];
    });
}
- (void)cancelRequest:(SSockBaseRequest *)request
{
    dispatch_async(_requestQueue, ^{
        [self runCancelRequest:request];
    });
}
- (void)disconnectRequest:(SSockBaseRequest *)request
{
    dispatch_async(_requestQueue, ^{
        [self runDisconnectRequest:request];
    });
}
- (void)disconnectAll
{
    dispatch_async(_requestQueue, ^{
        [self runDisconnectAll];
    });
}
#pragma mark - GCDAsyncSocketDelegate
//- (dispatch_queue_t)newSocketQueueForConnectionFromAddress:(NSData *)address onSocket:(GCDAsyncSocket *)sock
//{
//
//    return nil;
//}
//- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
//{
//    NSLog(@"连接成功");
//}
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"HOST连接成功");
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.responseDelegate) {
            [self.responseDelegate sockRequestDidConnect];
        }
    });
    
    
    [self handleWriteDataWithSock:sock];
    

    dispatch_async(dispatch_get_main_queue(), ^{
        //通知连接成功
    });
    
    
    
}
- (void)socket:(GCDAsyncSocket *)sock didConnectToUrl:(NSURL *)url
{
    NSLog(@"URL连接成功");
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.responseDelegate) {
            [self.responseDelegate sockRequestDidConnect];
        }
    });
    [self handleWriteDataWithSock:sock];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //通知连接成功
    });
}

//#define PACK_TEST_FAKE
- (id)fakePackTest:(int)index
{
    NSDictionary *testInData1 = @{@"type":@(1), @"content":@"I'm test1 Data-cs"};
    NSDictionary *testInData2 = @{@"type":@(2), @"content":@"I'm test2 Data-cs"};
    //假包测试
    NSData *testOutCompletionPackage1 = [self.packageDelegate sockDataEncode:testInData1];
    NSData *testOutCompletionPackage2 = [self.packageDelegate sockDataEncode:testInData2];
    NSData *testOutPartPackage1_1 = [testOutCompletionPackage1 subdataWithRange:NSMakeRange(0, 10)];
    NSData *testOutPartPackage1_2 = [testOutCompletionPackage1 subdataWithRange:NSMakeRange(10, testOutCompletionPackage1.length - 10)];
    NSData *testOutPartPackage2_1 = [testOutCompletionPackage2 subdataWithRange:NSMakeRange(0, 10)];
    NSData *testOutPartPackage2_2 = [testOutCompletionPackage2 subdataWithRange:NSMakeRange(10, testOutCompletionPackage2.length - 10)];
    
    NSMutableData *testData = [[NSMutableData alloc] init];
    //正确数据测试
    //测试1-一个包包含一个完整数据
    NSData *test0_1 = testOutCompletionPackage1;
    //测试2-一个包包含一个完整数据＋另一个包一部分数据
    [testData appendData:testOutCompletionPackage1];
    [testData appendData:testOutPartPackage2_1];
    NSData *test0_2 = [testData copy];//[NSData stringWithFormat:@"%@%@", testOutCompletionPackage1, testOutPartPackage2_1];
    //测试3-另一个包一部分数据＋一个完整数据
    testData = nil;
    testData = [[NSMutableData alloc] init];
    [testData appendData:testOutPartPackage2_2];
    [testData appendData:testOutCompletionPackage1];
    NSData *test0_3 = [testData copy];
    //测试4-部分数据＋部分数据
    testData = nil;
    testData = [[NSMutableData alloc] init];
    [testData appendData:testOutPartPackage2_1];
    [testData appendData:testOutPartPackage2_2];
    NSData *test0_4 = [testData copy];
    //测试5-两个或多个完整数据
    testData = nil;
    testData = [[NSMutableData alloc] init];
    [testData appendData:testOutCompletionPackage1];
    [testData appendData:testOutCompletionPackage2];
    NSData *test0_5 = [testData copy];
    //错误数据测试
    //测试1-全部错误
    testData = nil;
    testData = [[NSMutableData alloc] init];
    [testData appendBytes:"la ji - ji la" length:13];
    NSData *test1_1 = [testData copy];
    //测试2-错误数据＋一个完整包（该完整包）
    testData = nil;
    testData = [[NSMutableData alloc] init];
    [testData appendBytes:"la ji - ji la" length:13];
    [testData appendData:testOutCompletionPackage1];
    NSData *test1_2 = [testData copy];
    //测试3-完整包＋错误数据（应该可以解析出该完整包，跟下一个完整包）
    testData = nil;
    testData = [[NSMutableData alloc] init];
    [testData appendData:testOutCompletionPackage1];
    [testData appendBytes:"la ji - ji la" length:13];
    NSData *test1_3 = [testData copy];
    //测试4-部分数据＋错误数据＋部分数据(解析不出的包）
    testData = nil;
    testData = [[NSMutableData alloc] init];
    [testData appendData:testOutPartPackage2_1];
    [testData appendBytes:"la ji - ji la" length:13];
    [testData appendData:testOutPartPackage2_2];
    
    NSData *test1_4 = [testData copy];
    
    
    NSArray *array = @[test0_1, test0_2, test0_3, test0_4, test0_5];
    if (index < array.count) {
        return array[index];
    }
    
    return nil;
    
}

- (void)unpackData:(NSData *)data
{
    NSDictionary *decodeDataTmp;
    SSockNetworkPackageLengthInfo *packInfo;
    packInfo = [self.packageDelegate packageLength:data];
    if (packInfo.packageLength <= data.length - packInfo.packageOffset) {
        //包含一个完整消息
        //清空缓存
        _recvData = nil;
        //解包
        if ([self.packageDelegate respondsToSelector:@selector(sockDataDecode:)]) {
            decodeDataTmp = [self.packageDelegate sockDataDecode:data];
        }
        //分发
        if (!decodeDataTmp) {
            return;
        }
//        [self.packageDelegate msgDispatch:decodeDataTmp];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.responseDelegate) {
                [self.responseDelegate sockRequestDidRecvData:decodeDataTmp];
            }
        });
        
//        NSLog(@"%@ 收到的数据:%@", @(-1), decodeDataTmp);
        //继续解下个包
        if (packInfo.packageLength + packInfo.packageOffset != data.length) {
            [self dealReadData:[data subdataWithRange:NSMakeRange(packInfo.packageLength + packInfo.packageOffset, data.length - (packInfo.packageLength + packInfo.packageOffset))] withTag:-1];
        }
    } else {
        //数据留到下一次解包
        if (self.recvData.length == 0) {
            [self.recvData appendData:data];
        } else {
            if (packInfo.packageIgnore == YES) {
                _recvData = nil;
            }
        }
    }

}
- (void)dealReadData:(NSData *)data withTag:(long)tag
{
#ifndef NO_SINGLE_REQUEST_RESPONSE
    //如果是服务器主动推消息，tag是0
    if (tag != 0 && [self.sessionCache requestForTag:[NSString stringWithFormat:@"%lu", tag]] == nil) {
        NSLog(@"%@-已经取消了请求", @(tag));
        return;
    }
#endif
    if (self.packageDelegate == nil || data.length == 0)
    {
        return;
    }
    

    if (self.recvData.length != 0) {
        //未完的包解析
        [self.recvData appendData:data];
        [self unpackData:self.recvData];
    } else {
        [self unpackData:data];
    }
    
    
//    //读取长度
//    NSInteger packLen = 0;
//    char startFlag[3]={0};
//    NSDictionary *decodeDataTmp;
//    
//    if (self.recvData.length > 0) {
//        //开始处理
//        if (self.recvData.length < 6) {
//            //包的长度太短了不够解析, 保存进缓存，等够了再解析
//            return;
//        }
//        //获取包大小
//        [self.recvData getBytes:&packLen length:4];
//        if (packLen <= 0) {
//            //这包有问题，不解析了直接可以扔包
//            self.recvData = nil;
//            return;
//        }
//        if (packLen > self.recvData.length) {
//            //草泥马，包还太短了，继续等
//            //避免接受过多数据
//            [_recvData getBytes:startFlag range:NSMakeRange(4,2)];
//            if (strcmp(startFlag, "cs") != 0) {
//                _recvData = nil;
//            }
//            return;
//        }
//        
//        //解包
//        decodeDataTmp = [self.decode sockDataDecode:_recvData];
//        if (decodeDataTmp != nil) {
//            //表示解析ok
//            
//            NSLog(@"%@ 收到的数据:%@", @(tag), decodeDataTmp);
//
//            //分发消息
//            [self.msgDispatch msgDispatch:decodeDataTmp];
//            
//            
//            if (_recvData.length > 0) {
//                //表示还有数据剩余
//                
//                [self dealReadData:_recvData withTag:tag];
//            }
//        } else {
//            //表示解析failed
//            _recvData = nil;
//            return;
//        }
//        
//    }
}
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"CURRENT Thread:%@", [NSThread currentThread]);
    
//    [self.recvData appendData:data];
#ifdef PACK_TEST_FAKE
    int i = 0;
    
    if (tag == 0) {
        [self dealReadData:data withTag:tag];
    } else {
        while (YES) {
            
            data = [self fakePackTest:i++];
            if (data == nil) {
                break;
            }
//            [self.recvData appendData:data];
            NSLog(@"测试%d", i);
            [self dealReadData:data withTag:tag];
            sleep(0.3);
        }
    }
    [self postReadOperationWithSock:sock tag:tag];
#else
    [self dealReadData:data withTag:tag];
    
    [self postReadOperationWithSock:sock tag:tag];
#endif

    
}
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"断开连接");
    NSLog(@"%@" ,sock.connectedHost);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.responseDelegate) {
            [self.responseDelegate sockRequestDidDisconnectWithError:err];
        }
    });
    //清理缓存
    
    [self.sessionCache removeTaskSession:sock];
    //不保存先前没有发完的数据
    [self.sessionCache cleanRequestCache];
    [self.sessionCache cleanRequestAndTag];
    
    //提供回调
    
}

//- (void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
//{
//    NSLog(@"连接成功");
//}
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"%@-数据发送成功:%@", @(tag), sock);
    
    
    //如果数据队列中有数据就继续发送
    if (![self.sessionCache requestCacheEmpty]) {
        [self handleWriteDataWithSock:sock];
    } else {
        [self postReadOperationWithSock:sock tag:tag];
    }

}

//- (void)socket:(GCDAsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
//{
//    NSLog(@"连接成功");
//}








- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutReadWithTag:(long)tag
                 elapsed:(NSTimeInterval)elapsed
               bytesDone:(NSUInteger)length
{
    return 0;
}
- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutWriteWithTag:(long)tag
                 elapsed:(NSTimeInterval)elapsed
               bytesDone:(NSUInteger)length
{
    return 0;
}
- (void)socketDidCloseReadStream:(GCDAsyncSocket *)sock
{
    NSLog(@"连接成功");
}



- (void)socketDidSecure:(GCDAsyncSocket *)sock
{
    NSLog(@"连接成功");
}


- (void)socket:(GCDAsyncSocket *)sock didReceiveTrust:(SecTrustRef)trust completionHandler:(void (^)(BOOL shouldTrustPeer))completionHandler
{
    NSLog(@"连接成功");
}
#pragma mark - private method

- (void)runRequest:(SSockBaseRequest *)request
{
    //是否存在sock
    NSString *hashKey = [_SSockSessionCache hashKeyFromRequest:request];
    GCDAsyncSocket *sock = [self.sessionCache taskSession:hashKey];
    if (sock == nil) {
        //新建连接
        sock = [self createNewConnect:request];
        
        //
        if (sock) {
            [self.sessionCache addSessionTask:sock withKey:hashKey];
            [self.sessionCache pushRequest:request sock:hashKey];
        }
        
    } else {
        //tag-request
        NSString *tag = [_SSockSessionCache tagFromRequest:request];
        [self.sessionCache addRequest:request withTag:tag];
        //发送数据
        if ([self.sessionCache requestCacheEmpty]) {
            [self sendDataWithRequest:request socket:sock];
        } else {
            [self.sessionCache pushRequest:request sock:hashKey];
        }
        
    }
}

- (void)runDisconnectAll
{
    [self.sessionCache.sessionRecords enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        GCDAsyncSocket *sock = (GCDAsyncSocket *)obj;
        [sock disconnect];
    }];
    
    [self.sessionCache cleanAll];
}
- (void)runDisconnectRequest:(SSockBaseRequest *)request
{
    NSString *hashKey = [_SSockSessionCache hashKeyFromRequest:request];
    GCDAsyncSocket *sock = [self.sessionCache taskSession:hashKey];
    
    
    [self runCancelRequest:request];
    [self.sessionCache removeSessionTaskWithKey:hashKey];

    
    [sock disconnect];
}

//应该没必要，到时候删除
- (void)runCancelRequest:(SSockBaseRequest *)request
{

    
    NSString *tag = [_SSockSessionCache tagFromRequest:request];
    [self.sessionCache removeRequestTag:tag];
    
    //取消发送队列中的所有该request
    [self.sessionCache removeRequest:request];
}

- (void)disconnectAllRequests
{}
- (void)sendDataWithRequest:(SSockBaseRequest *)request socket:(GCDAsyncSocket *)sock
{
    NSString *tag = [_SSockSessionCache tagFromRequest:request];
    
    //编码发送数据
    NSData *sendData = [self.packageDelegate sockDataEncode:[request requestParams]];
    NSLog(@"发送数据大小:%lu 数据内容：%@ tag:%@", [sendData length], [request requestParams], tag);
    [sock writeData:sendData withTimeout:-1 tag:[tag longLongValue]];
}


- (BOOL)retryConnectWithRequest:(SSockBaseRequest *)request
{
    //断开连接
    [self runDisconnectRequest:request];
    //重新连接
    [self runRequest:request];
    
    return YES;
}
- (GCDAsyncSocket *)createNewConnect:(SSockBaseRequest *)request
{
    NSString *serverIP = [request requestServerIP];
    NSInteger port = [request requestPort];
    
    return [self connectWithHost:serverIP port:port];
}

- (GCDAsyncSocket *)connectWithHost:(NSString *)hostName port:(NSInteger)port
{
    NSError *error = nil;
    //全局队列，要做数据同步处理，加锁(还未写)
//    GCDAsyncSocket *socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    GCDAsyncSocket *socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:_recvDealQueue];

    [socket connectToHost:hostName onPort:port error:&error];
    if (error) {
        //deal error
        return nil;
    }
    
    return socket;
}


- (void)handleWriteDataWithSock:(GCDAsyncSocket *)sock
{
    //如果队列中有数据，从队列中获取发送
    SSockBaseRequest *request = [self.sessionCache popRequest];
    NSString *tag;
    if (request) {
        tag = [_SSockSessionCache tagFromRequest:request];
        [self.sessionCache addRequest:request withTag:tag];
        
        NSString *hashKey = [_SSockSessionCache hashKeyFromRequest:request];
        GCDAsyncSocket *sendSock = [self.sessionCache taskSession:hashKey];
        [self sendDataWithRequest:request socket:sendSock];
    }
    
    [self postReadOperationWithSock:sock tag:[tag longLongValue]];
}

- (void)postReadOperationWithSock:(GCDAsyncSocket *)sock tag:(long)tag
{
    [sock readDataWithTimeout:-1 tag:tag];
}
#pragma mark - setter and getter
//- (GCDAsyncSocket *)ssocketAsync
//{
//    if (_ssocketAsync == nil) {
//        _ssocketAsync = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:_requestQueue];
//    }
//    return _ssocketAsync;
//}
- (NSMutableData *)recvData
{
    if (_recvData == nil) {
        _recvData = [NSMutableData data];
    }
    
    return _recvData;
}
- (_SSockSessionCache *)sessionCache
{
    if (_sessionCache == nil) {
        _sessionCache = [_SSockSessionCache new];
    }
    
    return _sessionCache;
}
- (id<SSockNetworkPackageDelegate>)packageDelegate
{
    if (_packageDelegate == nil) {
        _packageDelegate = [SSockPackage new];
    }
    
    return _packageDelegate;
}
//- (id<SSockDataDecodeDelegate>)decode
//{
//    if (_decode == nil) {
//        _decode = [SSockDataDecode new];
//    }
//    
//    return _decode;
//}
//- (id<SSockDataEncodeDelegate>)encode
//{
//    if (_encode == nil) {
//        _encode = [SSockDataEncode new];
//    }
//    
//    return _encode;
//}
//- (id<SSockMsgDispatchDelegate>)msgDispatch
//{
//    if (_msgDispatch == nil) {
//        _msgDispatch = [SSockMsgDispatch new];
//    }
//    
//    return _msgDispatch;
//}
@end

#pragma mark-
#pragma mark - test
@implementation TestRequest

- (void)dealloc
{
    NSLog(@"TestRequest dealloc");
}

- (id)requestParams
{
    return @{@"type":@(self.type), @"content":self.sendData};
}
- (NSString *)requestServerIP
{
//    return @"183.61.172.70";
    return @"127.0.0.1";
}
- (NSInteger)requestPort
{
//    return 5001;
    return 23434;
}
- (NSInteger)requestMsgType
{
    return self.type;
}
@end
