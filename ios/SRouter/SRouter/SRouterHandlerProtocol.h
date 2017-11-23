//
//  SRouterHandlerProtocol.h
//  TestRouter
//
//  Created by cs on 16/4/19.
//  Copyright © 2016年 cs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef void (^SRouterHandler)(NSDictionary *dictParams);
typedef NS_ENUM(NSInteger, SRouterCmdFrom) {
    SRouterCmdFromLocal,
    SRouterCmdFromRemote
};



@interface RouterHandlerContext : NSObject

@property (nonatomic, copy) NSString *targetClass;          //目标类名
@property (nonatomic, weak) id callee;  //目标实例
@property (nonatomic, weak) id caller;  //调用者实例
@property (nonatomic) NSInteger cmd;                        //命令
@property (nonatomic, copy) NSDictionary *dictParam;        //参数
@property (nonatomic) SRouterCmdFrom from;                  //本地还是远程调用

@end


typedef NS_ENUM(NSInteger, SRouterRuleContextType) {
    SRouterRuleTypeErr = 0,
    SRouterRuleTypeService = 1,
    SRouterRuleTypeModule,
    SRouterRuleTypeNormal,
    SRouterRuleTypeOther
};

@interface RouterRulesContext : NSObject

@property (nonatomic, copy) NSString *oriName;
@property (nonatomic)  SRouterRuleContextType type;
@property (nonatomic, copy) NSString *shortName;
@property (nonatomic, copy) NSString *macroName;
@property (nonatomic, copy) NSString *desc;

@end


/**
 *  接口文件
 */
@protocol SRouterHandlerProtocol <NSObject>

@required
/**
 *  命令提交
 *
 *  @param context 命令上下文
 *
 *  @return 双方协定类型
 */
- (id)handleCommand:(RouterHandlerContext *)context;

@end
