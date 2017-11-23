//
//  ViewController.m
//  STableViewFrame
//
//  Created by 陈思 on 16/10/12.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "ViewController.h"
#import "AViewController.h"
#import "BViewController.h"
#import "CViewController.h"
#import "DViewController.h"
#import "EViewController.h"

@interface ViewController ()
@property (nonatomic, strong) NSArray *arrayDataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    for (int i = 0; i < self.arrayDataSource.count; ++i) {
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
        btn2.frame = CGRectMake(30, 80 + i * 30 + 2, 200, 30);
        [btn2 setTitle:NSStringFromClass(self.arrayDataSource[i]) forState:UIControlStateNormal];
        btn2.layer.borderColor = [UIColor blackColor].CGColor;
        btn2.layer.borderWidth = 0.5f;
        [btn2 setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(btnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn2];
        btn2.tag = i;
    }
}

- (NSArray *)arrayDataSource
{
    return @[[AViewController class], [BViewController class], [CViewController class], [DViewController class], [EViewController class]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnDidClicked:(id)sender
{
    NSInteger tag = ((UIButton *)sender).tag;
    [self presentViewController:[self.arrayDataSource[tag] new] animated:YES completion:nil];
}

#pragma mark - getter and setter

@end
