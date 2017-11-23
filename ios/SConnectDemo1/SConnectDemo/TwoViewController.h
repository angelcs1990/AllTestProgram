//
//  TwoViewController.h
//  SConnectDemo
//
//  Created by cs on 16/11/18.
//  Copyright © 2016年 cs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SConnect.h"
@interface TwoViewController : UIViewController

S_SIGNALS(sigButtonDidClicked:(id)sender withParas:(NSString *)eee);
S_SIGNALS(sigPassValue);

- (void)showMeTest;
- (void)showCsTest;
@end
