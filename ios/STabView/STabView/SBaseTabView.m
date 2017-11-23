//
//  SBaseTabView.m
//  STabViewDemo
//
//  Created by cs on 16/11/2.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "SBaseTabView.h"



@interface SBaseTabView ()

@property (nonatomic, weak) id<SBaseTabViewProtocol> protocol;

@property (nonatomic, strong) UIView *defaultView;

@property (nonatomic, strong) UIView *scrollHeaderContainer;

@property (nonatomic, strong) UIView *scrollHeaderBackContainer;

@end

@implementation SBaseTabView

+ (instancetype)tabViewWithFrame:(CGRect)frame withDefaultView:(UIView *)view
{
    SBaseTabView *tabView = [[[self class] alloc] initWithFrame:frame withDefaultView:view];
    
    return tabView;
}

+ (instancetype)tabViewWithFrame:(CGRect)frame
{
    return [[[self class] alloc] initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame withDefaultView:(UIView *)view
{
    self = [super initWithFrame:frame];
    if (self) {
        if ([self conformsToProtocol:@protocol(SBaseTabViewProtocol)]) {
            self.protocol = (id<SBaseTabViewProtocol>)self;
        } else {
            NSAssert(0, @"请实现SBaseTabViewProtocol协议");
        }
        
        self.defaultView = view;
        [self _setupUI];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame withDefaultView:nil];

    
    return self;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    if (self.params.autoAdjustsScrollViewInsets == NO) {
        for (UIView *next = [self superview]; next; next = next.superview) {
            UIResponder *nextResponder = [next nextResponder];
            if ([nextResponder isKindOfClass:[UIViewController class]]) {
                ((UIViewController *)nextResponder).automaticallyAdjustsScrollViewInsets = NO;
                break;
            }
        }
    }
}

- (void)dealloc
{
    NSLog(@"Dealloc");
}

#pragma mark - 公共方法
- (void)addTabMoreView:(UIView *)view
{
    self.more = view;
    
    [self addSubview:self.more];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - 事件响应
- (void)_tabButtonDidClicked:(id)sender
{
    _clickedState = YES;
    NSInteger tag = ((UIButton *)sender).tag - STABVIEW_BUTTON_TAG_BASE;
    _isScrolling = YES;
    self.currentIndex = tag;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _isScrolling = YES;
    float index = scrollView.contentOffset.x / scrollView.frame.size.width;
    [self baseTabViewMoveMaskToIndex:index];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    
    //界面宽度
    CGFloat viewWidth = self.frame.size.width;
    if (viewWidth == 0 || self.params == nil) {
        return;
    }
    
    //是否有额外的界面
    if (self.more) {
        viewWidth -= self.more.frame.size.width;
    }
    
    //是否有左右间隔
    viewWidth -= self.params.tabRightMargin;
    viewWidth -= self.params.tabLeftMargin;
    
    //分割线
    CGFloat splitWidth = 0.0;
    if(self.params.tabSplit) {
        splitWidth = self.params.tabSplit.frame.size.width;
    }
    
    //每个按钮的宽度
    CGFloat perWidth = 0;
    [self calcTitleWidths];
    
    if (self.titleWidths.count > self.currentIndex) {
        perWidth = [self.titleWidths[self.currentIndex] floatValue];
    }
    
    
    
    //按钮数量 X 按钮宽度 ＝ 所需宽度
    CGFloat totalWidth = 0;
    for (int i = 0; i < self.titleWidths.count; ++i) {
        totalWidth += [self.titleWidths[i] floatValue];
    }
    
    if (self.more) {
        CGRect moreRect = self.more.frame;
        moreRect.size.height = self.params.tabTopOffset + self.params.tabHeight + (self.params.tabIndicator ? self.params.tabIndicatorHeight : 0);
        moreRect.origin.x = viewWidth + self.params.tabLeftMargin;
        moreRect.origin.y = 0;
        self.more.frame = moreRect;
    }
    
    //button滚动容器
    self.scrollviewHeader.frame = CGRectMake(0, /*64*/0, viewWidth, self.params.tabTopOffset + self.params.tabHeight +  self.params.tabindicatorBackgroundOffset);
    self.scrollviewHeader.contentSize = CGSizeMake(totalWidth, 0);
    self.scrollHeaderContainer.frame = CGRectMake(self.params.tabLeftMargin, 0, viewWidth, self.scrollviewHeader.frame.size.height  + self.params.tabIndicatorBackgroundHeight);
    self.scrollHeaderBackContainer.frame = CGRectMake(0, 0, self.frame.size.width, self.scrollviewHeader.frame.size.height  + self.params.tabIndicatorBackgroundHeight);
    //内容容器
    CGFloat tableViewX = 0;
    CGFloat tableViewY = self.scrollviewHeader.frame.size.height  + self.params.tabIndicatorBackgroundHeight;
    CGFloat tableViewWidth = self.bounds.size.width;
    CGFloat tableViewHeight = self.bounds.size.height - tableViewY;
    
    
    
    if (self.defaultView && self.titles.count == 0) {
        self.defaultView.frame = CGRectMake(tableViewX, tableViewY, tableViewWidth, tableViewHeight);
    }
    
    if (self.titles == nil || self.titles.count == 0) {
        return;
    }
    
    self.scrollContentView.frame = CGRectMake(tableViewX, tableViewY, tableViewWidth, tableViewHeight);
    
    //选中状态View
    self.selectedView.frame = CGRectMake(self.currentIndex * perWidth + (self.currentIndex * splitWidth), 0, perWidth, self.params.tabTopOffset + self.params.tabHeight + self.params.tabIndicatorHeight);
    //下划线
    if (self.tabWidthType == STabTitleWidthFixed && ((STabViewFixedParams *)self.params).tabIndicatorWidth > 1) {
        self.imageViewLine.frame = CGRectMake(0, self.params.tabTopOffset + self.params.tabHeight, ((STabViewFixedParams *)self.params).tabIndicatorWidth, self.params.tabIndicatorHeight);
        CGPoint centerPt = CGPointMake(self.selectedView.center.x, self.imageViewLine.center.y);
        self.imageViewLine.center = centerPt;
    } else {
        self.imageViewLine.frame = CGRectMake(0, self.params.tabTopOffset + self.params.tabHeight, self.selectedView.frame.size.width, self.params.tabIndicatorHeight);
    }
    
    
    //下划线是否跟随字体一样宽度
    if (self.params.tabIndicatorEqualTitleWidth == YES) {
        float index = self.currentIndex;
        int currentIndex = (int)index;
        CGSize fontSize = [self.titles[currentIndex] sizeWithAttributes:@{NSFontAttributeName:self.params.tabTitleFont}];
        CGRect rectSelectedView = self.selectedView.frame;
        CGRect rectImageViewLine = self.imageViewLine.frame;
        self.selectedView.frame = CGRectMake(self.currentIndex * perWidth + (perWidth - fontSize.width) / 2.0 + (self.currentIndex * splitWidth), rectSelectedView.origin.y, fontSize.width, rectSelectedView.size.height);
        self.imageViewLine.frame = CGRectMake(0, rectImageViewLine.origin.y, self.selectedView.frame.size.width, rectImageViewLine.size.height);
    }
    
    CGFloat titleBtnOffsetX = 0.0f;
    for (int i = 0; i < self.titles.count; ++i) {
        UIButton *button = [self.scrollviewHeader viewWithTag:i + STABVIEW_BUTTON_TAG_BASE];
        if (button == nil) {
            break;
        }
        CGFloat tmpPerWidth = [self.titleWidths[i] floatValue];
        if (i == self.currentIndex) {
            button.selected = YES;
        }
        button.frame = CGRectMake(titleBtnOffsetX + (i * splitWidth), self.params.tabTopOffset, tmpPerWidth, self.params.tabHeight);
        titleBtnOffsetX += tmpPerWidth;
    }
    
    
    
    titleBtnOffsetX = 0.0f;
    for (int idx = 0; idx < self.splitsArray.count; ++idx) {
        UIView *tmpView = self.splitsArray[idx];
        
        
        CGFloat tmpPerWidth = [self.titleWidths[idx] floatValue];
        titleBtnOffsetX += tmpPerWidth;
        
        CGFloat splitHeight = (self.scrollviewHeader.frame.size.height - tmpView.frame.size.height) / 2.0;
        splitHeight = (splitHeight <= 0 || splitHeight > self.scrollviewHeader.frame.size.height) ? self.scrollviewHeader.frame.size.height : splitHeight;
        tmpView.frame = CGRectMake(titleBtnOffsetX + (idx * splitWidth), self.params.tabTopOffset + splitHeight, tmpView.frame.size.width, tmpView.frame.size.height);
    }
    
    if (self.protocol && [self.protocol respondsToSelector:@selector(tabViewRequestLayoutSubViews:)]) {
        [self.protocol tabViewRequestLayoutSubViews:self];
    }
    
    if (self.initIndex != -1) {
        self.currentIndex = self.initIndex;
        self.initIndex = -1;
        
        if (self.currentIndex == 0) {
            [self baseTabViewMoveMaskToIndex:0];
        }
    }
}


#pragma mark - 公共方法
- (void)baseTabViewSetupUI
{
    [self setupValue];
    
//    [self.scrollviewHeader.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i < self.titles.count; ++i) {
        UIButton *btn = [self.scrollviewHeader viewWithTag:i + STABVIEW_BUTTON_TAG_BASE];
        if (btn) {
            [btn removeFromSuperview];
        }
    }
    
    for (int i = 0; i < self.titles.count; ++i) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:[self.titles objectAtIndex:i] forState:UIControlStateNormal];
        
        button.tag = i + STABVIEW_BUTTON_TAG_BASE;
        [button addTarget:self action:@selector(_tabButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollviewHeader addSubview:button];
    }
    
    if (self.defaultView && self.titles.count > 0) {
        [self.defaultView removeFromSuperview];
    }
    
    if (self.protocol && [self.protocol respondsToSelector:@selector(tabViewRequestSetupUI:)]) {
        if(_scrollContentView == nil)
        {
            [self addSubview:self.scrollContentView];
        }
        
        [self.scrollContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        [self.protocol tabViewRequestSetupUI:self];
    }
}

- (void)baseTabViewReloadValue:(STabViewParams *)params
{
    [self handlePublicParams:params];
    if ([params isMemberOfClass:[STabViewAutoParams class]]) {
        self.tabWidthType = STabTitleWidthAuto;
        [self handleAutoParams:params];
    } else if ([params isMemberOfClass:[STabViewFixedParams class]]) {
        self.tabWidthType = STabTitleWidthFixed;
        [self handleEqualParams:params];
    } else if ([params isMemberOfClass:[STabViewEqualParams class]]) {
        self.tabWidthType = STabTitleWidthEqual;
        [self handleFixedParams:params];
    } else {
        NSAssert(1, @"参数错误");
    }
    
    
    [self layoutIfNeeded];
    [self setNeedsLayout];
    
}

- (void)baseTabViewSetupButton:(NSString *)title
{
    
    [self.titles addObject:title];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:self.params.tabTitleNormalColor forState:UIControlStateNormal];
    [button setTitleColor:self.params.tabTitleSelectColor forState:UIControlStateSelected];
    button.titleLabel.font = self.params.tabTitleFont;
    
    
    button.tag = self.titles.count - 1 + STABVIEW_BUTTON_TAG_BASE;
    [button addTarget:self action:@selector(_tabButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollviewHeader addSubview:button];
    
    if (self.params.tabSplit) {
        UIView *tmpView = [self duplicate:self.params.tabSplit];
        [self.splitsArray addObject:tmpView];
        [self.scrollviewHeader addSubview:tmpView];
    }
    
}

- (void)baseTabViewMoveMaskToIndex:(CGFloat)index
{
    if (self.titles.count == 0) {
        return;
    }
    
    
    int currentIndex = (int)index;
    int nextIndex = (currentIndex + 1 >= self.titles.count) ? ((int)self.titles.count - 1) : (currentIndex + 1);
    
    
    CGFloat viewWidth = self.frame.size.width;
    CGFloat splitWidth = 0.0;
    
    if (self.more) {
        viewWidth -= self.more.frame.size.width;
    }
    if(self.params.tabSplit) {
        splitWidth = self.params.tabSplit.frame.size.width;
    }
    
    viewWidth -= self.params.tabRightMargin;
    viewWidth -= self.params.tabLeftMargin;
    
    
    
    UIButton *btn = [self.scrollviewHeader viewWithTag:currentIndex + STABVIEW_BUTTON_TAG_BASE];
    UIButton *nextBtn = [self.scrollviewHeader viewWithTag:nextIndex + STABVIEW_BUTTON_TAG_BASE];
    CGFloat nextTitleWidth = 0.0f;
    CGFloat currentTitleWidth = 0.0f;
    
    
    if (self.params.tabIndicatorEqualTitleWidth) {
        nextTitleWidth = nextBtn.titleLabel.frame.size.width + 0;
        currentTitleWidth = btn.titleLabel.frame.size.width + 0;
    } else {
        nextTitleWidth = [self.titleWidths[nextIndex] floatValue];
        currentTitleWidth = [self.titleWidths[currentIndex] floatValue];
    }
    
    
    
    CGFloat maskWidth = currentTitleWidth - (currentTitleWidth - nextTitleWidth) * (index - currentIndex);
    
    CGRect rect = self.selectedView.frame;
    rect.size.width = maskWidth;
    
    CGFloat tagMargin = 0.0f;
    if (self.tabWidthType == STabTitleWidthAuto) {
        tagMargin = ((STabViewAutoParams *)self.params).tabMargin;
    }
    
    if (self.params.tabIndicatorEqualTitleWidth) {
        rect.origin.x = btn.frame.origin.x + tagMargin + ((nextBtn.frame.origin.x + tagMargin) - (btn.frame.origin.x + tagMargin)) * (index - currentIndex);
    } else {
        rect.origin.x = btn.frame.origin.x + ((nextBtn.frame.origin.x) - (btn.frame.origin.x )) * (index - currentIndex);
    }
    
    CGRect imageViewLineRect = self.imageViewLine.frame;
    
    
    self.selectedView.frame = rect;
    
    if (self.tabWidthType == STabTitleWidthFixed && ((STabViewFixedParams *)self.params).tabIndicatorWidth > 1) {
        imageViewLineRect.size.width = ((STabViewFixedParams *)self.params).tabIndicatorWidth;
        self.imageViewLine.frame = imageViewLineRect;
    } else {
        imageViewLineRect.size.width = maskWidth;
        self.imageViewLine.frame = imageViewLineRect;
    }
    
    
    if (index == (int)index) {
        btn.selected = YES;
        
        if (_preIndex != currentIndex) {
            UIButton *preBtn = [self.scrollviewHeader viewWithTag:_preIndex + STABVIEW_BUTTON_TAG_BASE];
            preBtn.selected = NO;
            
            _currentIndex = currentIndex;
            
            _isScrolling = NO;
            
            [self _callFun:currentIndex];
            _preIndex = currentIndex;
            
            [self scrollTitlesToIndex:currentIndex];
        }
        
        
    }
}

- (UIView*)duplicate:(UIView*)view
{
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:view];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}

#pragma mark - 私有方法
- (void)setupValue
{
    _initIndex = 0;
    _currentIndex = 0;
    _preIndex = _currentIndex;
    if (self.protocol && [self.protocol respondsToSelector:@selector(tabViewRequestSetupData:)]) {
        [self.protocol tabViewRequestSetupData:self];
    }
}

- (void)_setupUI
{
    [self setupValue];
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.scrollviewHeader.clipsToBounds = NO;
    self.clipsToBounds = YES;
    self.scrollHeaderContainer.clipsToBounds = YES;
    
    [self addSubview:self.scrollHeaderBackContainer];
    [self.scrollHeaderBackContainer addSubview:self.scrollHeaderContainer];
    [self.scrollHeaderContainer addSubview:self.scrollviewHeader];
    [self.scrollviewHeader addSubview:self.selectedView];
    [self.selectedView addSubview:self.imageViewLine];
//    [self addSubview:self.scrollContentView];
    if (self.defaultView) {
        [self addSubview:self.defaultView];
    }

}

- (void)scrollTitlesToIndex:(int)currentIndex
{
    //标题导航滚动操作
    UIButton *btn = [self.scrollviewHeader viewWithTag:currentIndex + STABVIEW_BUTTON_TAG_BASE];
    CGFloat splitWidth = 0.0f;
    NSInteger splitCount = self.titles.count - 1;
    if(self.params.tabSplit) {
        splitWidth = self.params.tabSplit.frame.size.width;
    }
    
    CGFloat viewWidth = self.bounds.size.width;
    if (self.more) {
        viewWidth -= self.more.frame.size.width;
    }
    viewWidth -= self.params.tabRightMargin;
    viewWidth -= self.params.tabLeftMargin;
    // 设置标题滚动区域的偏移量
    CGFloat offsetX = btn.center.x - viewWidth * 0.5 - splitWidth * splitCount;
    
    if (offsetX < 0) {
        offsetX = 0;
    }
    
    // 计算下最大的标题视图滚动区域
    CGFloat maxOffsetX = self.scrollviewHeader.contentSize.width - viewWidth;
    
    if (maxOffsetX < 0) {
        maxOffsetX = 0;
    }
    
    if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    
    // 滚动区域
    [self.scrollviewHeader setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

- (void)handlePublicParams:(STabViewParams *)params
{
    if (params.tabSplit != nil) {
        //从父窗口移除
        [self.splitsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        self.splitsArray = nil;
        
        if (params.tabSplit == nil) {
            return;
        }
        
        for (int i = 0; i < self.titles.count - 1; ++i) {
            UIView *tmpView = [self duplicate:params.tabSplit];
            [self.splitsArray addObject:tmpView];
            [self.scrollviewHeader addSubview:tmpView];
        }
    }
    
    self.selectedView.backgroundColor = params.tabMask ? params.tabMaskColor : [UIColor clearColor];
    
    self.imageViewLine.backgroundColor = params.tabIndicatorColor;
    self.scrollHeaderContainer.backgroundColor = params.tabIndicatorBackgroundColor;
    self.scrollviewHeader.backgroundColor = params.tabBackgroundColor;
    if (params.tabBackgroundImage) {
        self.scrollHeaderBackContainer.layer.contents = (id)[UIImage imageNamed:params.tabBackgroundImage].CGImage;
        self.scrollHeaderContainer.backgroundColor = [UIColor clearColor];
        self.scrollviewHeader.backgroundColor = [UIColor clearColor];
    }
    
    if (params.tabIndicatorImage != nil) {
        self.imageViewLine.image = [UIImage imageNamed:params.tabIndicatorImage];
        
        if ((self.tabWidthType == STabTitleWidthFixed && ((STabViewFixedParams*)params).tabIndicatorWidth < 1 ) || params.tabIndicatorImageMode != STabIndicatorImageModeNone) {
            self.imageViewLine.contentMode = (UIViewContentMode)params.tabIndicatorImageMode;
        }
        
    }
    
    for (int i = 0; i < self.titles.count; i++) {
        UIButton *btn = [self.scrollviewHeader viewWithTag:i + STABVIEW_BUTTON_TAG_BASE];
        [btn setTitleColor:params.tabTitleNormalColor forState:UIControlStateNormal];
        [btn setTitleColor:params.tabTitleSelectColor forState:UIControlStateSelected];
        btn.titleLabel.font = params.tabTitleFont;
    }
    
    
}

- (void)handleAutoParams:(STabViewParams *)params
{
    
}

- (void)handleEqualParams:(STabViewParams *)params
{
    
}

- (void)handleFixedParams:(STabViewParams *)params
{
    
}

- (void)calcTitleWidths
{
    //界面宽度
    CGFloat viewWidth = self.frame.size.width;
    if (viewWidth == 0 || self.titles.count == 0) {
        return;
    }
    
    //是否有额外的界面
    if (self.more) {
        viewWidth -= self.more.frame.size.width;
    }
    
    viewWidth -= self.params.tabRightMargin;
    viewWidth -= self.params.tabLeftMargin;
    //分割线
    CGFloat splitWidth = 0.0;
    if(self.params.tabSplit) {
        splitWidth = self.params.tabSplit.frame.size.width;
    }
    
    //分割线数量
    NSInteger splitCount = self.titles.count - 1;
    switch (self.tabWidthType) {
        case STabTitleWidthFixed:
        {
            CGFloat tmpWidth = ((STabViewFixedParams *)self.params).tabWidth - (splitWidth * splitCount) / self.titles.count;
            for (int i = 0; i < self.titles.count; ++i) {
                self.titleWidths[i] = [NSNumber numberWithFloat:tmpWidth];
            }
        }
            break;
        case STabTitleWidthAuto:
        {
            CGFloat totalWidth = 0.0f;
            for (int i = 0; i < self.titles.count; ++i) {
                CGSize fontSize = [self.titles[i] sizeWithAttributes:@{NSFontAttributeName:self.params.tabTitleFont}];
                CGFloat tmpWidth = (fontSize.width + ((STabViewAutoParams *)self.params).tabMargin * 2);
                totalWidth += tmpWidth;
                self.titleWidths[i] = [NSNumber numberWithFloat:tmpWidth];
            }
            
            if (((STabViewAutoParams *)self.params).titleAutoFill) {
                if (totalWidth < viewWidth) {
                    CGFloat perMarginWidth = (viewWidth - totalWidth) / self.titleWidths.count;
                    for (int i = 0; i < self.titleWidths.count; ++i) {
                        CGFloat tmp = [self.titleWidths[i] floatValue];
                        self.titleWidths[i] = [NSNumber numberWithFloat:(tmp + perMarginWidth)];
                    }
                    perMarginWidth = (perMarginWidth / 2.0);
                    ((STabViewAutoParams *)self.params).tabMargin += perMarginWidth;
                }
            }
            
        }
            break;
        case STabTitleWidthEqual:
        {
            CGFloat tmpWidth = (viewWidth - splitWidth * splitCount) / self.titles.count;
            for (int i = 0; i < self.titles.count; ++i) {
                self.titleWidths[i] = [NSNumber numberWithFloat:tmpWidth];;
            }
        }
            break;
        default:
            NSAssert(1 ,@"请设置Type");
            break;
    }
}

- (void)_callFun:(NSInteger)index
{
    if (self.protocol && [self.protocol respondsToSelector:@selector(tabViewRequestCallFun:withIndex:)]) {
        [self.protocol tabViewRequestCallFun:self withIndex:index];
    }
}


#pragma mark - getter
- (NSMutableArray *)titles
{
    if (_titles == nil) {
        _titles = [NSMutableArray array];
    }
    
    return _titles;
}

- (NSMutableArray *)titleWidths
{
    if (_titleWidths == nil) {
        _titleWidths = [NSMutableArray array];
    }
    
    return _titleWidths;
}

- (NSMutableArray *)splitsArray
{
    if (_splitsArray == nil) {
        _splitsArray = [NSMutableArray array];
    }
    
    return _splitsArray;
}

- (UIScrollView *)scrollviewHeader
{
    if (_scrollviewHeader == nil) {
        _scrollviewHeader = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0)];
        _scrollviewHeader.showsHorizontalScrollIndicator = NO;
        _scrollviewHeader.showsVerticalScrollIndicator = NO;
    }
    
    return _scrollviewHeader;
}

- (UIView *)selectedView
{
    if (_selectedView == nil) {
        _selectedView = [UIView new];
    }
    
    return _selectedView;
}

- (UIImageView *)imageViewLine
{
    if (_imageViewLine == nil) {
        _imageViewLine = [UIImageView new];
    }
    
    return _imageViewLine;
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
    
    CGPoint point = self.scrollContentView.contentOffset;
    point.x = currentIndex * self.scrollContentView.frame.size.width;
    [self.scrollContentView setContentOffset:point animated:YES];
}

- (UIScrollView *)scrollContentView
{
    if (_scrollContentView == nil) {
        if (self.protocol && [self.protocol respondsToSelector:@selector(tabViewRequestContentView)]) {
            _scrollContentView = [self.protocol tabViewRequestContentView];
        }
    }
    
    return _scrollContentView;
}

- (void)setParams:(STabViewParams *)params
{
    if (_params != params && params != nil) {
        _params = params;
        
        [self baseTabViewReloadValue:params];
    }
}

- (UIView *)scrollHeaderContainer
{
    if (_scrollHeaderContainer == nil) {
        _scrollHeaderContainer = [UIView new];
    }
    
    return _scrollHeaderContainer;
}

- (UIView *)scrollHeaderBackContainer
{
    if (_scrollHeaderBackContainer == nil) {
        _scrollHeaderBackContainer = [UIView new];
    }
    
    return _scrollHeaderBackContainer;
}

@end
