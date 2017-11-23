//
//  ViewController.m
//  SQuickUI
//
//  Created by cs on 17/9/13.
//  Copyright © 2017年 cs. All rights reserved.
//

#import "ViewController.h"
#import "SPanel.h"
#import "SLabel.h"
#import "S2Label.h"
#import "CellTest.h"
#import "ComplexCell.h"
#import "YYFPSLabel.h"
#import "ComplexCell2.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *arrDatas;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *zwBuf;

@property (nonatomic, strong) YYFPSLabel *fpsLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    UIView *view = [UIView new];
//    view.frame = CGRectMake(30, 100, 100, 100);
//    
//    SLabel *label = [SLabel new];
//    label.text = @"你好";
//    label.backgroundColor = [UIColor greenColor];
//    label.textColor = [UIColor yellowColor];
//    label.destView = view;
////    label.bounds = view.frame;
//    
//    [label setNeedUpdate];
//    
//    [self.view addSubview:view];
    
    _fpsLabel = [[YYFPSLabel alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
    
    
    
   
    
    self.zwBuf = @[@1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1,@1, @1, @1, @1, @1,@1, @1, @1, @1, @1];
    _arrDatas = [NSMutableArray array];
    [self.view addSubview:self.tableView];
    
    for (int i = 0; i < 10000; ++i) {
        [self.arrDatas addObject:@(i)];
    }
//    S2Label *label = [S2Label new];
//    label.frame = CGRectMake(30, 100, 100, 100);
//    label.text = @"你好";
//    label.backgroundColor = [UIColor greenColor];
//    label.textColor = [UIColor yellowColor];
//    
//    [self.view addSubview:label];
     [self.view addSubview:self.fpsLabel];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [ComplexCell2 cellWithTableView:tableView];
    [((ComplexCell2 *)cell) configureDatas:self.zwBuf withWidth:0];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 800;
}

#pragma mark - 
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [UITableView new];
    
        _tableView.frame = self.view.bounds;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}


@end
