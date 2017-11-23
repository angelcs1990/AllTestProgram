//
//  ComplexCell.m
//  DrawSelfTest
//
//  Created by cs on 17/9/13.
//  Copyright © 2017年 cs. All rights reserved.
//

#import "ComplexCell2.h"

#import "S2Label.h"
#import "S2Panel+Geometry.h"
#import "S2Panel.h"
#import "S2ImageView.h"

#define PlayerViewBaseTag 100

@interface _GGFunGuessPoolItem2 : UIView

@property (nonatomic, strong) UILabel *buttonCorpName;

@property (nonatomic, strong) UILabel *labelCoin;

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation _GGFunGuessPoolItem2

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupView];

    }
    
    return self;
}

- (void)addTarget:(id)obj action:(SEL)action
{

}

- (void)configureItem
{
    self.buttonCorpName.text = @"title";
    
    self.labelCoin.text = @"仅仅测试";
    self.imageView.image = [UIImage imageNamed:@"photo"];
}

#pragma mark -
- (void)setupView
{
    [self addSubview:self.buttonCorpName];
    [self addSubview:self.labelCoin];
    [self addSubview:self.imageView];
    
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.buttonCorpName.frame = CGRectMake(0, 0, self.frame.size.width, 20);
    self.labelCoin.frame = CGRectMake(42, 22, self.frame.size.width - 42, 20);
    self.imageView.frame = CGRectMake(0, 22, 40, 40);
}
#pragma mark - lazy load
- (UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [UIImageView new];
    }
    
    return _imageView;
}

- (UILabel *)buttonCorpName
{
    if (_buttonCorpName == nil) {
        _buttonCorpName = [UILabel new];
        
        _buttonCorpName.textColor = [UIColor blueColor];
        _buttonCorpName.font = [UIFont systemFontOfSize:10];
        _buttonCorpName.layer.borderColor = [UIColor redColor].CGColor;
        _buttonCorpName.layer.borderWidth = (1 / [UIScreen mainScreen].scale);
        _buttonCorpName.layer.cornerRadius = 2.0f;
        _buttonCorpName.layer.masksToBounds = YES;
        
    }
    
    return _buttonCorpName;
}

- (UILabel *)labelCoin
{
    if (_labelCoin == nil) {
        _labelCoin = [UILabel new];

        
        _labelCoin.textColor = [UIColor redColor];
        _labelCoin.font = [UIFont systemFontOfSize:9];
        _labelCoin.backgroundColor = [UIColor yellowColor];
        
        _labelCoin.layer.borderColor = [UIColor redColor].CGColor;
        _labelCoin.layer.borderWidth = (1 / [UIScreen mainScreen].scale);
        _labelCoin.layer.cornerRadius = 2.0f;
        _labelCoin.layer.masksToBounds = YES;
    }
    
    return _labelCoin;
}
@end





@interface ComplexCell2 ()

@property (nonatomic, strong) NSMutableArray *arrVisibleItems;

@property (nonatomic, strong) NSMutableSet *reusableItems;

@property (nonatomic, strong) NSArray *dataSourceArray;

@end


@implementation ComplexCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString *identifier = NSStringFromClass([self class]);
    ComplexCell2 *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[self class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
        
        
        
    }
    
    return self;
}

//强弱引用
#ifndef GGWeakify
#define GGWeakify(object) __weak __typeof__(object) weak##_##object = object
#endif

#ifndef GGStrongify
#define GGStrongify(object) __typeof__(object) object = weak##_##object
#endif
- (void)configureDatas:(NSArray *)datas withWidth:(CGFloat)width
{

    int count = 1 + arc4random() % datas.count;
    
    GGWeakify(self);
    if (datas.count > self.arrVisibleItems.count) {
        [datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GGStrongify(self);
            
            if (idx < count) {
                if (self.arrVisibleItems.count <= idx) {
                    _GGFunGuessPoolItem2 *viewItem = [self dequeueReusable];
                    [self addSubview:viewItem];
                    [self.arrVisibleItems addObject:viewItem];
                }
            }
            
            
        }];
    }
    
    
    self.dataSourceArray = [datas subarrayWithRange:NSMakeRange(0, count)];
    
    //多余的回收
    if (self.arrVisibleItems.count > count) {
        NSInteger num = self.arrVisibleItems.count -count;
        for (int i = 0; i < num; ++i) {
            _GGFunGuessPoolItem2 *tmp = [self.arrVisibleItems lastObject];
            [self.arrVisibleItems removeLastObject];
            [tmp removeFromSuperview];
            [self.reusableItems addObject:tmp];
        }
    }
    
    if (count != self.arrVisibleItems.count) {
        NSLog(@"error in GGFunGuessHGCell configureDatas");
        return;
    }
    
    [self autoLayoutGuessView];

}

- (void)itemAction:(_GGFunGuessPoolItem2 *)sender
{

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
    
    
    [[[UIAlertView alloc] initWithTitle:@"haha"
                                message:nil
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];

}
- (_GGFunGuessPoolItem2 *)dequeueReusable
{
    _GGFunGuessPoolItem2 *item = [self.reusableItems anyObject];
    if (item) {
        [self.reusableItems removeObject:item];
    } else {
        item = [_GGFunGuessPoolItem2 new];
        [item addTarget:self action:@selector(itemAction:)];
    }
    
    return item;
}

- (void)autoLayoutGuessView
{
    NSInteger count = self.arrVisibleItems.count;
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - (16 + 16 + 16 + 16))/3;
    
#define T_HEIGHT 60
    [self.dataSourceArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * _Nonnull stop) {
        int row = (int)idx / 3;
        int col = (int)idx % 3;
        
        

        _GGFunGuessPoolItem2 *playerView =  self.arrVisibleItems[idx];
        [playerView configureItem];
        
        if (idx >= count) {
            *stop = YES;
        } else {
            if (row == 0 && col == 0) {
                playerView.frame = CGRectMake(16, 0, width, T_HEIGHT);
            }else if (row == 0 && col == 1) {
                playerView.frame = CGRectMake((self.frame.size.width - playerView.frame.size.width) / 2.0f, 0, width, T_HEIGHT);
            }else if (row == 0 && col == 2) {
                playerView.frame = CGRectMake(playerView.superview.frame.size.width - (width + 16), 0, width, T_HEIGHT);

            }else {
                playerView.frame = CGRectMake(((UIView *)self.arrVisibleItems[idx - 3]).frame.origin.x, ((UIView *)self.arrVisibleItems[idx - 3]).frame.origin.y + ((UIView *)self.arrVisibleItems[idx - 3]).frame.size.height + 16, width, T_HEIGHT);
            }
        }
    }];
    
}

- (void)setupModel
{
}

- (void)setupView
{

}

#pragma mark - lazy load


- (NSMutableSet *)reusableItems
{
    if (_reusableItems == nil) {
        _reusableItems = [NSMutableSet set];
    }
    
    return _reusableItems;
}

- (NSMutableArray *)arrVisibleItems
{
    if (_arrVisibleItems == nil) {
        _arrVisibleItems = [NSMutableArray array];
    }
    
    return _arrVisibleItems;
}

@end
