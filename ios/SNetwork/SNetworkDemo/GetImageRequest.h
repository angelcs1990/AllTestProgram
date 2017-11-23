//
//  GetImageRequest.h
//  SNetworkDemo
//
//  Created by cs on 16/5/17.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "SHttpBaseRequest.h"
#import <UIKit/UIKit.h>

@interface GetImageRequest : SHttpBaseRequest<SRequestDelegate>
@property (nonatomic, strong) UIImage *image;

@end
