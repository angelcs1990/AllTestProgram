//
//  RegisterRequest.m
//  SNetworkDemo
//
//  Created by cs on 16/5/13.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "RegisterRequest.h"

@implementation RegisterRequest
- (void)dealloc
{
    static int i = 0;
    NSLog(@"%@", [NSString stringWithFormat:@"RegsiterRequest dealloc:%d", self.tag]);
    i++;
}
- (id)requestParams
{
//    return @{@"areaName":@"香洲区"};
    return nil;
}
- (NSString *)requestUrl
{
//    return @"zh-services/resources/integration";
    return @"";
}
- (SHttpRequestMethod)requestMethod
{
    return SHttpRequestMethodGet;
}
- (NSString *)baseUrl
{
//    return @"https://appyxjc.13322.com/app/bMatch/findBMatchPageList";
    return @"https://mobile.game1.1332255.com";
}

- (SHttpResponseSerialization)responseSerizlization
{
    return SHttpResponseSerializationHttp;
}

- (void)requestFailed:(SHttpBaseRequest *)request
{
    NSLog(@"xxx  http code:%ld", request.status.responseStatusCode);
}
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
