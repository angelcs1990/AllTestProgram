//
//  SRouterContext.m
//  TestRouter
//
//  Created by cs on 16/12/5.
//  Copyright © 2016年 chensi. All rights reserved.
//

#import "SRouterCache.h"
#import "SRouterMacro.h"
#import "SRouterConfig.h"

#define LOCK_OPEN

#ifndef SLock
#ifdef LOCK_OPEN
#define SLock(_l) [_l lock]
#else
#define SLock(_l)
#endif
#endif

#ifndef SUnlock
#ifdef LOCK_OPEN
#define SUnlock(_l) [_l unlock]
#else
#define SUnlock(_l)
#endif

#endif

#define S_LAZY_LOCK(_t, _v) \
- (_t *)_##_v \
{ \
if (_##_v == nil) { \
_##_v = [_t new]; \
} \
return _##_v; \
}


@interface SRouterCache()

@property (nonatomic, strong) NSLock *lockPt;
@property (nonatomic, strong) NSLock *lockkCi;
@property (nonatomic, strong) NSLock *lockBt;
@property (nonatomic, strong) NSLock *lockBTA;
@property (nonatomic, strong) NSLock *lockSi;
@property (nonatomic, strong) NSLock *lockSb;
@property (nonatomic, strong) NSLock *lockTs;
@property (nonatomic, strong) NSLock *lockRi;

//Protocol----array(className)
@property (nonatomic, strong) NSMapTable *dictProtocolsAndTarget;
@property (nonatomic, strong) NSMutableDictionary *dictKeyClassAndInfo;
@property (nonatomic, strong) NSMutableDictionary *dictBlocksAndTarget;
@property (nonatomic, strong) NSMapTable *dictBlocksAndTargetAuto;
@property (nonatomic, strong) NSMutableDictionary *dictShareInstance;
@property (nonatomic, strong) NSMutableDictionary *dictSubscriber;
@property (nonatomic, strong) NSMapTable *dictTempService;

@property (nonatomic, strong) NSMutableDictionary *dictRulesInfo;

@end

@implementation SRouterCache

+ (instancetype)routerCache
{
    SRouterCache *context = [SRouterCache new];
    return context;
}

#pragma mark - lifecycle
- (void)dealloc
{
    SLock(self.lockPt);
    [self.dictProtocolsAndTarget removeAllObjects];
    SUnlock(self.lockPt);
    
    SLock(self.lockkCi);
    [self.dictKeyClassAndInfo removeAllObjects];
    SUnlock(self.lockkCi);
    
    SLock(self.lockBt);
    [self.dictBlocksAndTarget removeAllObjects];
    SUnlock(self.lockBt);
    
    SLock(self.lockSi);
    [self.dictShareInstance removeAllObjects];
    SUnlock(self.lockSi);
    
    SLock(self.lockSb);
    [self.dictSubscriber removeAllObjects];
    SUnlock(self.lockSb);
    
}

#pragma mark - 公共方法
- (void)registerSubscriberInstance:(id)sberInst withDestObj:(id)destInst withMsg:(NSInteger)msg
{
    if (sberInst == nil || destInst == nil) {
        return;
    }
    
    NSString *key = NSStringFromClass([destInst class]);
    NSValue *value = [NSValue valueWithNonretainedObject:sberInst];
    
    SLock(self.lockSb);
    
    if ([self.dictSubscriber objectForKey:key] == nil) {
        self.dictSubscriber[key] = [NSMutableDictionary dictionary];
    }
    
    

    if ([self.dictSubscriber[key] objectForKey:@(msg)] == nil) {
        self.dictSubscriber[key][@(msg)] = [NSMutableArray array];
    }
    
    if (![self.dictSubscriber[key][@(msg)] containsObject:value]) {
        [self.dictSubscriber[key][@(msg)] addObject:value];
    }
    
    
    SUnlock(self.lockSb);
}

- (void)unregisterSubscriberInstance:(id)sberInst withDestObj:(id)destInst withMsg:(NSInteger)msg
{
    if (sberInst == nil || destInst == nil) {
        return;
    }
    
    NSString *key = NSStringFromClass([destInst class]);
    NSValue *value = [NSValue valueWithNonretainedObject:sberInst];
    SLock(self.lockSb);
    
    if ([self.dictSubscriber objectForKey:key] != nil) {
        if ([self.dictSubscriber[key] objectForKey:@(msg)] != nil) {
            [self.dictSubscriber[key][@(msg)] removeObject:value];
            

            if ([self.dictSubscriber[key][@(msg)] count]== 0) {
                [self.dictSubscriber[key] removeObjectForKey:@(msg)];
            }
            
            if ([self.dictSubscriber[key] count] == 0) {
                [self.dictSubscriber removeObjectForKey:key];
            }
            
        } else {
            [self.dictSubscriber[key] removeAllObjects];
        }
    } else {
        [self.dictSubscriber removeAllObjects];
    }
    
    SUnlock(self.lockSb);
}

- (NSArray *)subscriberObjects:(id)destInst withMsg:(NSInteger)msg
{
    if (destInst == nil) {
        return nil;
    }
    
    NSArray *retArray = nil;
    NSString *key = NSStringFromClass([destInst class]);
    SLock(self.lockSb);
    
    if ([self.dictSubscriber objectForKey:key] != nil) {
        if ([self.dictSubscriber[key] objectForKey:@(msg)] != nil
            ) {
            retArray = self.dictSubscriber[key][@(msg)];
        }
    }
    
    SUnlock(self.lockSb);
    
    return retArray;
}

- (void)registerShortName:(NSString *)name withFullClassName:(NSString *)fullClassName
{
    if (name && fullClassName) {
        SLock(self.lockkCi);
        [self.dictKeyClassAndInfo setObject:name forKey:fullClassName];
        SUnlock(self.lockkCi);
    }
}



- (void)registerShortNameForDict:(NSDictionary *)dict
{
    if (dict) {
        SLock(self.lockkCi);
        [self.dictKeyClassAndInfo addEntriesFromDictionary:dict];
        SUnlock(self.lockkCi);
    }
}

- (void)unregisterShortName:(NSString *)name
{
    if (name) {
        SLock(self.lockkCi);
        [self.dictKeyClassAndInfo removeObjectForKey:name];
        SUnlock(self.lockkCi);
    }
}

- (NSString *)queryClassName:(NSString *)keyClassName
{
    SLock(self.lockkCi);
    NSString *fullClassName = self.dictKeyClassAndInfo[keyClassName];
    SUnlock(self.lockkCi);
    
    __block NSString *className = fullClassName;
    if (fullClassName == nil) {
        SLock(self.lockkCi);
        [self.dictKeyClassAndInfo enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop){
            if ([value isEqualToString:keyClassName]) {
                className = value;
                *stop = YES;
            }
        }];
        SUnlock(self.lockkCi);
    }
    
    return className;
}

- (id)queryClassImpForProtocol:(Protocol *)keyProtocol
{
    //查找classname
    NSString *protocol = NSStringFromProtocol(keyProtocol);
    
    SLock(self.lockPt);
    id insValue = [self.dictProtocolsAndTarget objectForKey:protocol];
    SUnlock(self.lockPt);
    
    return insValue;
    
}

- (BOOL)registerBlock:(SRouterHandler)block withInstance:(id)instance
{
    if (block == nil || instance == nil) {
        return NO;
    }
    
    SLock(self.lockBTA);
    [self.dictBlocksAndTargetAuto setObject:[block copy] forKey:instance];
    SUnlock(self.lockBTA);
    
    return YES;
}

- (BOOL)registerBlock:(SRouterHandler)block keyName:(NSString *)className
{
    if (block == nil || className == nil) {
        return NO;
    }
    
    SLock(self.lockBt);
    self.dictBlocksAndTarget[className] = [block copy];
    SUnlock(self.lockBt);
    
    return YES;
}

- (void)unregisterBlockWithInstance:(id)instance
{
    if (instance != nil) {
        SLock(self.lockBTA);
        [self.dictBlocksAndTargetAuto removeObjectForKey:instance];
        SUnlock(self.lockBTA);
    }
}

- (void)unregisterBlockWithKeyname:(NSString *)className
{
    if (className == nil) {
        return;
    }
    SLock(self.lockBt);
    [self.dictBlocksAndTarget removeObjectForKey:className];
    SUnlock(self.lockBt);
}

- (SRouterHandler)queryBlockWithKeyName:(NSString *)className
{
    SLock(self.lockBt);
    SRouterHandler blockHandler = self.dictBlocksAndTarget[className];
    SUnlock(self.lockBt);
    
    return blockHandler;
}

- (SRouterHandler)queryBlockWithInstance:(id)instance
{
    SLock(self.lockBTA);
    SRouterHandler blockHandler = [self.dictBlocksAndTargetAuto objectForKey:instance];
    SUnlock(self.lockBTA);
    
    return blockHandler;
}

- (BOOL)registerProtocol:(Protocol *)keyProtocol classInstance:(id)classIns
{
    if (keyProtocol == nil || classIns == nil) {
        return NO;
    }
    NSString *protocol = NSStringFromProtocol(keyProtocol);
    
    //检查是否符合协议
    if ([classIns conformsToProtocol:keyProtocol]) {
        SLock(self.lockPt);
        [self.dictProtocolsAndTarget setObject:classIns forKey:protocol];
        SUnlock(self.lockPt);
        
        return YES;
    }
    
    
    return NO;
    
}

- (void)unregisterProtocol:(Protocol *)keyProtocol classInstance:(id)classIns
{
    NSString *protocol = NSStringFromProtocol(keyProtocol);
    
    SLock(self.lockPt);
    [self.dictProtocolsAndTarget removeObjectForKey:protocol];
    SUnlock(self.lockPt);
}

- (id)registerService:(NSString *)className
{
    if (className == nil || [className isEqualToString:@""]) {
        return nil;
    }
    //如果不存在该类
    if (NSClassFromString(className) == nil) {
        return nil;
    }
    
    id imp = nil;
    SLock(self.lockSi);
    
    if ([self.dictShareInstance objectForKey:className] == nil) {
        imp = [[NSClassFromString(className) alloc] init];
        [self.dictShareInstance setObject:imp forKey:className];
    }
    
    SUnlock(self.lockSi);
    return imp;
}

- (void)unregisterService:(NSString *)className
{
    if (className == nil) {
        return;
    }
    SLock(self.lockSi);
    [self.dictShareInstance removeObjectForKey:className];
    SUnlock(self.lockSi);
}

- (id)serviceForClassName:(NSString *)className
{
    SLock(self.lockSi);
    id ret = [self.dictShareInstance objectForKey:className];
    SUnlock(self.lockSi);
    return ret;
}


- (void)addRules:(NSArray<RouterRulesContext *> *)rules
{
    SLock(self.lockRi);
    [rules enumerateObjectsUsingBlock:^(RouterRulesContext * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.oriName != nil) {
            if ([self.dictRulesInfo objectForKey:obj.oriName] != nil) {
                NSString *info = [NSString stringWithFormat:@"重复添加:%@", obj.oriName];
                SRouterErrLog(info);
            }
            [self.dictRulesInfo setObject:obj forKey:obj.oriName];
        } else {
            SRouterErrLog(@"类名为空");
        }
        
    }];
    SUnlock(self.lockRi);
}

- (void)removeRule:(NSString *)key
{
    SLock(self.lockRi);
    [self.dictRulesInfo removeObjectForKey:key];
    SUnlock(self.lockRi);
}

- (void)clearRules
{
    SLock(self.lockRi);
    [self.dictRulesInfo removeAllObjects];
    SUnlock(self.lockRi);
}

- (RouterRulesContext *)queryRuleForName:(NSString *)name
{
    RouterRulesContext *ctx = nil;
    
    SLock(self.lockRi);
    ctx = [self.dictRulesInfo objectForKey:name];
    SUnlock(self.lockRi);
    
    return ctx;
}

#pragma mark - setter and getter
- (NSMutableDictionary *)dictRulesInfo
{
    if (_dictRulesInfo == nil) {
        _dictRulesInfo = [NSMutableDictionary dictionary];
    }
    
    return _dictRulesInfo;
}

- (NSMutableDictionary *)dictSubscriber
{
    if (_dictSubscriber == nil) {
        _dictSubscriber = [NSMutableDictionary dictionary];
    }
    
    return _dictSubscriber;
}

- (NSMutableDictionary *)dictShareInstance
{
    if (_dictShareInstance == nil) {
        _dictShareInstance = [NSMutableDictionary dictionary];
    }
    
    return _dictShareInstance;
}

- (NSMapTable *)dictProtocolsAndTarget
{
    if (_dictProtocolsAndTarget == nil) {
        _dictProtocolsAndTarget = [NSMapTable strongToWeakObjectsMapTable];
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

- (NSMapTable *)dictBlocksAndTargetAuto
{
    if (_dictBlocksAndTargetAuto == nil) {
        _dictBlocksAndTargetAuto = [NSMapTable weakToStrongObjectsMapTable];
    }
    
    return _dictBlocksAndTargetAuto;
}

- (NSMutableDictionary *)dictBlocksAndTarget
{
    if (_dictBlocksAndTarget == nil) {
        _dictBlocksAndTarget = [NSMutableDictionary dictionary];
    }
    
    return _dictBlocksAndTarget;
}

- (NSMapTable *)dictTempService
{
    if (_dictTempService == nil) {
        _dictTempService = [NSMapTable weakToStrongObjectsMapTable];
    }
    
    return _dictTempService;
}

S_LAZY_LOCK(NSLock, lockPt)
S_LAZY_LOCK(NSLock, lockkCi)
S_LAZY_LOCK(NSLock, lockBt)
S_LAZY_LOCK(NSLock, lockBTA)
S_LAZY_LOCK(NSLock, lockSi)
S_LAZY_LOCK(NSLock, lockSb);
S_LAZY_LOCK(NSLock, lockTs);
S_LAZY_LOCK(NSLock, lockRi);

@end
