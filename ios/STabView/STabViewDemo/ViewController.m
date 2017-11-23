//
//  ViewController.m
//  STabViewDemo
//
//  Created by cs on 16/7/13.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "ViewController.h"

#import "STabView.h"
#import "ThreeViewController.h"
#import "SReuseTabView.h"
#import "CellView.h"

#import "SDebugTools.h"
//#import "GGAlertView.h"
#import "SPopView.h"
#import "SPopViewDemo.h"

#import "TwoViewController.h"
#import "ThreeViewController.h"
#import "OneViewController.h"


@interface ViewController ()<SReuseTabViewDelegate, STabViewDelegate>
@property (nonatomic, strong) ThreeViewController *vc3;
@property (nonatomic, strong) NSArray *arrayDataSource;

@property (nonatomic, strong) SReuseTabView *tabView;

@property (nonatomic, strong) UIWindow *window;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    
    NSArray *arrayData = @[@"跳转普通选项卡", @"跳转复用选项卡", @"跳转有缺省界面", @"popView"];
    for (int i = 0; i < arrayData.count; ++i) {
        [self createButtonWithTitle:arrayData[i] andFrame:CGRectMake(30, 70 + (i * 45), 140, 45)];
    }
    
//    UIView *viewTest = [[UIView alloc] initWithFrame:CGRectMake(200, 100, 20, 30)];
//    viewTest.backgroundColor = [UIColor purpleColor];
//    [self.view addSubview:viewTest];
//    [UIView animateWithDuration:5 animations:^{
//        viewTest.frame = CGRectMake(0, 100, 220, 30);
//    }];
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
    NSInteger idx = ((UIButton *)sender).tag;
    if (idx == 0) {
        [self presentViewController:[TwoViewController new] animated:YES completion:nil];
    } else if (idx == 1) {
        [self presentViewController:[ThreeViewController new] animated:YES completion:nil];
    } else if (idx == 2) {
        [self presentViewController:[OneViewController new] animated:YES completion:nil];
    } else {
        [[SPopViewDemo popViewWithTitle:@"Test" buttonTitles:@[@"Cancel", @"Ok"] clickBlock:^(NSInteger buttonIndex) {
            
        }] show];
    }
}











- (void)btnClicked:(id)sender
{
    NSLog(@"clicked");
    [[SPopViewDemo popViewWithTitle:@"Test" buttonTitles:@[@"Cancel", @"Ok"] clickBlock:^(NSInteger buttonIndex) {
        
    }] show];
}
- (void)didChanged
{
    [[SPopViewDemo popViewWithTitle:@"Test" buttonTitles:@[@"Cancel", @"Ok"] clickBlock:^(NSInteger buttonIndex) {
        
    }] show];
    self.tabView.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    
}
#pragma mark - STabViewDelegate
- (void)tabView:(STabView *)tabView didTabIndex:(NSInteger)tabIndex
{
   
    NSLog(@"第%ld页点击", tabIndex);
    
}

- (void)tabView:(SReuseTabView *)tabView didTabView:(SReuseTabViewCell *)didView atIndex:(NSInteger)tabIndex
{
    [didView configurationItem:self.arrayDataSource[tabIndex]];
    static BOOL bFirst = NO;
    if (bFirst) {

        [[SPopViewDemo popViewWithTitle:@"Test" buttonTitles:@[@"Cancel", @"Ok"] clickBlock:^(NSInteger buttonIndex) {

        }] show];
    }
    bFirst = YES;
    
}
@end
