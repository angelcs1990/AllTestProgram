//
//  S2ImageView.h
//  SQuickUI
//
//  Created by cs on 17/9/20.
//  Copyright © 2017年 cs. All rights reserved.
//

#import "S2Panel.h"

@interface S2ImageView : S2Panel

@property (nonatomic, strong) UIImage *image;

- (instancetype)initWithImage:(nullable UIImage *)image;

@end
