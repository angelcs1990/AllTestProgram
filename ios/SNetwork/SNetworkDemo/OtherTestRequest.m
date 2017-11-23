//
//  OtherTestRequest.m
//  SNetworkDemo
//
//  Created by cs on 16/5/25.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "OtherTestRequest.h"

@implementation OtherTestRequest
- (void)dealloc
{
    NSLog(@"OtherTestRequest dealloc");
}
//- (id)requestParams
//{
//    return @{@"areaName":@"香洲区"};
//}
- (NSString *)requestUrl
{
    return @"zh-services/resources/warning";
}
- (SHttpRequestMethod)requestMethod
{
    return SHttpRequestMethodGet;
}
- (NSString *)baseUrl
{
    return @"http://14.29.65.10:8089/";
}

//- (void)requestConstructBody:(id)object
//{
//    //    id<AFmultipartFormData> formData = object;
//}

- (void)requestFinished:(SHttpBaseRequest *)request
{
    NSLog(@"http code:%ld", request.status.responseStatusCode);
}
#pragma mark -
- (id)reformerData
{
    //    NSString *reuslt = self.responseData.orignalData[@"result"];
    return @{@"result":@"RegisterRequest look"};
}
@end
