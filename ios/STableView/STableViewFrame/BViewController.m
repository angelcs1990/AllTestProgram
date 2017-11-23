//
//  BViewController.m
//  STableViewFrame
//
//  Created by cs on 16/10/13.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "BViewController.h"
#import "STableViewHeader.h"
#import "MyCell.h"
#import "DelegateImp.h"
#import "MyDataSource.h"
#import "MyCell2.h"
#import "GGSTableView.h"
@interface BViewController ()<UITableViewDelegate>
@property (nonatomic, strong) GGGroupTableView *tableView;

@end

@implementation BViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor yellowColor];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn2.frame = CGRectMake(30, 20, 100, 30);
    [btn2 setTitle:@"B" forState:UIControlStateNormal];
    btn2.layer.borderColor = [UIColor blackColor].CGColor;
    btn2.layer.borderWidth = 0.5f;
    [btn2 setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    btn2.tag = 2;
    
    self.tableView.frame = CGRectMake(0, 110, self.view.bounds.size.width, self.view.bounds.size.height - 110);
    [self.view addSubview:self.tableView];
    [self start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)btnDidClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)start
{
    [self.tableView csConfigurationData:NSStringFromClass([self class]) type:STableDataConfigDown];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate

#pragma mark - setter and getter
- (GGGroupTableView *)tableView
{
    if (_tableView == nil) {
        
        _tableView = [[GGGroupTableView alloc] init];
        _tableView.cs_CellClasses = @[[MyCell class], [MyCell2 class]];
        _tableView.cs_DataSource = [DataSource csDataSource];
        _tableView.cs_DelegatesProxy = [DelegateImp csDelegatesProxy];
        

    }
    return _tableView;
}


@end
