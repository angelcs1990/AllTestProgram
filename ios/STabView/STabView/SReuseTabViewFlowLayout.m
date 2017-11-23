//
//  GGFightDataFlowLaout.m
//  GameGuess_CN
//
//  Created by GPsmile on 16/7/14.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "SReuseTabViewFlowLayout.h"

@implementation SReuseTabViewFlowLayout
- (void)prepareLayout
{
    [super prepareLayout];
    self.minimumInteritemSpacing = 0;
    self.minimumLineSpacing = 0;
    if (self.collectionView.bounds.size.height) {
        
        self.itemSize = self.collectionView.bounds.size;
    }
    
    
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
}

@end
