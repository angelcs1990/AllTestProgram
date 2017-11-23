//
//  SPopView.m
//  STabViewDemo
//
//  Created by cs on 16/10/31.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "SPopView.h"


#pragma mark - _SPopViewController

@interface _SPopViewController : UIViewController

@end

@implementation _SPopViewController

- (UIStatusBarStyle)preferredStatusBarStyle {   //设置样式
    
    return UIStatusBarStyleLightContent;
    
}

@end



#pragma mark - SPopViewConainter
@implementation SPopViewConainter

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.windowLevel = UIWindowLevelAlert + 1;
        self.frame = [[UIScreen mainScreen] bounds];
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.8];
    }
    
    return self;
}

@end




#pragma mark - SPopView
@interface SPopView ()<UIGestureRecognizerDelegate>

@property (nonatomic, weak) id<SPopViewDelegate> child;

@property (nonatomic, strong) UIWindow *keepAlive;

@property (nonatomic, weak) UIView *viewContainerRef;

@end

@implementation SPopView

#pragma mark - 生命周期(SPopView)
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        if ([self conformsToProtocol:@protocol(SPopViewDelegate)]) {
            self.child = (id<SPopViewDelegate>)self;
        } else {
            NSAssert(0, @"请实现SPopViewDelegate协议");
        }

        _SPopViewController *vc = [_SPopViewController new];
        self.rootViewController = vc;
        self.tapClose = NO;
        
//        [self popViewSetupUI];
    }
    
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        if ([self conformsToProtocol:@protocol(SPopViewDelegate)]) {
            self.child = (id<SPopViewDelegate>)self;
        } else {
            NSAssert(0, @"请实现SPopViewDelegate协议");
        }
        
        _SPopViewController *vc = [_SPopViewController new];
        self.rootViewController = vc;
        self.tapClose = NO;
    }
    
    return self;
}

#pragma mark - 公共方法(SPopView)
- (void)show
{
    self.keepAlive = self;
    [self makeKeyAndVisible];
    
    if ([self.child respondsToSelector:@selector(popShowAnimation)]) {
        [self.child popShowAnimation];
    }
}

- (void)close
{
    if ([self.child respondsToSelector:@selector(popCloseAnimationCompletion:)]) {
        [self.child popCloseAnimationCompletion:^(BOOL finished) {
            [self setHidden:YES];
            self.keepAlive = nil;
        }];
        
    } else {
        [self setHidden:YES];
        self.keepAlive = nil;
    }
    
    
}

- (void)setNeedUpdateUI
{
    if (self.child && [self.child respondsToSelector:@selector(popSubView)]) {
        UIView *subView = [self.child popSubView];
        if (subView != nil) {
            if (self.viewContainerRef == nil || self.viewContainerRef != subView) {
                [self.rootViewController.view addSubview:subView];
                
                self.viewContainerRef = subView;
                
                [self SPopView_addTapGesture];
            }
        }
    }
}

- (CGFloat)titleHeightWithFont:(UIFont *)font
{
    int width = self.frame.size.width;
    
    NSDictionary *dict = @{NSFontAttributeName:font};
    CGSize msgSize = [@"A" boundingRectWithSize:CGSizeMake(width, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
    
    return msgSize.height;
}

#pragma mark - 私有方法(SPopView)
- (void)SPopView_addTapGesture
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SPopView_handleSingleTap:)];
    [self addGestureRecognizer:singleTap];
    singleTap.delegate = self;
}

#pragma mark - 事件方法(SPopView)
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if(CGRectContainsPoint(self.viewContainerRef.frame, [touch locationInView:self]))
    {
        return NO;
    }
    
    return YES;
}

- (void)SPopView_handleSingleTap:(UITapGestureRecognizer *)sender
{
    if (self.tapClose) {
        [self close];
    }
    
}

@end





