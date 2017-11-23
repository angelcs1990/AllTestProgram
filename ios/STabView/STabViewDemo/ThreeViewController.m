//
//  ThreeViewController.m
//  STabViewDemo
//
//  Created by cs on 16/7/13.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "ThreeViewController.h"
#import "SDebugTools.h"
#import "STabView.h"
#import "SReuseTabView.h"
#import "CellView.h"

@interface ThreeViewController ()<SReuseTabViewDelegate>

@property (nonatomic, strong) SReuseTabView *tabView;
@property (nonatomic, strong) NSArray *arrayDataSource;

@end

@implementation ThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.arrayDataSource = @[@"热门", @"中国",  @"韩国", @"北美", @"港澳台", @"欧洲"];
    
    self.tabView = [SReuseTabView tabViewWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
    STabViewFixedParams *params = [STabViewFixedParams tabViewParams];
    self.tabView.delegate = self;
    params.tabMask = YES;
    params.tabindicatorBackgroundOffset = 0.0;
    params.tabHeight = 33;
    params.tabWidth = 50;
    params.tabIndicatorWidth = 20;
    //        params.titleAutoFill = NO;
    self.tabView.params = params;
    [self.view addSubview:self.tabView];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tabView setTabTitles:@[@"热门", @"中国",  @"韩国", @"北美", @"港澳台", @"欧洲"] withClasses:@[[CellView class]]];
    });
    
    
    [self createButtonWithTitle:@"关闭" andFrame:CGRectMake(30, 10, 140, 45)];
    
}


- (UIButton *)createButtonWithTitle:(NSString *)title andFrame:(CGRect)rect
{
    static NSInteger idx = 0;
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    button1.layer.borderColor = [UIColor blackColor].CGColor;
    button1.layer.borderWidth = 1;
    [button1 setTitle:title forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    button1.tag = idx;
    //    button1.frame = CGRectMake(30, 70, 140, 45);
    button1.frame = rect;
    ++idx;
    return button1;
}

- (void)buttonDidClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"will");
}
- (void)tabView:(SReuseTabView *)tabView didTabView:(SReuseTabViewCell *)didView atIndex:(NSInteger)tabIndex
{
    NSLog(@"复用：%ld", tabIndex);
    [didView configurationItem:self.arrayDataSource[tabIndex]];
    
}

@end
