//
//  CellView.m
//  STabViewDemo
//
//  Created by cs on 16/10/25.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "CellView.h"


@interface CellView ()

@property (nonatomic, strong) UILabel *labelTitle;

@end
@implementation CellView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupInit];
    }
    
    return self;
}


- (void)dealloc
{
    NSLog(@"%p", self);
}

- (void)setupInit
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 50)];
    self.labelTitle.text = @"水水水水水水水水";
    self.labelTitle.backgroundColor = [UIColor greenColor];
    
    [self addSubview:self.labelTitle];
}

- (id)configurationItem:(id)data
{
    self.labelTitle.text = data;
    
    return nil;
}
@end
