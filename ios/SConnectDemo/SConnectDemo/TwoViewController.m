//
//  TwoViewController.m
//  SConnectDemo
//
//  Created by cs on 16/11/18.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "TwoViewController.h"

@interface TwoViewController ()

@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    // Do any additional setup after loading the view.
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"clicked" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(100, 100, 100, 45);
    button.layer.backgroundColor = [UIColor redColor].CGColor;
    [self.view addSubview:button];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonClicked
{
    emit(sigButtonDidClicked:withParas:, self, @"pass TwoViewController");
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)showMeTest
{}
- (void)showCsTest
{}
- (void)dealloc
{
    NSLog(@"dealloc");
}

@end
