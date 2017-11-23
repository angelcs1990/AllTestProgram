//
//  ComplexCell.m
//  DrawSelfTest
//
//  Created by cs on 17/9/13.
//  Copyright © 2017年 cs. All rights reserved.
//

#import "ComplexCell.h"

#import "S2Label.h"
#import "S2Panel+Geometry.h"
#import "S2Panel.h"
#import "S2ImageView.h"

#define PlayerViewBaseTag 100

@interface _GGFunGuessPoolItem : S2Panel

@property (nonatomic, strong) S2Label *buttonCorpName;

@property (nonatomic, strong) S2Label *labelCoin;

@property (nonatomic, strong) S2ImageView *imageView;

@end

@implementation _GGFunGuessPoolItem

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
- (S2ImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [S2ImageView new];
    }
    
    return _imageView;
}

- (S2Label *)buttonCorpName
{
    if (_buttonCorpName == nil) {
        _buttonCorpName = [S2Label new];
        
        _buttonCorpName.textColor = [UIColor blueColor];
        _buttonCorpName.font = [UIFont systemFontOfSize:10];
        _buttonCorpName.layer.borderColor = [UIColor redColor].CGColor;
        _buttonCorpName.layer.borderWidth = (1 / [UIScreen mainScreen].scale);
        _buttonCorpName.layer.cornerRadius = 2.0f;
        
    }
    
    return _buttonCorpName;
}

- (S2Label *)labelCoin
{
    if (_labelCoin == nil) {
        _labelCoin = [S2Label new];

        
        _labelCoin.textColor = [UIColor redColor];
        _labelCoin.font = [UIFont systemFontOfSize:9];
        _labelCoin.backgroundColor = [UIColor yellowColor];
        
        
    }
    
    return _labelCoin;
}
@end





@interface ComplexCell ()

@property (nonatomic, strong) NSMutableArray *arrVisibleItems;

@property (nonatomic, strong) NSMutableSet *reusableItems;

@property (nonatomic, strong) NSArray *dataSourceArray;

@end


@implementation ComplexCell

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
    ComplexCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
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

    GGWeakify(self);
    if (datas.count > self.arrVisibleItems.count) {
        [datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GGStrongify(self);
            
            if (self.arrVisibleItems.count <= idx) {
                _GGFunGuessPoolItem *viewItem = [self dequeueReusable];
                [self addSubview:viewItem];
                [self.arrVisibleItems addObject:viewItem];
            }
        }];
    }
    
    
    self.dataSourceArray = datas;
    
    //多余的回收
    if (self.arrVisibleItems.count > datas.count) {
        NSInteger num = self.arrVisibleItems.count - datas.count;
        for (int i = 0; i < num; ++i) {
            _GGFunGuessPoolItem *tmp = [self.arrVisibleItems lastObject];
            [self.arrVisibleItems removeLastObject];
            [tmp removeFromSuperview];
            [self.reusableItems addObject:tmp];
        }
    }
    
    if (datas.count != self.arrVisibleItems.count) {
        NSLog(@"error in GGFunGuessHGCell configureDatas");
        return;
    }
    
    [self autoLayoutGuessView];

}

- (void)itemAction:(_GGFunGuessPoolItem *)sender
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
- (_GGFunGuessPoolItem *)dequeueReusable
{
    _GGFunGuessPoolItem *item = [self.reusableItems anyObject];
    if (item) {
        [self.reusableItems removeObject:item];
    } else {
        item = [_GGFunGuessPoolItem new];
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
        

        _GGFunGuessPoolItem *playerView =  self.arrVisibleItems[idx];
        [playerView configureItem];
        
        if (idx >= count) {
            *stop = YES;
        } else {
            if (row == 0 && col == 0) {
                playerView.frame = CGRectMake(16, 0, width, T_HEIGHT);
            }else if (row == 0 && col == 1) {
                playerView.size = CGSizeMake(width, T_HEIGHT);
                playerView.origin = CGPointMake((self.frame.size.width - playerView.width) / 2.0f, 0);
                

            }else if (row == 0 && col == 2) {
                playerView.frame = CGRectMake(playerView.superview.frame.size.width - (width + 16), 0, width, T_HEIGHT);

            }else {
                playerView.size = CGSizeMake(width, T_HEIGHT);
                playerView.centerX = ((S2Panel *)self.arrVisibleItems[idx - 3]).centerX;
                playerView.y = ((S2Panel *)self.arrVisibleItems[idx - 3]).bottom + 16;
                
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
