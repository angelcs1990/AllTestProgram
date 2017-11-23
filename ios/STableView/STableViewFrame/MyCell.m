//
//  MyCell.m
//  STableViewFrame
//
//  Created by cs on 16/10/12.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "MyCell.h"
#import "MyModel.h"

@implementation MyCell

//- (void)requestInitView:(GGCSBaseCell *)tableCell
//{}

- (void)requestConfigurationItem:(STableViewCell *)tableCell model:(STableViewCellModel *)model
{
    self.textLabel.text = ((MyModel *)model).text;
}

@end
