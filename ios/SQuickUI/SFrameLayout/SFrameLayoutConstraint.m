//
//  SConstraint.m
//  DrawSelfTest
//
//  Created by cs on 17/9/7.
//  Copyright © 2017年 cs. All rights reserved.
//

#import "SFrameLayoutConstraint.h"

#import "SFrameLayoutMaker.h"

#define MASMethodNotImplemented() \
@throw [NSException exceptionWithName:NSInternalInconsistencyException \
reason:[NSString stringWithFormat:@"You must override %@ in a subclass.", NSStringFromSelector(_cmd)] \
userInfo:nil]


@interface SFrameLayoutResultConstraint ()

@property (nonatomic, assign) NSLayoutRelation layoutRelation;

@property (nonatomic, assign) CGFloat layoutMultiplier;



@property (nonatomic, assign) CGSize sizeOffset;

@property (nonatomic, assign) CGPoint centerOffset;

@property (nonatomic, strong) SFrameLayoutAttr *firstAttr;



@property (nonatomic, assign) BOOL podValue;

@property (nonatomic, assign) int type;

@end

@implementation SFrameLayoutResultConstraint

- (void (^)(CGFloat))offset {
    return ^void(CGFloat offset) {
        self.layoutConstant = offset;
    };
}

- (instancetype)initWithFirstAttr:(SFrameLayoutAttr *)firstAttr secondAttr:(SFrameLayoutAttr *)secondAttr withLayout:(NSLayoutRelation)layout {
    self = [super init];
    if (self) {
        self.layoutRelation = layout;
        self.firstAttr = firstAttr;
        self.secondAttr = secondAttr;
        
    }
    
    return self;
}

- (void)calcFrame:(BOOL)normal
{
    if (normal) {
        switch (self.type) {
            case 0:
                _out_frame = CGRectMake(self.layoutConstant, self.layoutConstant, self.layoutConstant, self.layoutConstant);

                break;
            case 1:
                _out_frame = CGRectMake(self.centerOffset.x, self.centerOffset.y, 0, 0);

                break;
            case 2:
                _out_frame = CGRectMake(0, 0, self.sizeOffset.width, self.sizeOffset.height);

                break;
            default:
                break;
        }
        
    }
}

- (void)setLayoutConstantWithValue:(NSValue *)value {

    
    if ([value isKindOfClass:NSNumber.class]) {
        self.type = 0;
        self.layoutConstant = [(NSNumber *)value doubleValue];
        
    } else if (strcmp(value.objCType, @encode(CGPoint)) == 0) {
        CGPoint point;
        self.type = 1;
        [value getValue:&point];
        self.centerOffset = point;
    } else if (strcmp(value.objCType, @encode(CGSize)) == 0) {
        CGSize size;
        self.type = 2;
        [value getValue:&size];
        self.sizeOffset = size;
    } else {
        NSAssert(NO, @"attempting to set layout constant with unsupported value: %@", value);
    }
    
    [self calcFrame:YES];
}

- (void)setSecondAttr:(id)secondAttr
{
    self.podValue = NO;
    if ([secondAttr isKindOfClass:NSValue.class]) {
        [self setLayoutConstantWithValue:secondAttr];
        self.podValue = YES;
        return;
    } else if ([secondAttr isKindOfClass:SPanel.class]) {
        _secondAttr = [[SFrameLayoutAttr alloc] initWithPanel:secondAttr layoutAttr:self.firstAttr.layoutAttr];
    } else if ([secondAttr isKindOfClass:SFrameLayoutAttr.class]) {
        _secondAttr = secondAttr;
    } else {
        NSAssert(NO, @"attempting to add unsupported attribute: %@", @"setSecondAttr");
    }
}

@end








@interface SFrameLayoutConstraint ()

@end

@implementation SFrameLayoutConstraint

- (id)initWithAttr:(SFrameLayoutAttr *)attr
{
    self = [super init];
    if (self) {
        _attr = attr;
    }
    
    return self;
}

- (SFrameLayoutResultConstraint *(^)(id))fl_equalTo
{
    MASMethodNotImplemented();
}

#pragma mark - copying
- (id)copyWithZone:(NSZone *)zone {
    SFrameLayoutConstraint *fcon = [[SFrameLayoutConstraint alloc] initWithAttr:self.attr];
    
    return fcon;
}

- (SFrameLayoutResultConstraint *(^)(id))equalTo {
    return ^id(id attr) {
        return self.equalToWithRelation(attr, NSLayoutRelationEqual);
    };
}

- (SFrameLayoutResultConstraint *(^)(id, NSLayoutRelation))equalToWithRelation {
    return ^id(id attr, NSLayoutRelation relation) {
        SFrameLayoutResultConstraint *item = [[SFrameLayoutResultConstraint alloc] initWithFirstAttr:self.attr secondAttr:attr withLayout:relation];
        self.attr.item = item;
        
        return item;
    };
}

- (SFrameLayoutConstraint * (^)(CGFloat multiplier))multipliedBy {
    MASMethodNotImplemented();
}

- (BOOL)podValue
{
    return self.attr.item.podValue;
}

- (SFL_Type)type
{
    return self.attr.item.type;
}

- (void)install {

}

- (void)uninstall {
    MASMethodNotImplemented();
}

@end
