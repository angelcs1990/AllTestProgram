//
//  SConnect.h
//  SConnectDemo
//
//  Created by cs on 16/11/18.
//  Copyright © 2016年 cs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SConnectMacro.h"

//typedef NS_ENUM(NSUInteger, SConnectionType) {
//    SConnectionTypeQueue,
//    SConnectionTypeDirect,
//    SConnectionTypeAuto
//};
typedef NS_ENUM(NSUInteger, SConnectionType) {
    SConnectionTypeSlot,
    SConnectionTypeSignal
};

@interface SConnect : NSObject

@property (nonatomic) NSInteger signalConnectionCount;

+ (instancetype)shareInstance;

- (void)connect:(id)sender signal:(NSString *)signal receiver:(id)receiver slot:(NSString *)slot;
- (void)connect:(id)sender ssignal:(NSString *)ssignal receiver:(id)receiver rsignal:(NSString *)rsignal;
- (void)disconnect:(id)sender signal:(NSString *)signal receiver:(id)receiver slot:(NSString *)slot;
- (void)disconnect:(id)sender ssignal:(NSString *)ssignal receiver:(id)receiver rsignal:(NSString *)rsignal;
- (void)emit:(id)sender signal:(NSString *)signal, ...;
- (void)emit:(id)sender signal:(NSString *)signal withVaList:(va_list)va;
- (void)emit:(id)sender signal:(NSString *)signal withParams:(NSArray *)params;

@end

void s_emit(id sender, NSString *signal, ...);
void s_connect(id sender, NSString *signal, id receiver, NSString *slot, SConnectionType type);
