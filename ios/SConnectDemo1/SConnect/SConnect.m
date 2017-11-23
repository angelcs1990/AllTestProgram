//
//  SConnect.m
//  SConnectDemo
//
//  Created by cs on 16/11/18.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "SConnect.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "NSString+QtExtension.h"
#import <UIKit/UIKit.h>
#import <pthread.h>
#import "SClassMethodInfo.h"

//void emit(id sender, NSString *signal, ...)
//{}
void s_emit(id sender, NSString *signal, ...)
{
    va_list params;
    va_start(params, signal);
    
    [[SConnect shareInstance] emit:sender signal:signal withVaList:params];
    
    va_end(params);
}

void s_connect(id sender, NSString *signal, id receiver, NSString *slot, SConnectionType type)
{
    if (type == SConnectionTypeSlot) {
        [[SConnect shareInstance] connect:sender signal:signal receiver:receiver slot:slot];
    } else {
        [[SConnect shareInstance] connect:sender ssignal:signal receiver:receiver rsignal:slot];
    }
    
}



@interface _priConnectionSlots : NSObject
{
    @public
    __weak id _sender;
    __weak id _receiver;
    NSString *_signalMethod;
//    SConnectionType _connectionType;
    __strong SClassMethodInfo *_slotMethodInfo;
}
@end

@implementation _priConnectionSlots

- (instancetype)init
{
    self = [super init];
    if (self) {
//        _connectionType = SConnectionTypeAuto;
    }
    
    return self;
}

@end


@interface _priConnectionSignals : NSObject
{
    @public
    __weak id _sender;
    __weak id _receiver;
    NSString *_signalSource;
    NSString *_signalDest;
}
@end

@implementation _priConnectionSignals

@end






@interface SConnect ()

@property (nonatomic, strong) NSMapTable *dictCacheSender_Signals_Slots;
@property (nonatomic, strong) NSMapTable *dictCacheSender_Signals_Signals;

@end

@implementation SConnect
{
    pthread_mutex_t _lock;
}

+ (instancetype)shareInstance
{
    static SConnect *ct;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ct = [[self class] new];
    });
    
    return ct;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        pthread_mutex_init(&_lock, NULL);
    }
    
    return self;
}

- (void)dealloc
{
    pthread_mutex_destroy(&_lock);
}

- (void)emit:(id)sender signal:(NSString *)signal withParams:(NSArray *)params
{
    
}

- (void)emit:(id)sender signal:(NSString *)signal withVaList:(va_list)va
{
    pthread_mutex_lock(&_lock);
    
    [self disposeSlots:sender signal:signal params:va];
    [self disposeSignals:sender signal:signal params:va];
    
    pthread_mutex_unlock(&_lock);
}

- (void)emit:(id)sender signal:(NSString *)signal, ...
{
    va_list params;
    va_start(params, signal);
    
    pthread_mutex_lock(&_lock);
    
    [self disposeSlots:sender signal:signal params:params];
    [self disposeSignals:sender signal:signal params:params];
    
    pthread_mutex_unlock(&_lock);
    
    va_end(params);
}

- (void)disconnect:(id)sender ssignal:(NSString *)ssignal receiver:(id)receiver rsignal:(NSString *)rsignal
{
    if (sender == nil || ssignal == nil || receiver == nil || rsignal == nil) {
        NSString *warningShow = [NSString stringWithFormat:@"connect: Cannot connect %@::%@ to %@::%@, Not match", sender ? NSStringFromClass([sender class]) : @"(null)", ssignal ? :@"(null)", receiver ? NSStringFromClass([receiver class]) : @"(null)", rsignal ? : @"(null)"];
        NSAssert(0, warningShow);
        return;
    }
    
    pthread_mutex_lock(&_lock);
    //删除所有的
    if (ssignal == nil) {
        [self.dictCacheSender_Signals_Signals removeObjectForKey:sender];
    } else {
        NSDictionary *dictCache = [self.dictCacheSender_Signals_Signals objectForKey:sender];
        if (dictCache != nil) {
            
            NSArray *arraySlots = dictCache[ssignal];
            if (receiver == nil && rsignal == nil) {
                [[self.dictCacheSender_Signals_Signals objectForKey:sender] removeObjectForKey:ssignal];
            } else if (rsignal == nil) {
                [arraySlots enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    _priConnectionSignals *c = (_priConnectionSignals *)obj;
                    if (c->_receiver == receiver) {
                        [[self.dictCacheSender_Signals_Signals objectForKey:sender][ssignal] removeObject:c];
                    }
                }];
            } else {
                [arraySlots enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    _priConnectionSignals *c = (_priConnectionSignals *)obj;
                    if (c->_receiver == receiver && [c->_signalDest isEqualToString:rsignal]) {
                        [[self.dictCacheSender_Signals_Signals objectForKey:sender][ssignal] removeObject:c];
                        *stop = YES;
                    }
                }];
            }
        }
    }
    pthread_mutex_unlock(&_lock);
}

- (void)disconnect:(id)sender signal:(NSString *)signal receiver:(id)receiver slot:(NSString *)slot
{
    if (sender == nil) {
        NSString *warningShow = [NSString stringWithFormat:@"connect: Cannot connect %@::%@ to %@::%@, Not match", sender ? NSStringFromClass([sender class]) : @"(null)", signal ? :@"(null)", receiver ? NSStringFromClass([receiver class]) : @"(null)", slot ? : @"(null)"];
        NSAssert(0, warningShow);
        return;
    }
    
    pthread_mutex_lock(&_lock);
    //删除所有的
    if (signal == nil) {
        [self.dictCacheSender_Signals_Slots removeObjectForKey:sender];
    } else {
        NSDictionary *dictCache = [self.dictCacheSender_Signals_Slots objectForKey:sender];
        if (dictCache != nil) {
            
            NSArray *arraySlots = dictCache[signal];
            if (receiver == nil && slot == nil) {
                [[self.dictCacheSender_Signals_Slots objectForKey:sender] removeObjectForKey:signal];
            } else if (slot == nil) {
                [arraySlots enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    _priConnectionSlots *c = (_priConnectionSlots *)obj;
                    if (c->_receiver == receiver) {
                        [[self.dictCacheSender_Signals_Slots objectForKey:sender][signal] removeObject:c];
                    }
                }];
            } else {
                [arraySlots enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    _priConnectionSlots *c = (_priConnectionSlots *)obj;
                    if (c->_receiver == receiver && [c->_slotMethodInfo.name isEqualToString:slot]) {
                        [[self.dictCacheSender_Signals_Slots objectForKey:sender][signal] removeObject:c];
                        *stop = YES;
                    }
                }];
            }
        }
    }
    pthread_mutex_unlock(&_lock);
    
}



- (void)connect:(id)sender ssignal:(NSString *)ssignal receiver:(id)receiver rsignal:(NSString *)rsignal
{
    if (sender == nil || ssignal == nil || receiver == nil || rsignal == nil) {
        NSString *warningShow = [NSString stringWithFormat:@"connect: Cannot connect %@::%@ to %@::%@, Not match", sender ? NSStringFromClass([sender class]) : @"(null)", ssignal ? :@"(null)", receiver ? NSStringFromClass([receiver class]) : @"(null)", rsignal ? : @"(null)"];
        NSAssert(0, warningShow);
        return;
    }
    
    if([self checkSafe:sender signal:ssignal receiver:receiver slot:rsignal] == NO)
    {
        NSString *warningShow = [NSString stringWithFormat:@"connect: %@::%@(signal) not match %@::%@(signal)", NSStringFromClass([sender class]), ssignal, NSStringFromClass([receiver class]), rsignal];
        NSAssert(0, warningShow);
        return;
    }
  
    _priConnectionSignals *c = [_priConnectionSignals new];
    c->_sender = sender;
    c->_receiver = receiver;
    c->_signalSource = ssignal;
    c->_signalDest = rsignal;
    
    [self addToCache:self.dictCacheSender_Signals_Signals sender:sender signal:ssignal withObject:c];
    
}

- (void)connect:(id)sender signal:(NSString *)signal receiver:(id)receiver slot:(NSString *)slot
{
    if (sender == nil || signal == nil || receiver == nil || slot == nil) {
        NSString *warningShow = [NSString stringWithFormat:@"connect: Cannot connect %@::%@ to %@::%@, Not match", sender ? NSStringFromClass([sender class]) : @"(null)", signal ? :@"(null)", receiver ? NSStringFromClass([receiver class]) : @"(null)", slot ? : @"(null)"];
        NSAssert(0, warningShow);
        return;
    }
    
    if([self checkSafe:sender signal:signal receiver:receiver slot:slot] == NO)
    {
        NSString *warningShow = [NSString stringWithFormat:@"connect: %@::%@(signal) not match %@::%@(slot)", NSStringFromClass([sender class]), signal, NSStringFromClass([receiver class]), slot];
        NSAssert(0, warningShow);
        return;
    }
    if([self checkMethod:sender signal:signal receiver:receiver slot:slot] == NO)
    {
        NSString *warningShow = [NSString stringWithFormat:@"connect: %@ not find %@(slot)", NSStringFromClass([receiver class]), slot];
        NSAssert(0, warningShow);
        return;
    }
    
    
    
    Method method = class_getInstanceMethod([receiver class], NSSelectorFromString(slot));
    _priConnectionSlots *c = [_priConnectionSlots new];
    c->_sender = sender;
    c->_signalMethod = signal;
    c->_receiver = receiver;
    c->_slotMethodInfo = [[SClassMethodInfo alloc] initWithMethod:method];
    

    [self addToCache:self.dictCacheSender_Signals_Slots sender:sender signal:signal withObject:c];

}

#pragma mark - private method
- (void)disposeSlots:(id)sender signal:(NSString *)signal params:(va_list)v
{
#define OC_METHOD
    
    NSDictionary *dictCache = [self.dictCacheSender_Signals_Slots objectForKey:sender];
    if (dictCache == nil) {
        return;
    }
    
    NSArray *arraySlots = [dictCache objectForKey:signal];
    if (arraySlots == nil || arraySlots.count == 0) {
        return;
    }
    
    _priConnectionSlots *c = (_priConnectionSlots *)arraySlots[0];
    //    [c->_slotMethodInfo showType];
    NSArray *params;
    @try {
        params = [SClassMethodInfo BoxValues:c->_slotMethodInfo withVaList:v];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    
#ifndef OC_METHOD
    NSUInteger option = 0;
    if (params == nil || params.count == 0) {
        option = 0;
    } else {
        option = params.count;
    }
#endif
    
    
//    pthread_main_np
    
    [arraySlots enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        _priConnectionSlots *c = (_priConnectionSlots *)obj;
#ifdef OC_METHOD
        NSMethodSignature *signature = [c->_receiver methodSignatureForSelector:c->_slotMethodInfo.sel];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        invocation.target = c->_receiver;
        invocation.selector = c->_slotMethodInfo.sel;
        
        [self packParams:params targetInvocation:invocation];
        [invocation invoke];
#else
        if (c) {
            SBegin(option)
            SCase0(0, c);
            SCase(1, params, c);
            SCase(2, params, c);
            SCase(3, params, c);
            SCase(4, params, c);
            SCase(5, params, c);
            SCase(6, params, c);
            SCase(7, params, c);
            SCase(8, params, c);
            SCase(9, params, c);
            SCase(10, params, c);
            SCase(11, params, c);
            SCase(12, params, c);
            SCase(13, params, c);
            SCase(14, params, c);
            SCase(15, params, c);
            SCase(16, params, c);
            SCase(17, params, c);
            SCase(18, params, c);
            SCase(19, params, c);
            SEnd
        }
#endif
    }];
}

- (void)disposeSignals:(id)sender signal:(NSString *)signal params:(va_list)params
{
    //处理信号
    NSDictionary *dictCacheSignals = [self.dictCacheSender_Signals_Signals objectForKey:sender];
    if (dictCacheSignals == nil) {
        return;
    }
    
    NSArray *arraySignals = [dictCacheSignals objectForKey:signal];
    if (arraySignals == nil || arraySignals.count == 0) {
        return;
    }
    
    
    for (int i = 0; i < arraySignals.count; ++i) {
        _priConnectionSignals *c = (_priConnectionSignals *)arraySignals[i];
        [self disposeSlots:c->_receiver signal:c->_signalDest params:params];
    }
    
}

- (void)packParams:(NSArray *)params targetInvocation:(NSInvocation *)invocation
{
    for (int i = 0; i < params.count; ++i) {
        objTypeValues *ov = params[i];
        switch (ov->_type) {
            case SValueTypeClass:
            case SValueTypeObject:
                [invocation setArgument:&(ov->_obj) atIndex:i + 2];
                break;
            case SValueTypeInt32:
            {
                int tmpValue = [ov->_obj intValue];
                [invocation setArgument:&tmpValue atIndex:i + 2];
            }
                break;
                /*void*/
            case SValueTypeVoid:
            {
                int tmpValue = [ov->_obj intValue];
                [invocation setArgument:&tmpValue atIndex:i + 2];
            }
                break;
                /*bool*/
            case SValueTypeBool:
            {
                bool tmpValue = (bool)[ov->_obj intValue];
                [invocation setArgument:&tmpValue atIndex:i + 2];
            }
                break;
                /*char / BOOL*/
            case SValueTypeInt8:
            {
                BOOL tmpValue = [ov->_obj boolValue];
                [invocation setArgument:&tmpValue atIndex:i + 2];
            }
                break;
                /*unsigned char*/
            case SValueTypeUInt8:
            {
                unsigned char tmpValue = [ov->_obj unsignedCharValue];
                [invocation setArgument:&tmpValue atIndex:i + 2];
            }
                break;
                /*short*/
            case SValueTypeInt16:
            {
                short tmpValue = [ov->_obj shortValue];
                [invocation setArgument:&tmpValue atIndex:i + 2];
            }
                break;
                /*unsigned short*/
            case SValueTypeUInt16:
            {
                unsigned short tmpValue = [ov->_obj unsignedShortValue];
                [invocation setArgument:&tmpValue atIndex:i + 2];
            }
                break;
                /*unsigned int*/
            case SValueTypeUInt32:
            {
                unsigned int tmpValue = [ov->_obj unsignedIntValue];
                [invocation setArgument:&tmpValue atIndex:i + 2];
            }
                break;
                /*long long*/
            case SValueTypeInt64:
            {
                long long tmpValue = [ov->_obj longLongValue];
                [invocation setArgument:&tmpValue atIndex:i + 2];
            }
                break;
                /*unsigned long long*/
            case SValueTypeUInt64:
            {
                unsigned long long tmpValue = [ov->_obj unsignedLongLongValue];
                [invocation setArgument:&tmpValue atIndex:i + 2];
            }
                break;
                /*float*/
            case SValueTypeFloat:
            {
                float tmpValue = [ov->_obj floatValue];
                [invocation setArgument:&tmpValue atIndex:i + 2];
            }
                break;
                /*double*/
            case SValueTypeDouble:
            {
                double tmpValue = [ov->_obj doubleValue];
                [invocation setArgument:&tmpValue atIndex:i + 2];
            }
                break;
                /*long double*/
            case SValueTypeLongDouble:
            {
                double tmpValue = [ov->_obj doubleValue];
                [invocation setArgument:&tmpValue atIndex:i + 2];
            }
                break;
                //                    /*Class*/
                //                case SValueTypeClass:
                //                {
                //
                //                }
                //                    break;
                /*SEL*/
            case SValueTypeSEL:
            {
                [invocation setArgument:&(ov->_obj) atIndex:i + 2];
            }
                break;
                /*block*/
            case SValueTypeBlock:
            {
                [invocation setArgument:&(ov->_obj) atIndex:i + 2];
            }
                break;
                /*void* */
            case SValueTypePointer:
            {
                [invocation setArgument:&(ov->_obj) atIndex:i + 2];
            }
                break;
                /*struct*/
            case SValueTypeStruct:
            {
                [invocation setArgument:&(ov->_obj) atIndex:i + 2];
            }
                break;
                /*union*/
            case SValueTypeUnion:
            {
                [invocation setArgument:&(ov->_obj) atIndex:i + 2];
            }
                break;
                /*char**/
            case SValueTypeCString:
            {
                
            }
                break;
                /*char[10] (for example)*/
            case SValueTypeCArray:
            {
                
            }
                break;
                /**CGPoint*/
            case SValueTypeCGPoint:
            {
                CGPoint tmpValue = [ov->_obj CGPointValue];
                [invocation setArgument:&tmpValue atIndex:i + 2];
            }
                break;
                /*CGSize*/
            case SValueTypeCGSize:
            {
                CGSize tmpValue = [ov->_obj CGSizeValue];
                [invocation setArgument:&tmpValue atIndex:i + 2];
            }
                break;
                /*UIEdgeInsets*/
            case SValueTypeUIEdgeInsets:
            {
                UIEdgeInsets tmpValue = [ov->_obj UIEdgeInsetsValue];
                [invocation setArgument:&tmpValue atIndex:i + 2];
            }
                break;
                /*long*/
            case SValueTypeLong:
            {
                long tmpValue = [ov->_obj longValue];
                [invocation setArgument:&tmpValue atIndex:i + 2];
            }
                break;
                /*usigned long*/
            case SValueTypeULong:
            {
                unsigned long tmpValue = [ov->_obj unsignedLongValue];
                [invocation setArgument:&tmpValue atIndex:i + 2];
            }
                break;
                
            default:
                break;
        }
        
    }
}

- (BOOL)checkMethod:(id)sender signal:(NSString *)signal receiver:(id)receiver slot:(NSString *)slot
{
    Method slotMethod = class_getInstanceMethod([receiver class], NSSelectorFromString(slot));
    if (slotMethod == nil) {
        return NO;
    }
    
    return YES;
}

- (BOOL)checkSafe:(id)sender signal:(NSString *)signal receiver:(id)receiver slot:(NSString *)slot
{
    if (signal == nil || slot == nil) {
        return NO;
    }
    //    如果不是我们定义的信号就返回
    //    if (NO == [signal hasPrefix:@"sig"]) {
    //        return NO;
    //    }
    
    
    
    //    判断此实例类是否包含该函数
    //    Method sigMethod = class_getInstanceMethod([sender class], NSSelectorFromString(signal));
    
    
    if ([signal contains:@":"] == NSNotFound && [slot contains:@":"] == NSNotFound) {
        return YES;
    } else {
        NSArray *arraySignalsSplit = [signal split:@":"];
        NSArray *arraySlotsSplit = [slot split:@":"];
        
        if (arraySlotsSplit.count != arraySignalsSplit.count) {
            return NO;
        }
        
        __block BOOL noDiff = YES;
        [arraySignalsSplit enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx != 0) {
                if ([obj isEqualToString:arraySlotsSplit[idx]] == NO) {
                    noDiff = NO;
                    *stop = NO;
                }
            }
        }];
        
        return noDiff;
    }
    
}

- (void)addToCache:(NSMapTable *)cache sender:(id)sender signal:(NSString *)signal withObject:(id)obj
{
    pthread_mutex_lock(&_lock);

    NSDictionary *dictCache = [cache objectForKey:sender];
    if (dictCache == nil) {
        [cache setObject:@{}.mutableCopy forKey:sender];
    }
    
    if ([dictCache objectForKey:signal] == nil) {
        [cache objectForKey:sender][signal] = @[].mutableCopy;
    }
    
    [[cache objectForKey:sender][signal] addObject:obj];
    
    pthread_mutex_unlock(&_lock);
}

#pragma mark - setter and getter
- (NSMapTable *)dictCacheSender_Signals_Slots
{
    if (_dictCacheSender_Signals_Slots == nil) {
        _dictCacheSender_Signals_Slots = [NSMapTable weakToStrongObjectsMapTable];
    }
    
    return _dictCacheSender_Signals_Slots;
}

- (NSMapTable *)dictCacheSender_Signals_Signals
{
    if (_dictCacheSender_Signals_Signals == nil) {
        _dictCacheSender_Signals_Signals = [NSMapTable weakToStrongObjectsMapTable];
    }
    
    return _dictCacheSender_Signals_Signals;
}

@end
