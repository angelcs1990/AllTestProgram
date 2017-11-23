//
//  SRouter.m
//  TestRouter
//
//  Created by cs on 16/4/19.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "SRouterLocal.h"
#import "SRouterCmds.h"
#import "SRouterModuleProtocol.h"
#import <objc/runtime.h>
#import "SRouterMacro.h"
#import "SRouterCache.h"
#import "SRouterConfig.h"




@interface SRouterClassInfo : NSObject

@property (nonatomic, copy) NSString *className;
@property (nonatomic) NSInteger classType;
@property (nonatomic, weak) id classImp;
@property (nonatomic, copy) NSString *shortName;

+ (instancetype)routerClassInfo;

@end

@implementation SRouterClassInfo

+ (instancetype)routerClassInfo
{
    SRouterClassInfo *classInfo = [SRouterClassInfo new];
    
    return classInfo;
}

@end











#pragma mark -
#pragma mark - RouterHandlerContext
@implementation RouterHandlerContext

- (NSString *)targetClass
{
    if (_targetClass == nil && self.callee != nil) {
        _targetClass = NSStringFromClass([self.callee class]);
    }
    
    return _targetClass;
}

@end

@implementation RouterRulesContext

- (void)setOriName:(NSString *)oriName
{
    if (oriName == nil) {
        SRouterErrLog(@"plist规则文件解析出错，没有找到name字段");
    }
    
    _oriName = oriName;
}

- (void)setType:(SRouterRuleContextType)type
{
    if (type == SRouterRuleTypeErr) {
        SRouterErrLog(@"plist规则文件解析出错，没有找到type字段");
    }
    
    _type = type;
}

@end

@interface SRouterBase()

@property (nonatomic, weak) id<SRouterHandlerProtocol> child;

@property (nonatomic, strong) SRouterCache *dataContext;

@end

@implementation SRouterBase

- (instancetype)init
{
    self = [super init];
    if ([self conformsToProtocol:@protocol(SRouterHandlerProtocol)]) {
        self.child = (id<SRouterHandlerProtocol>)self;
    } else {
        NSAssert(NO, @"子类必须实现SRouterHandlerProtocol协议");
    }
    
    return self;
}

#pragma mark - setter and getter
- (SRouterCache *)dataContext
{
    if (_dataContext == nil) {
        _dataContext = [SRouterCache routerCache];
    }
    
    return _dataContext;
}

@end


#pragma mark -
#pragma mark - SRouterLocal

NSString *const keySRouter__Param_Cmd = @"_srouter_cmd";
NSString *const keySRouter__Param_Value = @"_souter_value";
NSString *const keySRouter__Param_ExtraParams = @"_srouter_extra_params_";
_SRouterDeclared(keySRouter_RegisterCmd_Param, @"_srouter_rcp");
_SRouterDeclared(keySRouter_RegisterCmd_Instance, @"_srouter_rci");
_SRouterDeclared(keySRouter_RegisterCmd_TargeName, @"_srouter_rctn");



@interface SRouterLocal ()<SRouterHandlerProtocol>

@end

@implementation SRouterLocal


+ (id<SRouterHandlerProtocol>)shareInstance
{
    static SRouterLocal *router;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        router = [[SRouterLocal alloc] init];
    });
    
    return router;
}

#pragma mark - lifecycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        if ([SRouterConfig shareInstance].autoLoadPlist) {
            [self loadModulePlist:SROUTER_DEFAULT_PLIST];
        }
    }
    
    return self;
}

#pragma mark - SRouterHandlerProtocol
- (id)handleCommand:(RouterHandlerContext *)context
{
    
    switch (context.cmd) {
        case RouterHandlerJump:
        {
            return [self routerJumpHandle:context];
        }
            break;
        case RouterHandlerRegister:
        {
            return [self routerRegisterHandle:context];
        }
            break;
        case RouterHandlerUnregister:
        {
            [self routerUnregisterHandle:context];
        }
            break;
        case RouterHandlerQuery:
        {
            return [self routerQueryHandle:context];
        }
            break;
        case RouterHandlerNotifySubscriber:
        {
            [self routerNotifySubscriber:context];
        }
            break;
        case RouterHandlerOther:
        {
            return [self routerOtherHandle:context];
        }
            break;
        case RouterHandlerRuleFiles:
        {
            [self routerRules:context];
        }
            break;
        default:
            break;
    }
    return nil;
}

#pragma mark - public method
- (void)registerShortName:(NSString *)shortName withFullClassName:(NSString *)fullClassName
{
    [self.dataContext registerShortName:shortName withFullClassName:fullClassName];
}

- (void)registerShortNameForDic:(NSDictionary *)dict
{
    [self.dataContext registerShortNameForDict:dict];
}

- (void)unregisterShortName:(NSString *)shortName
{
    [self.dataContext unregisterShortName:shortName];
}

- (void)unregisterShortNameForDic:(NSDictionary *)dict
{
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self.dataContext unregisterShortName:obj];
    }];
}

//- (void)registerTempService:(id)service
//{
//    [self.dataContext registerTempService:service];
//}
//
//- (void)unregisterTempService:(id)service
//{
//    [self.dataContext unregisterTempService:service];
//}

- (id)registerServiceWithClass:(NSString *)className
{
    //只能存在一个以该类名作为键值的实例类
    return [self.dataContext registerService:className];
    
}

- (void)unregisterServiceWithClass:(NSString *)className
{
    [self.dataContext unregisterService:className];
}

- (NSArray *)objectForProtocol:(Protocol *)protocol
{
    return [self.dataContext queryClassImpForProtocol:protocol];
}

- (BOOL)registerProtocol:(id)classIns forProtocol:(Protocol *)protocol
{
    return [self.dataContext registerProtocol:protocol classInstance:classIns];
}

- (void)unregisterProtocol:(id)classIns forProtocol:(Protocol *)protocol
{
    [self.dataContext unregisterProtocol:protocol classInstance:classIns];
}

- (BOOL)registerBlock:(SRouterHandler)block withInstance:(id)instance
{
    return [self.dataContext registerBlock:block withInstance:instance];
}

- (void)unregisterBlockWithInstance:(id)instance
{
    return [self.dataContext unregisterBlockWithInstance:instance];
}

- (BOOL)registerBlock:(SRouterHandler)block className:(NSString *)className
{
    return [self.dataContext registerBlock:block keyName:className];
}

- (void)unregisterBlock:(NSString *)className
{
    return [self.dataContext unregisterBlockWithKeyname:className];
}

- (SRouterHandler)blockForClassName:(NSString *)className
{
    return [self.dataContext queryBlockWithKeyName:className];
}

#pragma mark - private method
- (id)queryServiceClass:(NSString *)targetClassName
{
    id tmpTarget = [self.dataContext serviceForClassName:targetClassName];
    if (tmpTarget == nil) {
        tmpTarget = [[NSClassFromString(targetClassName) alloc] init];
    }
    
    return tmpTarget;
}

- (void)routerUnregisterHandle:(RouterHandlerContext *)context
{
    NSInteger cmd = [self _subCmd:context];
    if (cmd == SubUnregisterRouterHandlerSubscribe) {
        [self routerUnSubscribe:context];
        return;
    }
    
    id params = [self _subParams:context];
    
    if (params != nil && ![params isKindOfClass:[NSDictionary class]]) {
        NSAssert(0, @"routerRegisterHandle params error");
        return;
    }
    
    id param1 = [((NSDictionary *)params) objectForKey:keySRouter_RegisterCmd_Param];
    switch (cmd) {
        case SubUnregisterRouterHandlerBlock:
        {
            if (context.targetClass == nil) {
                id param2 = [((NSDictionary *)params) objectForKey:keySRouter_RegisterCmd_Instance];
                [self unregisterBlockWithInstance:param2];
            } else {
                [self unregisterBlock:context.targetClass];
            }
        }
            break;
        case SubUnregisterRouterHandlerProtocol:
        {
            id param2 = [((NSDictionary *)params) objectForKey:keySRouter_RegisterCmd_Instance];
            [self unregisterProtocol:param2 forProtocol:param1];
        }
            break;
        case SubRegisterRouterHandlerService:
        {
            [self unregisterServiceWithClass:context.targetClass];
        }
            break;
        case SubRegisterRouterHandlerMapname:
        {
            if ([param1 isKindOfClass:[NSDictionary class]]) {
                [self unregisterShortNameForDic:(NSDictionary *)param1];
            } else {
                [self unregisterShortName:param1];
            }
        }
            break;
        case SubUnregisterRouterHandlerSubscribe:
        {
            [self routerUnSubscribe:context];
        }
            break;
        default:
            break;
    }
}

- (BOOL)checkPlistWithInstance:(id)ins operType:(RouterHandlerCmds)opType from:(SRouterCmdFrom)fromType
{
    return [self checkPlistWithClassname:NSStringFromClass([ins class]) operType:opType from:fromType];
}

- (BOOL)checkPlistWithClassname:(NSString *)className operType:(RouterHandlerCmds)opType from:(SRouterCmdFrom)fromType
{
    if ([SRouterConfig shareInstance].checkAll == NO) {
        return YES;
    }
    
    if ([SRouterConfig shareInstance].onlyCheckLocal) {
        if (fromType == SRouterCmdFromLocal) {
            if ([SRouterConfig shareInstance].onlyCheckRegiste) {
                if (opType == RouterHandlerRegister) {
                    RouterRulesContext *retCtx = [self.dataContext queryRuleForName:className];
                    return (retCtx ? YES : NO);
                }
                
                return YES;
            } else {
                RouterRulesContext *retCtx = [self.dataContext queryRuleForName:className];
                return (retCtx ? YES : NO);
            }
        } else {
            return YES;
        }
        
    } else {
        RouterRulesContext *retCtx = [self.dataContext queryRuleForName:className];
        return (retCtx ? YES : NO);
    }
    
    
    return YES;
}

- (id)routerRegisterHandle:(RouterHandlerContext *)context
{
    
    NSInteger cmd = [self _subCmd:context];
    
    if (cmd == SubRegisterRouterHandlerSubscribe) {
        if (![self checkPlistWithInstance:context.callee operType:RouterHandlerRegister from:context.from]) {
//            SRouterErrLog(@"验证没通过");
            NSString *info = [NSString stringWithFormat:@"验证没通过:%@", NSStringFromClass([context.callee class])];
            SRouterErrLog(info);
            return nil;
        }
        
        [self routerSubscribe:context];
        return nil;
    }
    
    id params = [self _subParams:context];
    
    if (params != nil && ![params isKindOfClass:[NSDictionary class]]) {
        NSAssert(0, @"routerRegisterHandle params error");
        return nil;
    }

    id param1 = [((NSDictionary *)params) objectForKey:keySRouter_RegisterCmd_Param];
    
    switch (cmd) {
        case SubRegisterRouterHandlerBlock:
        {
            if (context.targetClass == nil) {
                id param2 = [((NSDictionary *)params) objectForKey:keySRouter_RegisterCmd_Instance];
                
                if (![self checkPlistWithInstance:param2 operType:RouterHandlerRegister from:context.from]) {
                    NSString *info = [NSString stringWithFormat:@"验证没通过:%@", NSStringFromClass([param2 class])];
                    SRouterErrLog(info);
                    return nil;
                }
                
                [self registerBlock:(SRouterHandler)param1 withInstance:param2];
            } else {
                [self registerBlock:(SRouterHandler)param1 className:context.targetClass];
            }
        }
            break;
        case SubRegisterRouterHandlerProtocol:
        {
            id param2 = [((NSDictionary *)params) objectForKey:keySRouter_RegisterCmd_Instance];
            
            if (![self checkPlistWithInstance:param2 operType:RouterHandlerRegister from:context.from]) {
                NSString *info = [NSString stringWithFormat:@"验证没通过:%@", NSStringFromClass([param2 class])];
                SRouterErrLog(info);
                return nil;
            }
            
            if(![self registerProtocol:param2 forProtocol:param1])
            {
                NSString *info = [NSString stringWithFormat:@"%@ module does not comply with %@ protocol", NSStringFromClass(param2), NSStringFromProtocol(param1)];
                SRouterErrLog(info);
            }
        }
            break;
        case SubRegisterRouterHandlerService:
        {
            if (![self checkPlistWithClassname:context.targetClass operType:RouterHandlerRegister from:context.from]) {
                NSString *info = [NSString stringWithFormat:@"验证没通过:%@", context.targetClass];
                SRouterErrLog(info);
                return nil;
            }
            return [self registerServiceWithClass:context.targetClass];
        }
            break;
        case SubRegisterRouterHandlerMapname:
        {
            if ([param1 isKindOfClass:[NSDictionary class]]) {
                [self registerShortNameForDic:(NSDictionary *)param1];
            } else {
                id param2 = [((NSDictionary *)params) objectForKey:keySRouter_RegisterCmd_TargeName];
                [self registerShortName:param1 withFullClassName:param2];
            }
            
        }
            break;
        case SubRegisterRouterHandlerOther:
            break;
        default:
            break;
    }
    
    return nil;
}

- (id)routerShowRemoteVC:(RouterHandlerContext *)context
{
    NSArray *arrayTargetsClassNames = [context.targetClass componentsSeparatedByString:@"/"];
    NSMutableArray *arrayTargets = [NSMutableArray array];
    for (NSString *target in arrayTargetsClassNames) {
        NSString *targetClassName = [self.dataContext queryClassName:target];
        
        if (![self checkPlistWithClassname:targetClassName operType:RouterHandlerRegister from:context.from]) {
            NSString *info = [NSString stringWithFormat:@"验证没通过:%@", targetClassName];
            SRouterErrLog(info);
            continue;
        }
        
        id<SRouterModuleProtocol> tmpTarget = [self queryServiceClass:targetClassName];
        if (tmpTarget == nil) {
            SRouterErrLog(@"routerShowRemoteVC target is nill");
            return nil;
        }
        
        
        id target = [self queryVCTarget:tmpTarget withParams:context.dictParam];
        
        //    [self addNewClassInfo:nil];
        if (target == nil || [target class] == [context.caller class]) {
            SRouterErrLog(@"routerShowRemoteVC target is nill");
            return nil;
        }
        
        [arrayTargets addObject:target];
    }
    
    UIViewController *sourceVC = [self queryCurrentVC];
    
    id params = [self _subParams:context];
    if (params != nil && ![params isKindOfClass:[NSDictionary class]]) {
        SRouterErrLog(@"routerShowRemtoeVC params error");
        return nil;
    }
    //多个界面动作，只有最后一个界面可以传递和返回参数
    switch ([self _subCmd:context]) {
        case SubJumpRouterHandlerPushWithParams:
        {
            id<SRouterModuleProtocol> targetLast = nil;
            if ([arrayTargets.lastObject conformsToProtocol:@protocol(SRouterModuleProtocol)]) {
                targetLast = arrayTargets.lastObject;
                if ([targetLast respondsToSelector:@selector(command:andParams:)]) {
                    [targetLast command:RouterModuleParams andParams:params];
                }
            }
            
        }
        case SubJumpRouterHandlerPush:
        {
            [sourceVC.navigationController setViewControllers:arrayTargets animated:YES];
            for (int i = 0; i < arrayTargets.count - 1; ++i) {
                [sourceVC.navigationController pushViewController:arrayTargets[i] animated:NO];
            }
            [sourceVC.navigationController pushViewController:arrayTargets.lastObject animated:YES];
        }
            break;
        case SubJumpRouterHandlerPresentWithParams:
        {
            id<SRouterModuleProtocol> targetLast = nil;
            if ([arrayTargets.lastObject conformsToProtocol:@protocol(SRouterModuleProtocol)]) {
                targetLast = arrayTargets.lastObject;
                if ([targetLast respondsToSelector:@selector(command:andParams:)]) {
                    [targetLast command:RouterModuleParams andParams:params];
                }
            }
        }
        case SubJumpRouterHandlerPresent:
        {
            for (int i = 0; i < arrayTargets.count - 1; ++i) {
                [sourceVC presentViewController:arrayTargets[i] animated:NO completion:nil];
            }
            [sourceVC presentViewController:arrayTargets.lastObject animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
    
    return arrayTargets.lastObject;
}
- (id)routerShowLocalVC:(RouterHandlerContext *)context
{
    
    NSString *targetClassName = context.targetClass;
    
    if (![self checkPlistWithClassname:targetClassName operType:RouterHandlerRegister from:context.from]) {
        NSString *info = [NSString stringWithFormat:@"验证没通过:%@", targetClassName];
        SRouterErrLog(info);
        return nil;
    }
    
//    先去服务类中查找是否存在
    id<SRouterModuleProtocol> tmpTarget = [self queryServiceClass:targetClassName];
    
    if (tmpTarget == nil) {
        return nil;
    }
    
    
    
    id target = [self queryVCTarget:tmpTarget withParams:context.dictParam];
    
    //    [self addNewClassInfo:nil];
    if (target == nil || [target class] == [context.caller class]) {
        SRouterErrLog(@"routerShowRemoteVC target is nill");
        return nil;
    }
    
    
    UIViewController *sourceVC = [self queryCurrentVC];
    
    id params = [self _subParams:context];
    if (params != nil && ![params isKindOfClass:[NSDictionary class]]) {
        SRouterErrLog(@"routerShowRemtoeVC params error");
        return nil;
    }
    
    switch ([self _subCmd:context]) {
        case SubJumpRouterHandlerPushWithParams:
            if (![tmpTarget conformsToProtocol:@protocol(SRouterModuleProtocol)]) {
                NSString *info = [NSString stringWithFormat:@"%@ module does not comply with %@ protocol", targetClassName, NSStringFromProtocol(@protocol(SRouterModuleProtocol))] ;
                SRouterErrLog(info);
                return nil;
            }
            [tmpTarget command:RouterModuleParams andParams:params];
        case SubJumpRouterHandlerPush:
            [sourceVC.navigationController pushViewController:target animated:YES];
            break;
        case SubJumpRouterHandlerPresentWithParams:
            if (![tmpTarget conformsToProtocol:@protocol(SRouterModuleProtocol)]) {
                NSString *info = [NSString stringWithFormat:@"%@ module does not comply with %@ protocol", targetClassName, NSStringFromProtocol(@protocol(SRouterModuleProtocol))];
                SRouterErrLog(info);
                return nil;
            }
            [tmpTarget command:RouterModuleParams andParams:params];
        case SubJumpRouterHandlerPresent:
            [sourceVC presentViewController:target animated:YES completion:nil];
            break;
        default:
            break;
    }
    
    return target;
}

- (id)routerJumpHandle:(RouterHandlerContext *)context
{
    if (context.from == SRouterCmdFromLocal) {
        return [self routerShowLocalVC:context];
    } else {
        return [self routerShowRemoteVC:context];
    }
}

- (void)loadModulePlist:(NSString *)plistPath
{
    NSString *tmpPath = [[NSBundle mainBundle] pathForResource:plistPath ofType:@"plist"];
    if (!tmpPath) {
        NSString *info = [NSString stringWithFormat:@"找不到%@配置文件", plistPath];
        SRouterLog(info);
        return;
    }
    
    NSArray *plistData = [[NSArray alloc] initWithContentsOfFile:tmpPath];
    NSMutableArray *tmpArray = [NSMutableArray array];
    
    
    for (int i = 0; i < plistData.count; ++i) {
        RouterRulesContext *ctx = [RouterRulesContext new];
        NSDictionary *obj = plistData[i];
        ctx.oriName = [obj objectForKey:@"name"];
        ctx.macroName = [obj objectForKey:@"macroName"];
        ctx.desc = [obj objectForKey:@"desc"];
        ctx.shortName = [obj objectForKey:@"shortName"];
        ctx.type = [[obj objectForKey:@"type" ] integerValue];
        
        [tmpArray addObject:ctx];
    }
    
    [self.dataContext addRules:tmpArray];
}

- (id)routerRules:(RouterHandlerContext *)context
{
    NSInteger subCmd = [[context.dictParam objectForKey:keySRouter__Param_Cmd] integerValue];
    
    
    switch (subCmd) {
        case SubRuleRouterHandleAdd:
        {
            NSString *value = [context.dictParam objectForKey:keySRouter__Param_Value];
            [self loadModulePlist:value];
        }
            break;
        case SubRuleRouterHandleClear:
            [self.dataContext clearRules];
            break;
        case SubRuleRouterHandleRemove:
        {
            NSString *value = [context.dictParam objectForKey:keySRouter__Param_Value];
            [self.dataContext removeRule:value];
        }
            break;
        default:
            break;
    }

    return nil;
}

- (id)routerOtherHandle:(RouterHandlerContext *)context
{
    NSString *targetClass = context.targetClass;
    
    if (![self checkPlistWithClassname:targetClass operType:RouterHandlerRegister from:context.from]) {
        NSString *info = [NSString stringWithFormat:@"验证没通过:%@", targetClass];
        SRouterErrLog(info);
        return nil;
    }
    
    //如果是已经注册了的已经实例化的类
    id<SRouterModuleProtocol> target = [self queryServiceClass:targetClass];
    
    if ([target respondsToSelector:@selector(command:andParams:)]) {
        return [target command:RouterModuleOtherCmd andParams:context.dictParam];
    }
    
    return nil;
}

- (void)routerUnSubscribe:(RouterHandlerContext *)context
{
    NSInteger msg = [[self _subParams:context][@"msg"] integerValue];
    id target = context.callee;
    if (target == nil) {
//        target = self;
        return;
    }
    
    [self.dataContext unregisterSubscriberInstance:[self _subParams:context][@"caller"] withDestObj:target withMsg:msg];
}

- (id)routerNotifySubscriber:(RouterHandlerContext *)context
{
    if (![self checkPlistWithInstance:context.caller operType:RouterHandlerRegister from:context.from]) {
        NSString *info = [NSString stringWithFormat:@"验证没通过:%@", NSStringFromClass([context.callee class])];
        SRouterErrLog(info);
        return nil;
    }
    
    NSInteger msg = [self _subCmd:context];

    NSArray *arrayRet = [self.dataContext subscriberObjects:context.caller withMsg:msg];
    NSDictionary *params = [self _subParams:context];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [arrayRet enumerateObjectsUsingBlock:^(NSValue  * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [[obj nonretainedObjectValue] command:RouterModuleNotifySubscriberCmd andParams:params];
        }];
    });
    
    
    
    return nil;
}

- (id)routerSubscribe:(RouterHandlerContext *)context
{
    NSInteger msg = [[self _subParams:context] integerValue];
    id target = context.callee;
    if (target == nil) {
//        target = self;
        return nil;
    }
    
    if ([target conformsToProtocol:@protocol(SRouterModuleProtocol)] == NO) {
        return nil;
    }
    
    [self.dataContext registerSubscriberInstance:context.caller withDestObj:target withMsg:msg];
    
//    NSDictionary *dictParams = context.dictParam[keySRouter__Param_ExtraParams];

//    [target command:RouterModuleSubscriberCmd andParams:nil];
    return nil;
}

- (id)routerQueryHandle:(RouterHandlerContext *)context
{
    if (context == nil) {
        return nil;
    }
    NSInteger cmd = [self _subCmd:context];
    //@{keySRouter__Param_Cmd:cmd, keySRouter__Param_Value:param}
    switch (cmd) {
        case SubQueryRouterHandlerViewController:
        {
            NSString *targetClass = context.dictParam[keySRouter__Param_Value];
            
            if (![self checkPlistWithClassname:targetClass operType:RouterHandlerRegister from:context.from]) {
                NSString *info = [NSString stringWithFormat:@"验证没通过:%@", targetClass];
                SRouterErrLog(info);
                return nil;
            }
            
            id<SRouterModuleProtocol> target = [self queryServiceClass:targetClass];
            if ([target respondsToSelector:@selector(command:andParams:)]) {
                return [target command:RouterModuleQueryViewControlelr andParams:nil];
            }
        }
            break;
        case SubQueryRouterHandlerProtocol:
        {
            Protocol *protocol = context.dictParam[keySRouter__Param_Value];
            return [self.dataContext queryClassImpForProtocol:protocol];
        }
            break;
        case SubQueryRouterHandlerBlock:
        {
            id value = context.dictParam[keySRouter__Param_Value];
            if ([value isKindOfClass:[NSString class]]) {
                return [self.dataContext queryBlockWithKeyName:value];
            } else {
                if (![self checkPlistWithInstance:value operType:RouterHandlerRegister from:context.from]) {
                    NSString *info = [NSString stringWithFormat:@"验证没通过:%@", [value class]];
                    SRouterErrLog(info);
                    return nil;
                }
                return [self.dataContext queryBlockWithInstance:value];
            }
        }
            break;
        case SubQueryRouterHandlerOther:
        default:
            break;
    }
    
    return nil;
}






- (NSInteger)_subCmd:(RouterHandlerContext *)ctx
{
    NSInteger cmd = [ctx.dictParam[keySRouter__Param_Cmd] integerValue];
    return cmd;
}

- (id)_subParams:(RouterHandlerContext *)ctx
{
    id params = ctx.dictParam[keySRouter__Param_Value];
    return params;
}


- (UIViewController *)queryCurrentVC
{
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (rootVC == nil) {
        rootVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    }
    UIViewController *sourceVC = nil;
    if ([rootVC isKindOfClass:[UINavigationController class]]) {
        sourceVC = [((UINavigationController *)rootVC) visibleViewController];
    } else {
        if (rootVC.presentedViewController) {
            sourceVC = rootVC.presentedViewController;
        } else {
            sourceVC = rootVC;
        }
    }
    
    return sourceVC;
}



- (id)queryVCTarget:(id)tmpTarget withParams:(NSDictionary *)dictParam
{
    id target;
    //如果不是UIViewController对象就要调对方接口拿UIViewController对象
    if ([tmpTarget isKindOfClass:[UIViewController class]]) {
        target = tmpTarget;
    } else if ([tmpTarget respondsToSelector:@selector(command:andParams:)]) {
        id obj = [tmpTarget command:RouterModuleQueryViewControlelr andParams:dictParam];
        if ([obj isKindOfClass:[UIViewController class]]) {
            target = obj;
        }
    }

    return target;
}


#pragma mark - setter and getter


@end
