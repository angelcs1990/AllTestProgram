//
//  ModuleProtocol.h
//  TestRouter
//
//  Created by cs on 16/4/19.
//  Copyright © 2016年 cs. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ModuleProtocol <NSObject>
@required

@optional
/**
 *  模块类实现此协议可以做更多交互
 *
 *  @param cmd       命令
 *  @param dictParam 参数
 *
 *  @return 通信双方决定返回类型
 */
- (id)command:(NSInteger)cmd andParams:(NSDictionary *)dictParam;
@end
