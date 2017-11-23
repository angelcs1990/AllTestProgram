//
//  WebViewController.m
//  GGDemo
//
//  Created by cs on 16/6/20.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "SWebViewController.h"
#import <WebKit/WebKit.h>

@interface SWebViewController ()<WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) UIBarButtonItem *closeButtonItem;
@property (nonatomic, strong) UIBarButtonItem *webBackItem;

@property (nonatomic) BOOL hideProgress;

@end

@implementation SWebViewController


#pragma mark - lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

   
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    
    


    self.webView.allowsBackForwardNavigationGestures = self.allowsBackForwardNavigationGestures;

    self.progressView.progressTintColor = self.progressColor;
    self.progressView.trackTintColor = self.progressBackgroundColor;
    self.progressView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.progressHeight);
    

    [self hideProgressBar:!self.allowProgress];

    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"canGoForward" options:NSKeyValueObservingOptionNew context:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.webView loadRequest:request];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"canGoBack"];
    [self.webView removeObserver:self forKeyPath:@"canGoForward"];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
}

#pragma mark - 私有方法
- (void)hideProgressBar:(BOOL)bHide
{
    self.progressView.hidden = bHide;
}

-(void)updateNavigationItems{
    if (self.allowPageBack && self.webView.canGoBack) {
        if (self.buttonWebBack != nil) {
            [self.navigationItem setLeftBarButtonItem:self.webBackItem animated:NO];
        } else {
            [self.navigationItem setLeftBarButtonItems:@[self.closeButtonItem] animated:NO];
        }
        
    }else{
        [self.navigationItem setLeftBarButtonItems:nil];
    }
}
#pragma mark - 事件方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (self.allowProgress == NO) {
        return;
    }
    if (object == self.webView) {
        if ([keyPath isEqualToString:@"estimatedProgress"]) {
            CGFloat progressValue = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
            if (progressValue == 1) {
                [self hideProgressBar:YES];
            }
            [self.progressView setProgress:progressValue animated:YES];
        } else if ([keyPath isEqualToString:@"canGoBack"]){
            [self updateNavigationItems];
        } else if ([keyPath isEqualToString:@"canGoForward"]){
            [self updateNavigationItems];
        }

    }
}
- (void)webButtonBack
{
    if (self.allowPageBack) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)closeItemClicked
{
    if (self.allowPageBack) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - 公共方法
- (instancetype)initWithUrl:(NSString *)url withTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        self.url = url;
        self.navTitle = title;
        
//        self.allowProgress = NO;
//        self.allowPageBack = NO;
//        self.allowsBackForwardNavigationGestures = NO;
    }
    
    return self;
}




+ (instancetype)initWithUrl:(NSString *)url withTitle:(NSString *)title
{
    return [[self alloc] initWithUrl:url withTitle:title];
}



#pragma mark - UIWebViewDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    switch (navigationAction.navigationType) {
        case WKNavigationTypeLinkActivated:
        case WKNavigationTypeFormSubmitted:
        {
            self.hideProgress = NO;
            
        }
            break;
        case WKNavigationTypeOther:
        {
            self.hideProgress = NO;
        }
            break;
        case WKNavigationTypeBackForward:
        {

            self.hideProgress = YES;
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
        case WKNavigationTypeReload:
        case WKNavigationTypeFormResubmitted:
        default:
            break;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation
{
    
    //如果是点击等操作导致的新页面加载，显示进度条
    if (self.hideProgress == NO) {
        [self hideProgressBar:NO];
    } else {
        [self hideProgressBar:YES];
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    //不论是什么操作导致的都隐藏
    [self hideProgressBar:YES];
    [self.progressView setProgress:0];
    
    if (self.navTitle != nil && [self.navTitle length] > 0) {
        self.title = self.navTitle;
    } else {
        __weak typeof (self)  weakSelf = self;
        [webView evaluateJavaScript:@"document.title" completionHandler:^(NSString * _Nullable theTitle, NSError * _Nullable error) {
            if (theTitle.length > 10) {
                theTitle = [[theTitle substringToIndex:9] stringByAppendingString:@"…"];
            }
            weakSelf.title = theTitle;
        }];
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self updateNavigationItems];
    

    
}


- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    //如果失败了，都隐藏
    [self hideProgressBar:YES];
    [self.progressView setProgress:0];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


#pragma mark - setter and getter
- (void)setButtonWebBack:(UIButton *)buttonWebBack
{
    if (buttonWebBack) {
        [buttonWebBack addTarget:self action:@selector(webButtonBack) forControlEvents:UIControlEventTouchUpInside];
        self.webBackItem = [[UIBarButtonItem alloc] initWithCustomView:buttonWebBack];
    }
    _buttonWebBack = buttonWebBack;
}
- (void)setHideProgress:(BOOL)hideProgress
{
    if (self.allowProgress) {
        _hideProgress = hideProgress;
    } else {
        _hideProgress = YES;
    }
}
- (void)setAllowPageBack:(BOOL)allowPageBack
{
    _allowPageBack = allowPageBack;
    if (allowPageBack == NO) {
        self.allowsBackForwardNavigationGestures = NO;
    }
}


- (void)setProgressHeight:(CGFloat)progressHeight
{
    if (progressHeight > 5.0) {
        NSLog(@"数值太大了");
        return;
    }
    _progressHeight = progressHeight;
}
#define PV_TRACKTINTCOLOR [UIColor yellowColor]
#define PV_PROGRESSTINTCOLOR [UIColor blueColor]
- (UIProgressView *)progressView
{
    if (_progressView == nil) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 2)];
        _progressView.trackTintColor = PV_TRACKTINTCOLOR;
        _progressView.progressTintColor = PV_PROGRESSTINTCOLOR;
    }
    
    return _progressView;
}
- (WKWebView *)webView
{
    if (_webView == nil) {
        WKWebViewConfiguration*config = [[WKWebViewConfiguration alloc]init];
        
        config.selectionGranularity = WKSelectionGranularityCharacter;
        
        _webView = [[WKWebView alloc]initWithFrame:CGRectOffset(self.view.bounds, 0, 0) configuration:config];
        _webView.navigationDelegate = self;
//        _webView.allowsBackForwardNavigationGestures = YES;
    }
    
    return _webView;
}
-(UIBarButtonItem*)closeButtonItem{
    if (!_closeButtonItem) {
        _closeButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(closeItemClicked)];
    }
    return _closeButtonItem;
}

@end
