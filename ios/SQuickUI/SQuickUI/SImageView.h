//
//  SImageView.h
//  SQuickUI
//
//  Created by cs on 17/9/13.
//  Copyright © 2017年 cs. All rights reserved.
//

#import "SPanel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SImageView : SPanel

@property (nonatomic, strong) UIImage *image;

- (instancetype)initWithImage:(nullable UIImage *)image;

@end

NS_ASSUME_NONNULL_END
