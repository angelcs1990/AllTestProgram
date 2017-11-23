//
//  ComplexCell.h
//  DrawSelfTest
//
//  Created by cs on 17/9/13.
//  Copyright © 2017年 cs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPanel.h"
@interface ComplexCell2 : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;


- (void)configureDatas:(NSArray *)datas withWidth:(CGFloat)width;

@end
