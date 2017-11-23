//
//  S2Label.m
//  SQuickUI
//
//  Created by cs on 17/9/19.
//  Copyright © 2017年 cs. All rights reserved.
//

#import "S2Label.h"

#import "SPanelAsyncLayer.h"

@interface S2Label ()  {
    
}

@property (nonatomic, strong) NSDictionary *dictAttr;

@end

@implementation S2Label



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        [self _initLabel];
        self.frame = frame;
    }
    
    return self;
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

- (CGSize)sizeThatFits:(CGSize)size
{
    return [self sizeWithString:self.text];
}




- (void)drawRect:(CGRect)rect withContext:(CGContextRef)context
{

    CGRect realFrame = rect;

    
    //如果设置了属性字体
    if (self.attributedText) {
        [self.attributedText drawWithRect:realFrame options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  context:nil];
    } else {
        [self.text drawInRect:realFrame withAttributes:[self AttributesDict]];
    }
}



#pragma mark - 
- (void)setText:(NSString *)text
{
    if (_text == text || [_text isEqualToString:text]) {
        return;
    }
    
    _text = text.copy;
    
    if (self.displaysAsynchronously && self.clearContentsBeforeAsynchronouslyDisplay) {
        [self clearContents];
    }
    
    [self.layer setNeedsDisplay];
    [self invalidateIntrinsicContentSize];
}

#pragma mark -


- (void)_initLabel
{
    ((SPanelAsyncLayer *)self.layer).displaysAsynchronously = YES;
    self.layer.contentsScale = [UIScreen mainScreen].scale;
    self.contentMode = UIViewContentModeRedraw;
    
    _font = [self _defaultFont];
    _textColor = [UIColor blackColor];
    _numberOfLines = 1;
    _textAlignment = NSTextAlignmentNatural;
    _lineBreakMode = NSLineBreakByTruncatingTail;
    self.fadeOnAsynchronouslyDisplay = YES;
    self.clearContentsBeforeAsynchronouslyDisplay = YES;
}

- (UIFont *)_defaultFont
{
    return [UIFont systemFontOfSize:17];
}



@end
