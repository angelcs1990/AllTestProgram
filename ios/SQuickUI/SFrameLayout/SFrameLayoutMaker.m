//
//  SFrameLayoutMaker.m
//  DrawSelfTest
//
//  Created by cs on 17/9/7.
//  Copyright © 2017年 cs. All rights reserved.
//

#import "SFrameLayoutMaker.h"
#import "SPanel+Geometry.h"

typedef NS_ENUM(NSInteger, _InnerType) {
    _InnerTypeTop = 1,
    _InnerTypeBottom,
    _InnerTypeLeft,
    _InnerTypeRight,
    _InnerTypeWidth,
    _InnerTypeHeight,
    _InnerTypeCenterX,
    _InnerTypeCenterY,
    _InnerTypeSize,
    _InnerTypeCenter,
    _InnerTypeEdges,
    _InnerTypeNone
};

@interface SFrameLayoutMaker ()

@property (nonatomic, weak) SPanel *view;

@property (nonatomic, strong) NSMutableDictionary *constraints;

@end

@implementation SFrameLayoutMaker

- (id)initWithView:(SPanel *)view {
    self = [super init];
    if (self) {
        self.view = view;
        self.constraints = NSMutableDictionary.new;
    }
    
    return self;
}

- (void)calcFrameWithItem:(SFrameLayoutConstraint *)item withType:(_InnerType)type
{
    if (item.podValue) {
        //普通
        if (type == _InnerTypeCenter) {
            self.view.centerX = item.attr.item.out_frame.origin.x + item.attr.item.layoutConstant;
            self.view.centerY = item.attr.item.out_frame.origin.y + item.attr.item.layoutConstant;
        } else if (type == _InnerTypeSize) {
            self.view.width = item.attr.item.out_frame.size.width + item.attr.item.layoutConstant;
            self.view.height = item.attr.item.out_frame.size.height + item.attr.item.layoutConstant;
        } else if (type == _InnerTypeEdges) {
            
        } else if (type == _InnerTypeTop) {
            self.view.y = item.attr.item.out_frame.origin.y + item.attr.item.layoutConstant;
        } else if (type == _InnerTypeLeft) {
            self.view.x = item.attr.item.out_frame.origin.x + item.attr.item.layoutConstant;
        } else if (type == _InnerTypeBottom) {
            self.view.bottom = item.attr.item.out_frame.origin.x + item.attr.item.layoutConstant;
        } else if (type == _InnerTypeRight) {
            self.view.right = item.attr.item.out_frame.origin.x + item.attr.item.layoutConstant;
        } else if (type == _InnerTypeWidth) {
            self.view.width = item.attr.item.out_frame.size.width;
        } else if (type == _InnerTypeHeight) {
            self.view.height = item.attr.item.out_frame.size.height;
        } else if (type == _InnerTypeCenterX) {
            self.view.centerX = item.attr.item.out_frame.origin.x;
        } else if (type == _InnerTypeCenterY) {
            self.view.centerY = item.attr.item.out_frame.origin.y;
        }
    } else {
        //对象
        CGFloat tmpValue = [self anlyzeValueWithCons:item.attr.item];
        if (type == _InnerTypeCenter) {
            self.view.centerX = item.attr.item.secondAttr.panel.centerX + item.attr.item.layoutConstant;
            self.view.centerY = item.attr.item.secondAttr.panel.centerY + item.attr.item.layoutConstant;
        } else if (type == _InnerTypeSize) {
            self.view.width = item.attr.item.secondAttr.panel.width + item.attr.item.layoutConstant;
            self.view.height = item.attr.item.secondAttr.panel.height + item.attr.item.layoutConstant;
        } else if (type == _InnerTypeEdges) {
            
        } else if (type == _InnerTypeTop) {
            self.view.y = tmpValue + item.attr.item.layoutConstant;
        } else if (type == _InnerTypeLeft) {
            self.view.x = tmpValue + item.attr.item.layoutConstant;
        } else if (type == _InnerTypeBottom) {
            self.view.bottom = tmpValue + item.attr.item.layoutConstant;
        } else if (type == _InnerTypeRight) {
            self.view.right = tmpValue + item.attr.item.layoutConstant;
        } else if (type == _InnerTypeWidth) {
            self.view.width = tmpValue + item.attr.item.layoutConstant;
        } else if (type == _InnerTypeHeight) {
            self.view.height = tmpValue + item.attr.item.layoutConstant;
        } else if (type == _InnerTypeCenterX) {
            self.view.centerX = tmpValue + item.attr.item.layoutConstant;
        } else if (type == _InnerTypeCenterY) {
            self.view.centerY = tmpValue + item.attr.item.layoutConstant;
        }
    }
}

- (CGFloat)anlyzeValueWithCons:(SFrameLayoutResultConstraint *)cons
{
    if (cons.secondAttr.panel == self.view.superPanel) {
        //如果是父
        if (cons.secondAttr.layoutAttr & MASAttributeTop) {
            return 0;
        } else if (cons.secondAttr.layoutAttr & MASAttributeLeft) {
            return 0;
        } else if (cons.secondAttr.layoutAttr & MASAttributeRight) {
            return cons.secondAttr.panel.width;
        } else if (cons.secondAttr.layoutAttr & MASAttributeBottom) {
            return cons.secondAttr.panel.height;
        } else if (cons.secondAttr.layoutAttr & MASAttributeCenterX) {
            return cons.secondAttr.panel.width / 2.0f;
        } else if (cons.secondAttr.layoutAttr & MASAttributeCenterY) {
            return cons.secondAttr.panel.height / 2.0f;
        } else if (cons.secondAttr.layoutAttr & MASAttributeWidth) {
            return cons.secondAttr.panel.width;
        } else if (cons.secondAttr.layoutAttr & MASAttributeHeight) {
            return cons.secondAttr.panel.height;
        }
    } else {
        if (cons.secondAttr.layoutAttr & MASAttributeTop) {
            return cons.secondAttr.panel.y;
        } else if (cons.secondAttr.layoutAttr & MASAttributeLeft) {
            return cons.secondAttr.panel.x;
        } else if (cons.secondAttr.layoutAttr & MASAttributeRight) {
            return cons.secondAttr.panel.right;
        } else if (cons.secondAttr.layoutAttr & MASAttributeBottom) {
            return cons.secondAttr.panel.bottom;
        } else if (cons.secondAttr.layoutAttr & MASAttributeCenterX) {
            return cons.secondAttr.panel.centerX;
        } else if (cons.secondAttr.layoutAttr & MASAttributeCenterY) {
            return cons.secondAttr.panel.centerY;
        } else if (cons.secondAttr.layoutAttr & MASAttributeWidth) {
            return cons.secondAttr.panel.width;
        } else if (cons.secondAttr.layoutAttr & MASAttributeHeight) {
            return cons.secondAttr.panel.height;
        }
    }
    
    
    return 0;
}

- (void)install {

    [self.constraints enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, SFrameLayoutConstraint * obj, BOOL * _Nonnull stop) {
        _InnerType tmpType = [key integerValue];
        [self calcFrameWithItem:obj withType:tmpType];
    }];
    

    [self.constraints removeAllObjects];
}


- (SFrameLayoutConstraint *)addConstraintWithLayoutAttr:(MASAttribute)layoutAttr {
    SFrameLayoutAttr *attr = [[SFrameLayoutAttr alloc] initWithPanel:self.view layoutAttr:layoutAttr];
    SFrameLayoutConstraint *constr = [[SFrameLayoutConstraint alloc] initWithAttr:attr];

    
    _InnerType tmpType;
    if ((layoutAttr & MASAttributeTop) && (layoutAttr & MASAttributeBottom) && (layoutAttr & MASAttributeLeft) && (layoutAttr & MASAttributeRight)) {
        tmpType = _InnerTypeEdges;
    } else if ((layoutAttr & MASAttributeWidth) && (layoutAttr & MASAttributeHeight)) {
        tmpType = _InnerTypeSize;
    } else if ((layoutAttr & MASAttributeCenterX) && (layoutAttr & MASAttributeCenterY)) {
        tmpType = _InnerTypeCenter;
    } else if (layoutAttr & MASAttributeTop) {
        tmpType = _InnerTypeTop;
    } else if (layoutAttr & MASAttributeBottom) {
        tmpType = _InnerTypeBottom;
    } else if (layoutAttr & MASAttributeLeft) {
        tmpType = _InnerTypeLeft;
    } else if (layoutAttr & MASAttributeRight) {
        tmpType = _InnerTypeRight;
    } else if (layoutAttr & MASAttributeWidth) {
        tmpType = _InnerTypeWidth;
    } else if (layoutAttr & MASAttributeHeight) {
        tmpType = _InnerTypeHeight;
    } else if (layoutAttr & MASAttributeCenterY) {
        tmpType = _InnerTypeCenterY;
    } else if (layoutAttr & MASAttributeCenterX) {
        tmpType = _InnerTypeCenterX;
    } else {
        tmpType = _InnerTypeNone;
    }
    
    
    self.constraints[@(tmpType)] = constr;
    
    return constr;
}



- (SFrameLayoutConstraint *)edges {
    return [self addConstraintWithLayoutAttr:MASAttributeTop | MASAttributeLeft | MASAttributeRight | MASAttributeBottom];
}

- (SFrameLayoutConstraint *)size {
    return [self addConstraintWithLayoutAttr:MASAttributeWidth | MASAttributeHeight];
}

- (SFrameLayoutConstraint *)center {
    return [self addConstraintWithLayoutAttr:MASAttributeCenterX | MASAttributeCenterY];
}

- (SFrameLayoutConstraint *)top {
    return [self addConstraintWithLayoutAttr:MASAttributeTop];
}

- (SFrameLayoutConstraint *)right {
    return [self addConstraintWithLayoutAttr:MASAttributeRight];
}

- (SFrameLayoutConstraint *)bottom {
    return [self addConstraintWithLayoutAttr:MASAttributeBottom];
}

- (SFrameLayoutConstraint *)width {
    return [self addConstraintWithLayoutAttr:MASAttributeWidth];
}

- (SFrameLayoutConstraint *)height {
    return [self addConstraintWithLayoutAttr:MASAttributeHeight];
}

- (SFrameLayoutConstraint *)centerX {
    return [self addConstraintWithLayoutAttr:MASAttributeCenterX];
}

- (SFrameLayoutConstraint *)centerY {
    return [self addConstraintWithLayoutAttr:MASAttributeCenterY];
}

- (SFrameLayoutConstraint *)left {
    return [self addConstraintWithLayoutAttr:MASAttributeLeft];
}

@end
