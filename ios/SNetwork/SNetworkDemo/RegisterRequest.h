//
//  RegisterRequest.h
//  SNetworkDemo
//
//  Created by cs on 16/5/13.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "SHttpRequest.h"



@interface RegisterRequest : SHttpBaseRequest<SDataReformerDelegate, SRequestDelegate>
@property (nonatomic, strong) NSString *tmpUrl;
@property (nonatomic, assign) NSInteger tag;
@end
