//
//  SRouter.m
//  TestRouter
//
//  Created by cs on 16/4/19.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "SRouterLocal.h"
#import "publicInf_cmds.h"
#import "ModuleProtocol.h"
#import <objc/runtime.h>
#import "publicInf_macro.h"



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






/**
 *  上下文数据
 */
@interface _SRouterDataContext : NSObject


//Protocol----array(className)
@property (nonatomic, strong) NSMutableDictionary *dictProtocolsAndTarget;
@property (nonatomic, strong) NSMutableDictionary *dictKeyClassAndInfo;
@property (nonatomic, strong) NSMutableDictionary *dictBlocksAndTarget;
@property (nonatomic, strong) NSMutableDictionary *dictShareInstance;

+ (instancetype)routerDataContext;

- (void)registerShortName:(NSString *)name withFullClassName:(NSString *)fullClassName;
- (void)registerShortNameForDict:(NSDictionary *)dict;
- (void)unregisterShortName:(NSString *)name;
- (NSString *)queryClassName:(NSString *)keyClassName;
- (NSArray *)queryClassImpForProtocol:(Protocol *)keyProtocol;

- (BOOL)registerProtocol:(Protocol *)keyProtocol classInstance:(id)classIns;
- (void)unregisterProtocol:(Protocol *)keyProtocol classInstance:(id)classIns;

- (BOOL)registerBlock:(SRouterHandler)block className:(NSString *)className;
- (SRouterHandler)queryBlockWithClassName:(NSString *)className;
@end
@implementation _SRouterDataContext

+ (instancetype)routerDataContext
{
    _SRouterDataContext *context = [_SRouterDataContext new];
    return context;
}

#pragma mark - lifecycle
- (void)dealloc
{
    [self.dictProtocolsAndTarget removeAllObjects];
    [self.dictKeyClassAndInfo removeAllObjects];
    [self.dictBlocksAndTarget removeAllObjects];
}
#pragma mark -
//- (void)addClassInfo:(NSString *)keyClassName classInfo:(SRouterClassInfo *)classInfo
//{
//    NSAssert(keyClassName != nil && classInfo != nil, @"addClassInfo pass value error");
//    [self.dictKeyClassAndInfo setObject:classInfo forKey:keyClassName];
//}
//- (void)alterClassInfo:(NSString *)keyClassName classInfo:(SRouterClassInfo *)classInfo
//{
//    [self addClassInfo:keyClassName classInfo:classInfo];
//}
//- (void)removeClassInfo:(NSString *)keyClassName
//{
//    NSAssert(keyClassName != nil, @"removeClassInfo pass value error");
//    [self.dictKeyClassAndInfo removeObjectForKey:keyClassName];
//}
- (void)registerShortName:(NSString *)name withFullClassName:(NSString *)fullClassName
{
    if (name && fullClassName) {
        [self.dictKeyClassAndInfo setObject:name forKey:fullClassName];
    }
}
- (void)registerShortNameForDict:(NSDictionary *)dict
{
    if (dict) {
        [self.dictKeyClassAndInfo setDictionary:dict];
    }
}
- (void)unregisterShortName:(NSString *)name
{
    if (name) {
        [self.dictKeyClassAndInfo removeObjectForKey:name];
    }
}
- (NSString *)queryClassName:(NSString *)keyClassName
{
    NSString *fullClassName = self.dictKeyClassAndInfo[keyClassName];
    
    __block NSString *className = fullClassName;
    if (fullClassName == nil) {
        [self.dictKeyClassAndInfo enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop){
            if ([value isEqualToString:keyClassName]) {
                className = value;
                *stop = YES;
            }
        }];
    }
    
    return className;
}
- (NSArray *)queryClassImpForProtocol:(Protocol *)keyProtocol
{
    //查找classname
    NSString *protocol = NSStringFromProtocol(keyProtocol);
    NSSet *arrayClassNames = self.dictProtocolsAndTarget[protocol];
    
    NSMutableArray *arrayImps = [NSMutableArray array];
    [arrayClassNames enumerateObjectsUsingBlock:^(id classIns, BOOL *stop){
        [arrayImps addObject:classIns];
        
    }];
    
    
    //移除
//    [self.dictProtocolsAndTarget removeObjectForKey:protocol];
    
    return arrayImps;
}
- (BOOL)registerBlock:(SRouterHandler)block className:(NSString *)className
{
    if (block == nil || className == nil) {
        return NO;
    }
    
    self.dictBlocksAndTarget[className] = [block copy];
    return YES;
}
- (void)unregisterBlock:(NSString *)className
{
    [self.dictBlocksAndTarget removeObjectForKey:className];
}
- (SRouterHandler)queryBlockWithClassName:(NSString *)className
{
    SRouterHandler blockHandler = self.dictBlocksAndTarget[className];
//    [self.dictBlocksAndTarget removeObjectForKey:className];
    
    return blockHandler;
}
- (BOOL)registerProtocol:(Protocol *)keyProtocol classInstance:(id)classIns
{
    if (keyProtocol == nil || classIns == nil) {
        return NO;
    }
    NSString *protocol = NSStringFromProtocol(keyProtocol);
    if ([self.dictProtocolsAndTarget objectForKey:protocol] == nil) {
        self.dictProtocolsAndTarget[protocol] = [NSMutableSet set];
    }

    //检查是否符合协议
    if ([classIns conformsToProtocol:keyProtocol]) {
        
        [self.dictProtocolsAndTarget[protocol] addObject:classIns];
        
        return YES;
    }
    
    
    return NO;
    
}
- (void)unregisterProtocol:(Protocol *)keyProtocol classInstance:(id)classIns
{
    NSString *protocol = NSStringFromProtocol(keyProtocol);
    if ([self.dictProtocolsAndTarget objectForKey:protocol] != nil) {
        [self.dictProtocolsAndTarget[protocol] removeObject:classIns];
        
        if ([self.dictProtocolsAndTarget[protocol] count] == 0) {
            [self.dictProtocolsAndTarget removeObjectForKey:protocol];
        }
    }
}


- (void)registerShareInstance:(NSString *)className
{
    if (className == nil || [className isEqualToString:@""]) {
        return;
    }
    //如果不存在该类
    if (NSClassFromString(className) == nil) {
        return;
    }
    [self.dictShareInstance setObject:[[NSClassFromString(className) alloc] init] forKey:className];
}
- (void)unregisterShareInstance:(NSString *)className
{
    if (className == nil) {
        return;
    }
    [self.dictShareInstance removeObjectForKey:className];
}
- (id)shareInstanceForClassName:(NSString *)className
{
    return [self.dictShareInstance objectForKey:className];
}
#pragma mark - setter and getter
- (NSMutableDictionary *)dictShareInstance
{
    if (_dictShareInstance == nil) {
        _dictShareInstance = [NSMutableDictionary dictionary];
    }
    
    return _dictShareInstance;
}
- (NSMutableDictionary *)dictProtocolsAndTarget
{
    if (_dictProtocolsAndTarget == nil) {
        _dictProtocolsAndTarget = [NSMutableDictionary dictionary];
    }
    
    return _dictProtocolsAndTarget;
}
- (NSMutableDictionary *)dictKeyClassAndInfo
{
    if (_dictKeyClassAndInfo == nil) {
        _dictKeyClassAndInfo = [NSMutableDictionary dictionary];
    }
    
    return _dictKeyClassAndInfo;
}
- (NSMutableDictionary *)dictBlocksAndTarget
{
    if (_dictBlocksAndTarget == nil) {
        _dictBlocksAndTarget = [NSMutableDictionary dictionary];
    }
    
    return _dictBlocksAndTarget;
}
@end

















@implementation RouterHandlerContext
@end



@interface SRouterBase()

@property (nonatomic, weak) id<RouterHandlerInf> child;

@property (nonatomic, strong) _SRouterDataContext *dataContext;
@end
@implementation SRouterBase

- (instancetype)init
{
    self = [super init];
    if ([self conformsToProtocol:@protocol(RouterHandlerInf)]) {
        self.child = (id<RouterHandlerInf>)self;
    } else {
        NSAssert(NO, @"子类必须实现RouterHandlerInf协议");
    }
    
    return self;
}

#pragma mark - setter and getter
- (_SRouterDataContext *)dataContext
{
    if (_dataContext == nil) {
        _dataContext = [_SRouterDataContext routerDataContext];
    }
    
    return _dataContext;
}

@end












NSString *const keySRouter__Param_Cmd = @"_srouter_cmd";
NSString *const keySRouter__Param_Value = @"_souter_value";
SROUTER_DECLARED_NAME(keySRouter_RegisterCmd_Param, @"_srouter_rcp");
SROUTER_DECLARED_NAME(keySRouter_RegisterCmd_Instance, @"_srouter_rci");
SROUTER_DECLARED_NAME(keySRouter_RegisterCmd_TargeName, @"_srouter_rctn");



@interface SRouterLocal ()<RouterHandlerInf>
@property (nonatomic, strong) NSMutableDictionary *dictClass;    //type - class
@end

@implementation SRouterLocal


+ (id<RouterHandlerInf>)routerLocalShareInstance
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
//        [self loadModulePlist:@"modulelist"];
    }
    
    return self;
}
#pragma mark - public method
- (id)handlerCommand:(RouterHandlerContext *)context
{
    
    switch (context.cmd) {
        case RouterHandlerJump:
        {
            [self routerJumpHandle:context];
        }
            break;
        case RouterHandlerRegister:
        {
            [self routerRegisterHandle:context];
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
        case RouterHandlerOther:
        {
            return [self routerOtherHandle:context];
        }
            break;
        default:
            break;
    }
    return nil;
}
#pragma mark - RouterHandlerInf
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

- (void)registerShareInstanceClass:(NSString *)className
{
    //只能存在一个以该类名作为键值的实例类
    [self.dataContext registerShareInstance:className];
    
}
- (void)unregisterShareInstanceClass:(NSString *)className
{
    [self.dataContext unregisterShareInstance:className];
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


- (BOOL)registerBlock:(SRouterHandler)block className:(NSString *)className
{
    return [self.dataContext registerBlock:block className:className];
}
- (void)unregisterBlock:(NSString *)className
{
    return [self.dataContext unregisterBlock:className];
}
- (SRouterHandler)blockForClassName:(NSString *)className
{
    return [self.dataContext queryBlockWithClassName:className];
}

#pragma mark - private method
- (void)routerUnregisterHandle:(RouterHandlerContext *)context
{
    NSInteger cmd = [self _subCmd:context];
    id params = [self _subParams:context];
    
    if (params != nil && ![params isKindOfClass:[NSDictionary class]]) {
        NSAssert(0, @"routerRegisterHandle params error");
        return;
    }
    
    id param1 = [((NSDictionary *)params) objectForKey:keySRouter_RegisterCmd_Param];
    switch (cmd) {
        case RouterHandlerUnregisterBlock:
        {
            [self unregisterBlock:context.targetClass];
        }
            break;
        case RouterHandlerUnregisterProtocol:
        {
            id param2 = [((NSDictionary *)params) objectForKey:keySRouter_RegisterCmd_Instance];
            [self unregisterProtocol:param2 forProtocol:param1];
        }
            break;
        case RouterHandlerRegisterService:
        {
            [self unregisterShareInstanceClass:context.targetClass];
        }
            break;
        case RouterHandlerRegisterMapname:
        {
            if ([param1 isKindOfClass:[NSDictionary class]]) {
                [self unregisterShortNameForDic:(NSDictionary *)param1];
            } else {
                [self unregisterShortName:param1];
            }
        }
            break;
        default:
            break;
    }
}
- (void)routerRegisterHandle:(RouterHandlerContext *)context
{
    NSInteger cmd = [self _subCmd:context];
    id params = [self _subParams:context];
    
    if (params != nil && ![params isKindOfClass:[NSDictionary class]]) {
        NSAssert(0, @"routerRegisterHandle params error");
        return;
    }
//    @{keySRouter__Param_Cmd:cmd, keySRouter__Param_Value:@{keySRouter_RegisterCmd_Param:param1, keySRouter_RegisterCmd_Instance:param2, keySRouter_RegisterCmd_TargeName:param3}}
    id param1 = [((NSDictionary *)params) objectForKey:keySRouter_RegisterCmd_Param];
    
    switch (cmd) {
        case RouterHandlerRegisterBlock:
        {
            [self registerBlock:(SRouterHandler)param1 className:context.targetClass];
        }
            break;
        case RouterHandlerRegisterProtocol:
        {
            id param2 = [((NSDictionary *)params) objectForKey:keySRouter_RegisterCmd_Instance];
            [self registerProtocol:param2 forProtocol:param1];
        }
            break;
        case RouterHandlerRegisterService:
        {
            [self registerShareInstanceClass:context.targetClass];
        }
            break;
        case RouterHandlerRegisterMapname:
        {
            if ([param1 isKindOfClass:[NSDictionary class]]) {
                [self registerShortNameForDic:(NSDictionary *)param1];
            } else {
                id param2 = [((NSDictionary *)params) objectForKey:keySRouter_RegisterCmd_TargeName];
                [self registerShortName:param1 withFullClassName:param2];
            }
            
        }
            break;
        case RouterHandlerRegisterOther:
            break;
        default:
            break;
    }
}
- (void)routerShowRemoteVC:(RouterHandlerContext *)context
{
    NSArray *arrayTargetsClassNames = [context.targetClass componentsSeparatedByString:@"/"];
    NSMutableArray *arrayTargets = [NSMutableArray array];
    for (NSString *target in arrayTargetsClassNames) {
        NSString *targetClassName = [self.dataContext queryClassName:target];
        
        
        id<ModuleProtocol> tmpTarget = [[NSClassFromString(targetClassName) alloc] init];
        if (tmpTarget == nil) {
            SROUTER_LOG(@"routerShowRemoteVC target is nill");
            return;
        }
        
        
        id target = [self queryVCTarget:tmpTarget withParams:context.dictParam];
        
        //    [self addNewClassInfo:nil];
        if (target == nil || [target class] == [context.caller class]) {
            SROUTER_LOG(@"routerShowRemoteVC target is nill");
            return;
        }
        
        [arrayTargets addObject:target];
    }
    
    UIViewController *sourceVC = [self queryCurrentVC];
    
    id params = [self _subParams:context];
    if (params != nil && ![params isKindOfClass:[NSDictionary class]]) {
        SROUTER_LOG(@"routerShowRemtoeVC params error");
        return;
    }
    //多个界面动作，只有最后一个界面可以传递和返回参数
    switch ([self _subCmd:context]) {
        case RouterHandlerJumpPushWithParams:
        {
            id<ModuleProtocol> targetLast = nil;
            if ([arrayTargets.lastObject conformsToProtocol:@protocol(ModuleProtocol)]) {
                targetLast = arrayTargets.lastObject;
                if ([targetLast respondsToSelector:@selector(command:andParams:)]) {
                    [targetLast command:RouterModuleParams andParams:params];
                }
            }
            
        }
        case RouterHandlerJumpPush:
        {
            [sourceVC.navigationController setViewControllers:arrayTargets animated:YES];
            for (int i = 0; i < arrayTargets.count - 1; ++i) {
                [sourceVC.navigationController pushViewController:arrayTargets[i] animated:NO];
            }
            [sourceVC.navigationController pushViewController:arrayTargets.lastObject animated:YES];
        }
            break;
        case RouterHandlerJumpPresentWithParams:
        {
            id<ModuleProtocol> targetLast = nil;
            if ([arrayTargets.lastObject conformsToProtocol:@protocol(ModuleProtocol)]) {
                targetLast = arrayTargets.lastObject;
                if ([targetLast respondsToSelector:@selector(command:andParams:)]) {
                    [targetLast command:RouterModuleParams andParams:params];
                }
            }
        }
        case RouterHandlerJumpPresent:
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
}
- (void)routerShowLocalVC:(RouterHandlerContext *)context
{
    
    NSString *targetClassName = context.targetClass;
    id<ModuleProtocol> tmpTarget = [[NSClassFromString(targetClassName) alloc] init];
    if (tmpTarget == nil) {
        return;
    }
    
    
    id target = [self queryVCTarget:tmpTarget withParams:context.dictParam];
    
    //    [self addNewClassInfo:nil];
    if (target == nil || [target class] == [context.caller class]) {
        SROUTER_LOG(@"routerShowRemoteVC target is nill");
        return;
    }
    
    
    UIViewController *sourceVC = [self queryCurrentVC];
    
    id params = [self _subParams:context];
    if (params != nil && ![params isKindOfClass:[NSDictionary class]]) {
        SROUTER_LOG(@"routerShowRemtoeVC params error");
        return;
    }
    
    switch ([self _subCmd:context]) {
        case RouterHandlerJumpPushWithParams:
            [tmpTarget command:RouterModuleParams andParams:params];
        case RouterHandlerJumpPush:
            [sourceVC.navigationController pushViewController:target animated:YES];
            break;
        case RouterHandlerJumpPresentWithParams:
            [tmpTarget command:RouterModuleParams andParams:params];
        case RouterHandlerJumpPresent:
            [sourceVC presentViewController:target animated:YES completion:nil];
            break;
        default:
            break;
    }
}
- (void)routerJumpHandle:(RouterHandlerContext *)context
{
    if (context.from == SRouterCmdFromLocal) {
        [self routerShowLocalVC:context];
    } else {
        [self routerShowRemoteVC:context];
    }
}
- (id)routerOtherHandle:(RouterHandlerContext *)context
{
    NSString *targetClass = context.targetClass;
    //如果是已经注册了的已经实例化的类
    id<ModuleProtocol> target = [self.dataContext shareInstanceForClassName:targetClass];
    if (target == nil) {
        target = [[NSClassFromString(targetClass) alloc] init];
    }
    
    if ([target respondsToSelector:@selector(command:andParams:)]) {
        return [target command:RouterModuleOtherCmd andParams:context.dictParam];
    }
    
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
        case RouterHandlerQueryViewController:
        {
            NSString *targetClass = context.dictParam[keySRouter__Param_Value];
            id<ModuleProtocol> target = [[NSClassFromString(targetClass) alloc] init];
            if ([target respondsToSelector:@selector(command:andParams:)]) {
                return [target command:RouterModuleQueryViewControlelr andParams:nil];
            }
        }
            break;
        case RouterHandlerQueryProtocol:
        {
            Protocol *protocol = context.dictParam[keySRouter__Param_Value];
            return [self.dataContext queryClassImpForProtocol:protocol];
        }
            break;
        case RouterHandlerQueryBlock:
        {
            NSString *className = context.dictParam[keySRouter__Param_Value];
            return [self.dataContext queryBlockWithClassName:className];
        }
            break;
        case RouterHandlerQueryOther:
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
