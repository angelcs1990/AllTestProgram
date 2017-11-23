//
//  GGCSTableBaseCell.m
//  GameGuess_CN
//
//  Created by cs on 16/7/15.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "STableViewHeader.h"

@interface STableViewCell()

@property (nonatomic, weak) id<STableViewCellDelegate> child;

@end

@implementation STableViewCell

+ (STableViewCell *)csCellWithTableView:(STableView *)tableView
{
    NSString *identifier = NSStringFromClass([self class]);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[self class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return (STableViewCell*)cell;
}

- (void)csConfigurationItem:(STableViewCellModel *)model
{
    _cs_model = model;
    
    if ([self.child respondsToSelector:@selector(requestConfigurationItem:model:)]) {
        [self.child requestConfigurationItem:self model:model];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if ([self conformsToProtocol:@protocol(STableViewCellDelegate)]) {
            _child = (id<STableViewCellDelegate>)self;
        } else {
            NSAssert(0, @"please completion GGCSTableBaseCellProtocol");
        }
        
        if ([self.child respondsToSelector:@selector(requestInitView:)]) {
            [self.child requestInitView:self];
        }

    }
    
    return self;
}

@end
