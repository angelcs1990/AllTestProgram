//
//  TestViewController.m
//  TestRouter
//
//  Created by cs on 16/4/20.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "TestViewController.h"
#import "A_ViewModuleController.h"
#import "SRouter.h"
#import "publicDefine.h"


#define CON_SIG

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SRouterConfig shareInstance].checkAll = YES;
    [SRouterConfig shareInstance].onlyCheckRegiste = NO;
    [SRouterConfig shareInstance].alwaysException = NO;
    [SRouterManager routerRegisteRules:@"modulelist"];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"TestViewController";
    
    
    UIButton *button = [UIButton new];
    button.frame = CGRectMake(100, 200, 160, 50);
    [button setTitle:@"测试" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button2 = [UIButton new];
    button2.frame = CGRectMake(100, 300, 160, 50);
    [button2 setTitle:@"错误模块" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(buttonClicked2:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    id obj = SRouterRegisterService(keyModuleErrModule);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonClicked2:(id)sender
{
    static BOOL change = YES;

    if (change) {


        ErrModuleTell(self.view, ErrModuleSystem, "Test cs");

        
    } else {


        ErrModuleTell(self.view, ErrModuleUser, "Test cs");

    }

    change = !change;
}

- (void)buttonClicked:(id)sender
{
    UIViewController *vc = [A_ViewModuleController new] ;
    [self.navigationController pushViewController:vc animated:YES];
    
    static BOOL bFirst = NO;
    if (bFirst) {
        SRouter_SubscribMessage(vc, 1);
    }
    bFirst = YES;
}


@end
