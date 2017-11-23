//
//  STabViewTableCell.m
//  STabViewDemo
//
//  Created by cs on 16/10/24.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "SReuseTabViewCell.h"


@interface SReuseTabViewCell()

//@property (nonatomic, weak) id<STabViewTableCellDelegate> child;

@end
@implementation SReuseTabViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    
    return self;
}

- (id)configurationItem:(id)data
{
    NSAssert(0, @"请实现configurationItem方法");
    return nil;
}

@end
