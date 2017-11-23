//
//  DViewController.m
//  STableViewFrame
//
//  Created by cs on 16/10/19.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "DViewController.h"
#import "CViewController.h"
#import "STableViewHeader.h"
#import "MyCell.h"
#import "DelegateImp.h"
#import "MyDataSource.h"
#import "MyCell2.h"
#import "GGSTableView.h"
@interface DViewController ()<UITableViewDelegate>

//我们的tableView
@property (nonatomic, strong) GGGroupTableView *tableView;

@end

@implementation DViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor yellowColor];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn2.frame = CGRectMake(30, 20, 100, 30);
    [btn2 setTitle:@"close" forState:UIControlStateNormal];
    btn2.layer.borderColor = [UIColor blackColor].CGColor;
    btn2.layer.borderWidth = 0.5f;
    [btn2 setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
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
    //数据源配置，如果不调用就没有数据
    [self.tableView csConfigurationData:NSStringFromClass([self class]) type:STableDataConfigDown];
    [self.tableView reloadData];

}

#pragma mark - UITableViewDelegate
//这是我们需要使用的原生函数
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"D tableView willDisplayCell");
}

#pragma mark - setter and getter
- (GGGroupTableView *)tableView
{
    if (_tableView == nil) {
        
        _tableView = [[GGGroupTableView alloc] init];
        
        //如果需要可以设置多个Cell，最少设置一个
        _tableView.cs_CellClasses = @[[MyCell class], [MyCell2 class]];

        //设置一个实现的代理，然后再DelegateImp中实现所需要的东西久ok了
        _tableView.cs_DelegatesProxy = [DelegateImp csDelegatesProxy];
        
        //如果还需要原生的代理，可以设置这个，在这个例子中我们需要原生的willDisplayCell函数
        _tableView.delegate = self;

    }
    return _tableView;
}

@end


