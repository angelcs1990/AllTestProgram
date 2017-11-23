//
//  D_ViewModuleController.m
//  TestRouter
//
//  Created by cs on 16/4/20.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "D_ViewModuleController.h"

#import "SRouter.h"

_SRouterDeclared(keyModuleClassD, @"D_ViewModuleController");
_SRouterDeclared(keyParamsClassD_Title, @"title");
_SRouterDeclared(keyParamsClassD_Content, @"content");

@interface D_ViewModuleController ()<SRouterModuleProtocol>
@property (nonatomic, copy) NSString *paramsTitle;
@property (nonatomic, copy) NSString *paramsContent;
@end

@implementation D_ViewModuleController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = keyModuleClassD;
    
    UILabel *labelTitle  = [UILabel new];
    labelTitle.frame = CGRectMake(50, 100, 250, 60);
    [labelTitle setTextColor:[UIColor blackColor]];
    [self.view addSubview:labelTitle];
    
    
    [labelTitle setText:self.paramsContent];
    self.title = self.paramsTitle;
    
    
    UIButton *buttonDidToA = [UIButton new];
    buttonDidToA.frame = CGRectMake(100, 200, 200, 60);
    [buttonDidToA setTitle:@"点我关闭" forState:UIControlStateNormal];
    [buttonDidToA setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [buttonDidToA addTarget:self action:@selector(buttonDidToAClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:buttonDidToA];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonDidToAClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  传递参数要实现ModuleProtocol协议
 */
- (id)command:(NSInteger)cmd andParams:(NSDictionary *)dictParam
{
    switch (cmd) {
        case RouterModuleParams:
            self.paramsTitle = dictParam[keyParamsClassD_Title];
            self.paramsContent = dictParam[keyParamsClassD_Content];
            break;
            
        default:
            break;
    }
    return nil;
}

@end
