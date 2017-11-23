//
//  CellTest.h
//  SQuickUI
//
//  Created by cs on 17/9/20.
//  Copyright © 2017年 cs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellTest : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;


- (void)configureDatas:(NSArray *)datas withWidth:(CGFloat)width;

@end
