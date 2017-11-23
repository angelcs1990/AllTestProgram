//
//  GetImageRequest.m
//  SNetworkDemo
//
//  Created by cs on 16/5/17.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "GetImageRequest.h"

@implementation GetImageRequest

- (void)dealloc
{
    NSLog(@"GetImageRequest dealloc");
}

- (NSString *)requestUrl
{
    return @"lj1111djs12.jpg";
}
- (SHttpRequestMethod)requestMethod
{
    return SHttpRequestMethodGet;
}
//- (NSString *)baseUrl
//{
//    return @"http://images.17173.com/2015/news/2015/11/11/";
//}

- (SHttpRequestDataType)requestDataType
{
    return SHttpRequestDataTypeFile;
}

- (NSString *)requestDownloadPath
{
    NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cachePath = [libPath stringByAppendingPathComponent:@"Caches"];
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"cs.jpg"];
    return filePath;
}
- (void)start
{
    [super start];
    self.image = nil;
}
//#pragma mark - 
//- (void)requestFailed:(SHttpBaseRequest *)request
//{
//    NSLog(@"http err:%@", request.status.requestError);
//}
- (void)requestFinished:(SHttpBaseRequest *)request
{
    NSLog(@"http code:%ld", request.status.responseStatusCode);
}
#pragma mark - getter and setter
- (UIImage *)image
{
    if (_image == nil) {
        _image = [UIImage imageWithContentsOfFile:[self requestDownloadPath]];
    }
    
    return _image;
}
@end
