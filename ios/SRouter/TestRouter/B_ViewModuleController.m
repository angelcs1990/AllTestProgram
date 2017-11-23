//
//  B_ViewModuleController.m
//  TestRouter
//
//  Created by cs on 16/4/19.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "B_ViewModuleController.h"
#import "SRouterCmds.h"
#import "SRouter.h"

NSString *const keyModuleClassB = @"B_ViewModuleController";
NSString *const keyParamsClassB_Content = @"content";
_SRouterDeclared(keyParamsClassB_Title, @"title");

@interface B_ViewModuleController ()
@property (nonatomic, copy) NSString *paramsTitle;
@property (nonatomic, copy) NSString *paramsContent;
@property (nonatomic, copy) SRouterHandler blk;
@end

@implementation B_ViewModuleController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *labelTitle  = [UILabel new];
    labelTitle.frame = CGRectMake(50, 100, 200, 60);
    [labelTitle setTextColor:[UIColor blackColor]];
    [self.view addSubview:labelTitle];
    
    
    [labelTitle setText:self.paramsContent];
    self.title = self.paramsTitle;
    
    UIButton *button = [UIButton new];
    button.frame = CGRectMake(100, 200, 160, 50);
    [button setTitle:@"点我传参数" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    self.blk = SRouterQueryBlockDefault(); //SRTOUER_QUERY_BLOCK(_value);
}


- (void)buttonClicked:(id)sender
{
    
    if (self.blk) {
        self.blk(@{@"msg":@"我被传回去啦"});
    }
}
/**
 *  传递参数要实现ModuleProtocol协议
 */
- (id)command:(NSInteger)cmd andParams:(NSDictionary *)dictParam
{
    switch (cmd) {
        case RouterModuleParams:
            self.paramsTitle = dictParam[keyParamsClassB_Title];
            self.paramsContent = dictParam[keyParamsClassB_Content];
            break;
        case RouterModuleOtherCmd:
        {

            NSInteger cmd2 = SRouter_Unpack_Cmd(dictParam);
            switch (cmd2) {
                case RouterModuleOtherCmd + 1:
                {
                    NSDictionary *dict = SRouter_Unpack_Value(dictParam);
                    self.paramsTitle = dict[keyParamsClassB_Title];
                    self.paramsContent = dict[keyParamsClassB_Content];
                }
                    break;
                    
                default:
                    break;
            }
        }
        default:
            break;
    }
    return nil;
}

- (void)dealloc
{
    SRouterLog(@"B dealloc");
}

@end
