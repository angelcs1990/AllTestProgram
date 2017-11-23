//
//  TwoViewController.m
//  STabViewDemo
//
//  Created by cs on 16/11/3.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "TwoViewController.h"
#import "STabView.h"


@interface TwoViewController ()<STabViewDelegate>

@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *view1 = [UIView new];
    view1.backgroundColor = [UIColor greenColor];
    UIView *view2 = [UIView new];
    view2.backgroundColor = [UIColor yellowColor];
    UIView *view3 = [UIView new];
    UIView *view4 = [UIView new];
    view4.backgroundColor = [UIColor purpleColor];
    // Do any additional setup after loading the view.
//    STabView *tabView = [STabView tabViewWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
    STabView *tabView = [STabView tabView:@[@"热门", @"中国",  @"韩国"] withViews:@[view1, view2, view3] initIndex:0 withFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
    [self.view addSubview:tabView];
    
    STabViewAutoParams *params = [STabViewAutoParams tabViewParams];

    params.tabMask = YES;
    params.tabindicatorBackgroundOffset = 0.0;
    params.tabHeight = 33;
    //        params.titleAutoFill = NO;
    params.tabLeftMargin = 20;
    params.tabBackgroundImage = @"back";

    tabView.delegate = self;
    tabView.params = params;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [tabView setTabTitles:@[@"热门", @"中国",  @"韩国"] withViews:@[view1, view2, view3]];
        [tabView addTabTitle:@"more" withView:view4];
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


- (void)tabView:(STabView *)tabView didTabIndex:(NSInteger)tabIndex
{
    UIView *view = tabView.currentView;
    UIView *view2 = tabView.preView;
    NSLog(@"点击%ld", tabIndex);
}

@end
