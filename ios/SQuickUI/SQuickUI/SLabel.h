//
//  SLabel.h
//  SQuickUI
//
//  Created by cs on 17/9/13.
//  Copyright © 2017年 cs. All rights reserved.
//

#import "SPanel.h"

@interface SLabel : SPanel

@property (nonatomic, copy) NSString *text;

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic) NSTextAlignment textAlignment;

@property (nonatomic)  NSLineBreakMode lineBreakMode;

@property (nonatomic, copy) NSAttributedString *attributedText;

@property (nonatomic) NSInteger numberOfLines;

@property (nonatomic) BOOL autoHeight;

@end
