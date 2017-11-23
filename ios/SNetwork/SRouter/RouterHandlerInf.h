//
//  RouterHandlerInf.h
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
//@property (nonatomic, weak) UIViewController *sourceObj;    //没用的参数
@property (nonatomic, weak) id caller;  //调用者实例
@property (nonatomic) NSInteger cmd;                        //命令
@property (nonatomic, copy) NSDictionary *dictParam;        //参数
@property (nonatomic) SRouterCmdFrom from;                  //本地还是远程调用
//@property (nonatomic, copy) Protocol *protocol;
@end



/**
 *  接口文件
 */
@protocol RouterHandlerInf <NSObject>
@required
/**
 *  命令提交
 *
 *  @param context 命令上下文
 *
 *  @return 双方协定类型
 */
- (id)handlerCommand:(RouterHandlerContext *)context;


@end
