//
//  SPopViewDemo.m
//  STabViewDemo
//
//  Created by cs on 17/2/25.
//  Copyright © 2017年 cs. All rights reserved.
//

#import "SPopViewDemo.h"

#pragma mark - SAlertPopView
@interface SPopViewDemo ()

@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UIImageView *imageViewIcon;
@property (nonatomic, strong) NSArray *arrayButtons;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *icon;

@property (nonatomic, copy) void (^block)(NSInteger buttonIdx);
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIView *containView;

@end

@implementation SPopViewDemo

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (void)dealloc
{
    NSLog(@"dealloc");
}

+ (instancetype)popViewWithTitle:(NSString *)title buttonTitles:(NSArray *)buttons clickBlock:(void(^)(NSInteger buttonIndex))block{
    SPopViewDemo *popView = [[[self class] alloc] initWithTitle:title buttonTitles:buttons clickBlock:block];
    
    [popView setNeedUpdateUI];
    
    return popView;
}

- (instancetype)initWithTitle:(NSString *)title buttonTitles:(NSArray *)buttons clickBlock:(void (^)(NSInteger))block
{
    self = [super init];
    if (self) {
        self.arrayButtons = buttons;
        self.title = title;
        self.block = block;
    }
    
    return self;
}



#pragma mark - 事件函数（用户）
- (void)buttonDidClicked:(id)sender
{
    if (self.block) {
        self.block(((UIButton *)sender).tag);
    }
    
    [self close];
    
}

#pragma mark - SPopViewDelegate
- (UIView *)popSubView
{
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor greenColor];
    view.layer.cornerRadius = 5.0f;
    view.layer.borderColor = [UIColor redColor].CGColor;
    self.view = view;
    view.layer.masksToBounds = YES;
    [self setupUI:view];
    
    return view;
}

- (void)popShowAnimation
{
    //    self.view.layer.anchorPoint = CGPointMake(0.5, 0.5);
    CGRect oldPt = self.view.frame;
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    CGRect rect = {oldPt.origin, CGSizeMake(0, 0)};
    rect.origin.x = (width / 2.0);
    rect.origin.y = (height / 2.0);
    self.view.frame = rect;
    self.containView.frame = CGRectMake(-(oldPt.size.width) / 2.0, -(oldPt.size.height) / 2.0, oldPt.size.width, oldPt.size.height);
    //    self.superview.frame = CGRectMake(self.superview.center.x, self.superview.center.y, 0, 0);
    self.view.alpha = 0;
    [UIView animateWithDuration:2 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        //        self.superview.frame = CGRectMake(x, y, width, height);
        self.view.frame = oldPt;
        self.containView.frame = CGRectMake(0, 0, oldPt.size.width, oldPt.size.height);
        self.view.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)popCloseAnimationCompletion:(void (^)(BOOL))completion
{
    [UIView animateWithDuration:0.5 animations:^{
        self.view.frame = CGRectMake(-self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        completion(finished);
    }];
}

#pragma mark - 私有函数（初始化）
- (void)setupUI:(UIView *)view
{
    self.containView = [UIView new];
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGFloat width = 260.0f;
    CGFloat height = 140.5f;
    CGFloat xPos = (rect.size.width - width) / 2.0f;
    CGFloat yPos = (rect.size.height - height) / 2.0f;
    view.frame = CGRectMake(xPos, yPos, width, height);
    
    [view addSubview:self.containView];
    UIView *titleContainer = [UIView new];
    //    self.containView.backgroundColor = [UIColor redColor];
    
    self.labelTitle.text = self.title;
    
    self.labelTitle.textColor = [UIColor redColor];
    
    [self.containView addSubview:titleContainer];
    
    [titleContainer addSubview:self.labelTitle];
    
    
    NSDictionary *dict = @{NSFontAttributeName:self.labelTitle.font};
    CGSize msgSize = [self.title boundingRectWithSize:CGSizeMake(width, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
    
    titleContainer.frame = CGRectMake(0, 40.5, width, msgSize.height);
    titleContainer.backgroundColor = [UIColor yellowColor];
    self.labelTitle.frame = titleContainer.bounds;
    
    
    if (self.arrayButtons.count == 2) {
        [self.arrayButtons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *button = [UIButton new];
            [button setTitle:obj forState:UIControlStateNormal];
            [button setTag:idx];
            button.backgroundColor = [UIColor blueColor];
            button.layer.cornerRadius = 3.0f;
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            [self.containView addSubview:button];
            [button addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            if (idx == 0) {
                button.frame = CGRectMake(titleContainer.frame.size.width - 21.5 / 2.0 - 103.5, titleContainer.frame.origin.y +titleContainer.frame.size.height + 31, 103.5, 32);
            } else {
                button.frame = CGRectMake(21.5 / 2.0,titleContainer.frame.origin.y + titleContainer.frame.size.height + 31, 103.5, 32);
            }
            
        }];
    } else if (self.arrayButtons.count == 1) {
        UIButton *button = [UIButton new];
        [button setTitle:self.arrayButtons[0] forState:UIControlStateNormal];
        [button setTag:0];
        button.backgroundColor = [UIColor blueColor];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        button.layer.cornerRadius = 3.0f;
        [button addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.containView addSubview:button];
        button.frame = CGRectMake((titleContainer.frame.size.width - 2 * 103.5) / 2.0, titleContainer.frame.origin.y +titleContainer.frame.size.height + 31, 2 * 103.5, 32);
        
    }
    
    
    //        [self layoutIfNeeded];
    [view setBounds:CGRectMake(0, 0, width, height + self.labelTitle.frame.size.height - [self titleHeightWithFont:self.labelTitle.font])];
    self.containView.frame = view.bounds;
}

#pragma mark - setter and getter
- (UILabel *)labelTitle
{
    if (_labelTitle == nil) {
        _labelTitle = [UILabel new];
        _labelTitle.textAlignment = NSTextAlignmentCenter;
        _labelTitle.numberOfLines = 0;
        _labelTitle.font = [UIFont systemFontOfSize:16];
        _labelTitle.textColor = [UIColor blackColor];
    }
    
    return _labelTitle;
}

- (UIImageView *)imageViewIcon
{
    if (_imageViewIcon == nil) {
        _imageViewIcon = [UIImageView new];
    }
    
    return _imageViewIcon;
}

@end
