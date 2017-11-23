//
//  ViewController.m
//  SNetworkDemo
//
//  Created by cs on 16/5/12.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "ViewController.h"

#import "SRouter.h"

#import "SSockCoreNetwork.h"


#define SENDCMD (RouterModuleOtherCmd + 1)

@interface ViewController ()

@property (nonatomic, strong) UIImageView *imageView;
//@property (nonatomic, strong) TestRequest *tq;
//@property (nonatomic, strong) TestRequest *ts;
@end

@implementation ViewController
- (void)dealloc
{
    SROUTER_UNREGISTER_INSTANCE(@"NetworkProxy");
    SROUTER_UNREGISTER_BLOCK(@"NetworkProxy");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _imageView = [UIImageView new];
    _imageView.frame = [self.view frame];
    [self.view addSubview:_imageView];
    


//    TestRequest *tq = [TestRequest new];
//    TestRequest *ts = [TestRequest new];
//    tq.sendData = @"first send tq";
//    tq.type = 1;
//    ts.sendData = @"second send ts";
//    ts.type = 2;
//    tq.responseDataBlock = ^(id data){
//        NSLog(@"tq-%@", data);
//    };
//    ts.responseDataBlock = ^(id data){
//        NSLog(@"ts-%@", data);
//    };
//    [tq start];
//    [ts start];
//    
////    [ts start];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [tq stop];
////        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////            [tq disconnect];
////        });
//    });
//    return;
    // Do any additional setup after loading the view, typically from a nib.
    __weak typeof (self) weakSelf = self;
    SROUTER_REGISTER_INSTANCE(@"NetworkProxy");
    SROUTER_REGISETER_BLOCK(@"NetworkProxy_my_define", ^(NSDictionary *dict){
        UIImage *image = (UIImage *)dict[@"obj"];
        weakSelf.imageView.image = image;
//        SROUTER_UNREGISTER_INSTANCE(@"NetworkProxy");
    });
    SROUTER_HANDLER_OTHERCMD_LOCAL(@"NetworkProxy", SROUTER_OTHERCMD_PACK_NOPARAM(SENDCMD));
    
}


#pragma mark -
- (id)reformerData
{
    //    NSString *reuslt = self.responseData.orignalData[@"result"];
    return @{@"result":@"ViewController look"};
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
