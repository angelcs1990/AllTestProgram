//
//  SHttpRequestPublicDefine.h
//  SNetworkDemo
//
//  Created by cs on 16/5/16.
//  Copyright © 2016年 cs. All rights reserved.
//

#ifndef SHttpRequestPublicDefine_h
#define SHttpRequestPublicDefine_h

#ifndef weakSelf
#define weakSelf(_v) autoreleasepool{} __weak typeof (_v) _v##_weakSelf = _v
#endif

#ifndef strongSelf
#define strongSelf(_v) try{} @finally{} __strong typeof(_v) _v = _v##_weakSelf
#endif
/**
 *  请求方法
 */
typedef NS_ENUM(NSInteger, SHttpRequestMethod) {
    SHttpRequestMethodNone = -1,
    SHttpRequestMethodGet,
    SHttpRequestMethodPost,
    SHttpRequestMethodHead,
    SHttpRequestMethodPut,
    SHttpRequestMethodDelete,
    SHttpRequestMethodPatch
};


typedef NS_ENUM(NSInteger, SHttpRequestSerizlization){
    SHttpRequestSerizlizationNone = -1,
    SHttpRequestSerializerHttp,
    SHttpRequestSerializerJson,
    SHttpRequestSerializerPropertyList
};

typedef NS_ENUM(NSInteger, SHttpResponseSerialization){
    SHttpResponseSerializationNone = -1,
    SHttpResponseSerializationHttp,
    SHttpResponseSerializationJson,
    SHttpResponseSerializationXML,
    SHttpResponseSerializationPropertyList,
    SHttpResponseSerializationImage
};

typedef NS_ENUM(NSInteger, SHttpRequestSessionState){
    SHttpRequestSessionStateNone = -1,
    SHttpRequestSessionStateRunning = 0,    /* The task is currently being serviced by the session */
    SHttpRequestSessionStateSuspended,
    SHttpRequestSessionStateCanceling,  /* The task has been told to cancel.  The session will receive a URLSession:task:didCompleteWithError: message. */
    SHttpRequestSessionStateCompleted,
};
/**
 *  请求数据类型
 */
typedef NS_ENUM(NSInteger, SHttpRequestDataType) {
    SHttpRequestDataTypeNone = -1,
    /**
     *  文件类型（包括图片文件，文本文件等等文件）
     */
    SHttpRequestDataTypeFile,
    /**
     *  普通数据类型
     */
    SHttpRequestDataTypeData
};


#endif /* SHttpRequestPublicDefine_h */
