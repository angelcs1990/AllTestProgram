//
//  AViewController.m
//  STableViewFrame
//
//  Created by cs on 16/10/13.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "AViewController.h"
#import "STableViewHeader.h"
#import "MyCell.h"
#import "MyDataSource.h"
#import "DelegateImp.h"
#import "GGSTableView.h"
@interface AViewController ()<UITableViewDelegate>
@property (nonatomic, strong) GGNormalTableView *tableView;
@end

@implementation AViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greenColor];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn2.frame = CGRectMake(30, 20, 100, 30);
    [btn2 setTitle:@"B" forState:UIControlStateNormal];
    btn2.layer.borderColor = [UIColor blackColor].CGColor;
    btn2.layer.borderWidth = 0.5f;
    [btn2 setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    btn2.tag = 2;
    
    self.tableView.frame = CGRectMake(0, 110, self.view.bounds.size.width, self.view.bounds.size.height);
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
//    [GGCSTableFrameInterface tableFrameInterface];
    [self.tableView csConfigurationData:NSStringFromClass([self class]) type:STableDataConfigUp];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"willDisplayCell");
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    NSLog(@"heightForRowAtIndexPath");
//    
//    return 20;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MyCell *cell = (MyCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    if (cell.cs_model) {
        NSLog(@"不要点我");
        
    }
}
#pragma mark - setter and getter
- (GGNormalTableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[GGNormalTableView alloc] init];
        _tableView.csCellClass = [MyCell class];
//        _tableView.cs_DataSource = [CSTableViewDataSource csDataSource];
        _tableView.cs_DelegatesProxy = [DelegateImp csDelegatesProxy];
        
        _tableView.delegate = self;
        
    }
    return _tableView;
}

@end
