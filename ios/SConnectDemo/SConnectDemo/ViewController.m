//
//  ViewController.m
//  SConnectDemo
//
//  Created by cs on 16/11/18.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "ViewController.h"
#import "TwoViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface ViewController ()

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"clicked" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(100, 100, 100, 45);
    button.layer.backgroundColor = [UIColor redColor].CGColor;

//    ((void (*)(id, SEL))(void *)objc_msgSend)(self, @selector(testCallBack));
//    ((void (*)(id, SEL))(void *)objc_msgSend)((id)self, sel_registerName("testCallBack"));
    [self.view addSubview:button];
//    STuplePack(@"helo", @"cs");
    
//    [self buttonClicked:self];
//    emit(sigTest);
    

    
//    SObjc_msgSend_Simple(self, @selector(testCallBack));
//      SObjc_msgSend(self, @selector(buttonClicked:withParas:), self, @"hello");

//    int a = sizeof(BOOL);
//    BOOL as = YES;
//    as = NO;
//    long t;
//    t = 1111111111;
//    *(char*)(&as) = t;


//#define TEST_B1 NSLog(@"1")
//#define TEST_B2 NSLog(@"2")
//#define TEST_A_(t, _num) t##_num
//#define TEST_A__B(t, _num) TEST_A_(t, _num)
//#define TEST_A(_num) TEST_A__B(TEST_B, _num)
//    for (int i = 1; i < 2; i++) {
//        TEST_A(1);
//    }

//    [[SConnect shareInstance] emit2:self signal:@"buttonClicked", self, ttt, nil];
    

//    int b = *(int *)(numt);
    connect(self, S_SIGNAL(sigButtonDidClicked:withParas:), self, S_SLOT(testCallBack:withParas:));
    
//    connect(self, S_SIGNAL(sigButtonDidClicked:withParas:), self, S_SLOT(showCsTest));
    connect(self, S_SIGNAL(sigTestNum:), self, S_SLOT(testNum:));
    connect(self, S_SIGNAL(sigTest2:withStr2:withNum:), self, S_SLOT(test2Test2:withStr2:withNum:));
    connect(self, S_SIGNAL(sigTest), self, S_SLOT(testSig));

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)testSig
{
    NSLog(@"sss");
}
- (void)testCallBack:(id)sender withParas:(NSString *)ok
{
    NSLog(@"%@", ok);
}
- (void)testCallBack2:(id)sender withParas:(NSString *)sss
{
    NSLog(@"%@----2", sss);
}
- (void)test2Test2:(NSString *)str1 withStr2:(NSString *)str2 withNum:(int)NumVersion
{
    NSLog(@"%@-%@-%d", str1, str2, NumVersion);
}
- (void)testNum:(int)num
{
    NSLog(@"%@", [NSString stringWithFormat:@"%d", num]);
}
- (void)buttonClicked
{
    TwoViewController *tvc = [TwoViewController new];

//    connect(tvc, S_SIGNAL(sigButtonDidClicked:withParas:), self, S_SLOT(testCallBack:withParas:));
//    connect(tvc, S_SIGNAL(sigButtonDidClicked:withParas:), self, S_SLOT(testCallBack2:withParas:));
    connect(tvc, S_SIGNAL(sigButtonDidClicked:withParas:), self, S_SIGNAL(sigButtonDidClicked:withParas:));
//#define Testss(...) @[__VA_ARGS__]
//    NSArray *t = Testss(tvc, @1, @2);
//    t = Testss();
//    s_emit(tvc, @"sigButtonDidClicked:withParas:");
    [self presentViewController:tvc animated:YES completion:nil];
    emit(sigButtonDidClicked:withParas:, SNil, @"hello cs");
    emit(sigTest);
    emit(sigTestNum:, @10);
//    s_disconnect(self, S_SIGNAL(sigTestNum:), nil, nil, SConnectionTypeSlot);
    emit(sigTestNum:, @20);
}


@end
