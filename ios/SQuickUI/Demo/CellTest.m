//
//  CellTest.m
//  SQuickUI
//
//  Created by cs on 17/9/20.
//  Copyright © 2017年 cs. All rights reserved.
//

#import "CellTest.h"

#import "S2Label.h"
#import "S2Panel.h"
#import "S2Panel+Geometry.h"

@implementation CellTest

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString *identifier = NSStringFromClass([self class]);
    CellTest *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[self class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        S2Panel *panel = [[S2Panel alloc] initWithFrame:self.bounds];
        panel.backgroundColor = [UIColor yellowColor];
        
        S2Label *label = [S2Label new];
        label.frame = CGRectMake(0, 0, self.frame.size.width, 50);
        label.text = @"你好,我是测试cell";
        label.backgroundColor = [UIColor greenColor];
        label.textColor = [UIColor yellowColor];
        label.textAlignment = NSTextAlignmentCenter;
        
        [panel addSubview:label];
        
        [self addSubview:panel];
       
    }
    return self;
}
- (void)configureDatas:(NSArray *)datas withWidth:(CGFloat)width
{}


@end
