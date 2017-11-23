//
//  OneViewController.m
//  STabViewDemo
//
//  Created by cs on 16/11/8.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "OneViewController.h"
#import "STabView.h"

@interface OneViewController ()<STabViewDelegate>

@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *view1 = [UIView new];
    view1.backgroundColor = [UIColor greenColor];
    UIView *view2 = [UIView new];
    view2.backgroundColor = [UIColor purpleColor];
    UIView *view3 = [UIView new];
    view3.backgroundColor = [UIColor orangeColor];
    
    // Do any additional setup after loading the view.
    STabView *tabView = [STabView tabViewWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64) withDefaultView:view2];
    [self.view addSubview:tabView];
    
    STabViewAutoParams *params = [STabViewAutoParams tabViewParams];
    params.tabBackgroundColor = [UIColor grayColor];
//    params.tabMask = YES;
    params.tabindicatorBackgroundOffset = 0.0;
    params.tabIndicatorHeight = 7.0;
//    params.tabIndicatorBackgroundHeight = 7.0;
    params.tabIndicatorColor = [UIColor clearColor];
    params.tabMask = NO;
    params.tabTitleNormalColor = [UIColor redColor];
    params.tabIndicatorBackgroundColor = [UIColor grayColor];
    params.tabHeight = 20;
    params.tabIndicatorImage = @"buttonLine";
    params.tabTopOffset = 30;
    //        params.titleAutoFill = NO;
    tabView.delegate = self;
    tabView.params = params;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tabView setTabTitles:@[@"热门", @"中国"] withViews:@[view1, view3]];
    });
    
    UIView *viewSetting = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 36, 30)];
    viewSetting.backgroundColor = [UIColor greenColor];
    UIButton *buttonSetting = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonSetting setImage:[UIImage imageNamed:@"setting_nomal"] forState:UIControlStateNormal];
    [buttonSetting setImage:[UIImage imageNamed:@"setting_high"] forState:UIControlStateHighlighted];
    [buttonSetting addTarget:self action:@selector(settingBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    buttonSetting.frame = CGRectMake(0, 0, 30, 30);
    buttonSetting.backgroundColor = [UIColor greenColor];
    [viewSetting addSubview:buttonSetting];
    viewSetting.backgroundColor = [UIColor greenColor];
    [tabView addTabMoreView:viewSetting];
    [tabView addTabMoreView:viewSetting];
    
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
    NSLog(@"点击%ld", tabIndex);
}

@end
