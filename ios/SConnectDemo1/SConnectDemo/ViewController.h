//
//  ViewController.h
//  SConnectDemo
//
//  Created by cs on 16/11/18.
//  Copyright © 2016年 cs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SConnect.h"
@interface ViewController : UIViewController

S_SIGNALS(sigTest);
S_SIGNALS(sigClicked);
S_SIGNALS(sigButtonDidClicked:(id)sender withParas:(NSString *)eee);
S_SIGNALS(sigTestNum:(int)n);
S_SIGNALS(sigTest2:(NSString *)str1 withStr2:(NSString *)str2 withNum:(int)num);
@end

