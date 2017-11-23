//
//  S2Panel.h
//  SQuickUI
//
//  Created by cs on 17/9/19.
//  Copyright © 2017年 cs. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface S2Panel : UIView

@property (nonatomic) BOOL fadeOnAsynchronouslyDisplay;

@property (nonatomic) BOOL clearContentsBeforeAsynchronouslyDisplay;

@property (nonatomic) BOOL displaysAsynchronously;

- (void)clearContents;

@end
