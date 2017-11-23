//
//  WebViewController.h
//  GGDemo
//
//  Created by cs on 16/6/20.
//  Copyright © 2016年 cs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWebViewController : UIViewController
- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

/**
 *  是否启用进度条显示
 */
@property (nonatomic) BOOL allowProgress;

/**
 *  进度条样式设置
 */
@property (nonatomic, strong) UIColor *progressBackgroundColor;
@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic) CGFloat progressHeight;

/**
 *  title标题，如果不设置，显示网页标题
 */
@property (nonatomic, strong) NSString *navTitle;
/**
 *  是否需要一级一级返回操作，默认YES
 */
@property (nonatomic) BOOL allowPageBack;
/**
 *  是否需要手势返回，默认YES(如果allowPageBack为NO，它也是NO）
 */
@property (nonatomic) BOOL allowsBackForwardNavigationGestures;

/**
 *  设置网页内的返回按钮样式
 */
@property (nonatomic, strong) UIButton *buttonWebBack;

+ (instancetype)initWithUrl:(NSString *)url withTitle:(NSString *)title;
@end
