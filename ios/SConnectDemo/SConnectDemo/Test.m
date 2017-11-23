//
//  Test.m
//  SConnectDemo
//
//  Created by cs on 16/11/21.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "Test.h"

@implementation Test

- (void)showMe
{
    [self performSelector:@selector(buttonClicked:withObj:) withObject:self withObject:@"Hell"];
    
    [self buttonClicked:self withObj:@"ss"];
}

- (void)buttonClicked:(id)sender withObj:(NSString *)send2
{
    int i = 0;
}


@end
