//
//  SConnectMacro.h
//  SConnectDemo
//
//  Created by cs on 16/11/22.
//  Copyright © 2016年 cs. All rights reserved.
//

#ifndef SConnectMacro_h
#define SConnectMacro_h

#include "SConnectMacro_Inner.h"


#define S_SIGNAL(_a) _a
#define S_SLOT(_a) _a
#define S_SIGNALS(_signal) - (void)_signal UNAVAILABLE_ATTRIBUTE

#define SNil nil#s

//#define emit(signal_, ...) [[SConnect shareInstance] emit:self signal:NSStringFromSelector(@selector(signal_)), ##__VA_ARGS__]
#define emit(signal_, ...) [[SConnect shareInstance] emit:self signal:NSStringFromSelector(@selector(signal_)) withParams:@[__VA_ARGS__]]

#define connect(_sender, _signal, _receiver, _slot) [[SConnect shareInstance] connect:_sender signal:_S_SIGNAL(_sender, _signal) receiver:_receiver slot:_S_SLOT(_receiver, _slot)]

#define connectEx(_sender, _ssignal, _receiver, _rsignal) [[SConnect shareInstance] connect:_sender ssignal:_S_SIGNAL(_sender, _ssignal) receiver:_receiver rsignal:_S_SIGNAL(_receiver, _rsignal)]

#define S_UNUSED(x) (void)x;

#endif /* SConnectMacro_h */
