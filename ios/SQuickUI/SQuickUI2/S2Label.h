//
//  S2Label.h
//  SQuickUI
//
//  Created by cs on 17/9/19.
//  Copyright © 2017年 cs. All rights reserved.
//

#import "S2Panel.h"

@interface S2Label : S2Panel

@property (nonatomic, copy) NSString *text;

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic) NSTextAlignment textAlignment;

@property (nonatomic)  NSLineBreakMode lineBreakMode;

@property (nonatomic, copy) NSAttributedString *attributedText;

@property (nonatomic) NSInteger numberOfLines;



@end
