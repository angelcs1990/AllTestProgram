//
//  SConnectMacro.h
//  SConnectDemo
//
//  Created by cs on 16/11/22.
//  Copyright © 2016年 cs. All rights reserved.
//

#ifndef SConnectMacro_h
#define SConnectMacro_h

//#include "SConnectMacro_Inner.h"


#define S_SIGNAL(_a) _S_SIGNAL(_sender, _a)
#define S_SLOT(_a) _S_SLOT(_receiver, _a)
#define S_SIGNALS(_signal) - (void)_signal UNAVAILABLE_ATTRIBUTE


#define SNil @"s_nil"

//#define emit(signal_, ...) [[SConnect shareInstance] emit:self signal:NSStringFromSelector(@selector(signal_)), ##__VA_ARGS__]
//#define emit(signal_, ...) [[SConnect shareInstance] emit:self signal:NSStringFromSelector(@selector(signal_)) withParams:@[__VA_ARGS__]]

//#define emitEx(sender_, signal_, ...) [[SConnect shareInstance] emit:sender_ signal:NSStringFromSelector(@selector(signal_)) withParams:@[__VA_ARGS__]]
//#define connect(_sender, _signal, _receiver, _slot) [[SConnect shareInstance] connect:_sender signal:_S_SIGNAL(_sender, _signal) receiver:_receiver slot:_S_SLOT(_receiver, _slot)]
//
//#define connectEx(_sender, _ssignal, _receiver, _rsignal) [[SConnect shareInstance] connect:_sender ssignal:_S_SIGNAL(_sender, _ssignal) receiver:_receiver rsignal:_S_SIGNAL(_receiver, _rsignal)]

//#define _S_SLOT(_instance, _slot) NSStringFromSelector(@selector(_slot))
//#define _S_SIGNAL(_instance, _sig) NSStringFromSelector(@selector(_sig))


#define emit(signal_, ...) s_emit(self, [NSString stringWithFormat:@"s_sig_#%@", NSStringFromSelector(@selector(signal_))], @[__VA_ARGS__])
#define emitEx(sender_, signal_, ...) s_emit(sender_, NSStringFromSelector(@selector(signal_)), @[__VA_ARGS__])
#define connect(_sender, _signal, _receiver, _slotOrSignal) s_connect(_sender, _signal, _receiver,  _slotOrSignal, SConnectionTypeUndefined)



#define S_UNUSED(x) (void)x;

#define _S_SLOT(_instance, _slot) [NSString stringWithFormat:@"s_slot_#%@", NSStringFromSelector(@selector(_slot))]
#define _S_SIGNAL(_instance, _sig) [NSString stringWithFormat:@"s_sig_#%@", NSStringFromSelector(@selector(_sig))]

#endif /* SConnectMacro_h */
