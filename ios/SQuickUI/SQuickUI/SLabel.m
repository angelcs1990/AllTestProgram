//
//  SLabel.m
//  SQuickUI
//
//  Created by cs on 17/9/13.
//  Copyright © 2017年 cs. All rights reserved.
//

#import "SLabel.h"
#import "SPanel+Geometry.h"

@interface SLabel ()

@property (nonatomic, strong) NSDictionary *dictAttr;

@end

@implementation SLabel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupValue];
    }
    
    return self;
}

- (void)setupValue
{
    self.font = [UIFont systemFontOfSize:10];
    self.textColor = [UIColor blackColor];
    self.textAlignment = NSTextAlignmentLeft;
    self.lineBreakMode = NSLineBreakByWordWrapping;
    self.numberOfLines = 1;
    self.autoHeight = YES;
    self.dictAttr = nil;
}

- (BOOL)updateSelfFrame
{
    //如果没有给宽度跟高度就自己计算
    if ((self.text.length != 0 || self.attributedText.length != 0) && (self.width == 0 || self.height == 0)) {
        CGSize tmpSize = [self sizeWithString:self.text];
        if (self.width == 0) {
            self.width = tmpSize.width;
        }
        if (self.height == 0) {
            self.height = tmpSize.height;
        }
        
        return YES;
    }
    
    return NO;
}

- (void)drawRect:(CGRect)rect withContext:(CGContextRef)context
{
    BOOL bRet = [self updateSelfFrame];
    CGRect realFrame = rect;
    if (bRet) {
        realFrame.origin = rect.origin;
        realFrame.size = self.frame.size;
    }
    
    //如果设置了属性字体
    if (self.attributedText) {
        [self.attributedText drawWithRect:realFrame options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  context:nil];
    } else {
        [self.text drawInRect:realFrame withAttributes:[self AttributesDict]];
    }
}

- (NSDictionary *)AttributesDict
{
    if (_dictAttr == nil) {
        NSMutableParagraphStyle* paragraphStyleDesc = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyleDesc.lineBreakMode = self.lineBreakMode;
        paragraphStyleDesc.alignment = self.textAlignment;
        
        _dictAttr = @{NSFontAttributeName:self.font,NSParagraphStyleAttributeName:paragraphStyleDesc,  NSForegroundColorAttributeName:self.textColor};
    }
    
    return _dictAttr;
}

- (CGSize)sizeWithString:(NSString *)str
{
    CGRect textBounds = [str boundingRectWithSize:CGSizeZero options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[self AttributesDict] context:nil];
    
    return textBounds.size;
}


- (CGSize)size
{
    if (CGSizeEqualToSize([super size], CGSizeZero)) {
        [self updateSelfFrame];
    }
    
    return [super size];
}

@end
