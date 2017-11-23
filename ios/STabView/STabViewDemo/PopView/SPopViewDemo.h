//
//  SPopViewDemo.h
//  STabViewDemo
//
//  Created by cs on 17/2/25.
//  Copyright © 2017年 cs. All rights reserved.
//

#import "SPopView.h"

@interface SPopViewDemo : SPopView<SPopViewDelegate>

+ (instancetype)popViewWithTitle:(NSString *)title buttonTitles:(NSArray *)buttons clickBlock:(void(^)(NSInteger buttonIndex))block;

@end
