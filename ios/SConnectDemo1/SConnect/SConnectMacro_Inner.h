//
//  SConnectMacro_Inner.h
//  SConnectDemo
//
//  Created by cs on 16/11/22.
//  Copyright © 2016年 cs. All rights reserved.
//

#ifndef SConnectMacro_Inner_h
#define SConnectMacro_Inner_h

#define SBegin(_option) switch(_option){
#define SEnd }
#define SCase0(_option, c) case _option:callFunc_##_option(objc_msgSend, c->_receiver, c->_slotMethod); break
#define SCase(_option, _array, c) case _option:callFunc_##_option(objc_msgSend, c->_receiver, c->_slotMethod, _array); break


//#define _S_SIGNAL(_instance, _sig) ([_instance respondsToSelector:@selector(_sig)], @#_sig)
//#define _S_SLOT(_instance, _slot) ([_instance respondsToSelector:@selector(_slot)], @#_slot)
#define _S_SLOT(_instance, _slot) NSStringFromSelector(@selector(_slot))
#define _S_SIGNAL(_instance, _sig) NSStringFromSelector(@selector(_sig))
#define _emit_(sender, signal_, ...) [[SConnect shareInstance] emit_:self signal:NSStringFromSelector(@selector(signal_)), __VA_ARGS__, nil]





#define metamacro_stringify_(VALUE) # VALUE
#define metamacro_concat_(A, B) A ## B
#define metamacro_foreach_iter(INDEX, MACRO, ARG) MACRO(INDEX, ARG)
#define metamacro_head_(FIRST, ...) FIRST
#define metamacro_tail_(FIRST, ...) __VA_ARGS__
#define metamacro_consume_(...)
#define metamacro_expand_(...) __VA_ARGS__
#define metamacro_head(...) \
        metamacro_head_(__VA_ARGS__, 0)



#define SObjc_msgSend(sender, selector, ...) \
        SObjc_msgSend_(sender, selector, __VA_ARGS__)
#define SObjc_msgSend_Simple(sender, selector) \
        metamacro_foreach2_cxt0(objc_msgSend, sender, selector)
//        SObjc_msgSend_(sender, selector, __VA_ARGS__)
#define STuplePack(...) STuplePack_(__VA_ARGS__)
#define STupleUnpack(...) STupleUnpack_(__VA_ARGS__) \
        metamacro_foreach(STupleUnpack_decl,,__VA_ARGS__) \
        int STupleUnpack_state = 0; \
        STupleUnpack_after: \
        ;\
        metamacro_foreach(STupleUnpack_assign,,__VA_ARGS__) \
        if(STupleUnpack_state != 0) STupleUnpack_state = 2; \
        while(STupleUnpack_state != 2)\
            if(STupleUnpack_state == 1){\
                goto STupleUnpack_after; \
            } else { \
                for(; STupleUnpack_state != 1; STupleUnpack_state = 1) \
                    [RACTupleUnpackingTrampoline trampoline][ @[ metamacro_foreach(RACTupleUnpack_value,, __VA_ARGS__) ] ] \
            }
#define STupleUnpack_state metamacro_concat(RACTupleUnpack_state, __LINE__)
#define STupleUnpack_after metamacro_concat(RACTupleUnpack_after, __LINE__)
#define STupleUnpack_loop metamacro_concat(RACTupleUnpack_loop, __LINE__)

#define STupleUnpack_decl_name(INDEX) \
        metamacro_concat(metamacro_concat(STupleUnpack, __LINE__), metamacro_concat(_var, INDEX))

#define STupleUnpack_decl(INDEX, ARG) \
        __strong id STupleUnpack_decl_name(INDEX);

#define STupleUnpack_assign(INDEX, ARG) \
        __strong ARG = STupleUnpack_decl_name(INDEX);

#define STupleUnpack_value(INDEX, ARG) \
        [NSValue valueWithPointer:&STupleUnpack_decl_name(INDEX)],

#define STuplePack_(...) metamacro_foreach(STuplePack_Object_orSTupleNil,, __VA_ARGS__)
#define SObjc_msgSend_(sender, selector, ...) metamacro_foreach2(objc_msgSend, sender, selector, __VA_ARGS__)
#define STuplePack_Object_orSTupleNil(INDEX, ARG) \
        (ARG) ? : @"",
#define STuplePack_Object_orParamsNil(INDEX, ARG) \
        (ARG) ? : nil

#define metamacro_foreach(MACRO, SEP, ...) \
        metamacro_foreach_cxt(metamacro_foreach_iter, SEP, MACRO, __VA_ARGS__)
#define metamacro_foreach2(MACRO, SENDER, SELECTOR, ...) \
        metamacro_foreach2_cxt(MACRO, SENDER, SELECTOR, __VA_ARGS__)

#define metamacro_foreach_cxt(MACRO, SEP, CONTEXT, ...) \
        metamacro_concat(metamacro_foreach_cxt, metamacro_argcount(__VA_ARGS__))(MACRO, SEP, CONTEXT, __VA_ARGS__)
#define metamacro_foreach2_cxt(MACRO, SENDER, SELECTOR, ...) \
        metamacro_concat(metamacro_foreach2_cxt, metamacro_argcount(__VA_ARGS__))(MACRO, SENDER, SELECTOR, __VA_ARGS__)

#define metamacro_argcount(...) \
        metamacro_at(20, __VA_ARGS__, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1)

#define metamacro_at(N, ...) \
        metamacro_concat(metamacro_at, N)(__VA_ARGS__)

#define metamacro_take(N, ...) \
        metamacro_concat(metamacro_take, N)(__VA_ARGS__)
#define metamacro_concat(A, B) \
        metamacro_concat_(A, B)
#define metamacro_at20(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19, ...) \
        metamacro_head(__VA_ARGS__)




#define metamacro_foreach2_cxt0(MACRO, SENDER, SELECTOR) \
        ((void (*)(id, SEL))(void *)(MACRO))(SENDER, SELECTOR)

#define metamacro_foreach2_cxt1(MACRO, SENDER, SELECTOR, _0) \
        ((void (*)(id, SEL, id))(void *)(MACRO))(SENDER, SELECTOR, _0)

#define metamacro_foreach2_cxt2(MACRO, SENDER, SELECTOR, _0, _1) \
        ((void (*)(id, SEL, id, id))(void *)(MACRO))(SENDER, SELECTOR, _0, _1)

#define metamacro_foreach2_cxt3(MACRO, SENDER, SELECTOR, _0, _1, _2) \
        ((void (*)(id, SEL, id, id, id))(void *)(MACRO))(SENDER, SELECTOR, _0, _1, _2)

#define metamacro_foreach2_cxt4(MACRO, SENDER, SELECTOR, _0, _1, _2, _3) \
        ((void (*)(id, SEL, id, id, id, id))(void *)(MACRO))(SENDER, SELECTOR, _0, _1, _2, _3)

#define metamacro_foreach2_cxt5(MACRO, SENDER, SELECTOR, _0, _1, _2, _3, _4) \
        ((void (*)(id, SEL, id, id, id, id, id))(void *)(MACRO))(SENDER, SELECTOR, _0, _1, _2, _3, _4)

#define metamacro_foreach2_cxt6(MACRO, SENDER, SELECTOR, _0, _1, _2, _3, _4, _5) \
        ((void (*)(id, SEL, id, id, id, id, id, id))(void *)(MACRO))(SENDER, SELECTOR, _0, _1, _2, _3, _4, _5)

#define metamacro_foreach2_cxt7(MACRO, SENDER, SELECTOR, _0, _1, _2, _3, _4, _5, _6) \
        ((void (*)(id, SEL, id, id, id, id, id, id, id))(void *)(MACRO))(SENDER, SELECTOR, _0, _1, _2, _3, _4, _5, _6)

#define metamacro_foreach2_cxt8(MACRO, SENDER, SELECTOR, _0, _1, _2, _3, _4, _5, _6, _7) \
        ((void (*)(id, SEL, id, id, id, id, id, id, id, id))(void *)(MACRO))(SENDER, SELECTOR, _0, _1, _2, _3, _4, _5, _6, _7)

#define metamacro_foreach2_cxt9(MACRO, SENDER, SELECTOR, _0, _1, _2, _3, _4, _5, _6, _7, _8) \
        ((void (*)(id, SEL, id, id, id, id, id, id, id, id, id))(void *)(MACRO))(SENDER, SELECTOR, _0, _1, _2, _3, _4, _5, _6, _7, _8)

#define metamacro_foreach2_cxt10(MACRO, SENDER, SELECTOR, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9) \
        ((void (*)(id, SEL, id, id, id, id, id, id, id, id, id, id))(void *)(MACRO))(SENDER, SELECTOR, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9)

#define metamacro_foreach2_cxt11(MACRO, SENDER, SELECTOR, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10) \
        ((void (*)(id, SEL, id, id, id, id, id, id, id, id, id, id, id))(void *)(MACRO))(SENDER, SELECTOR, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10)

#define metamacro_foreach2_cxt12(MACRO, SENDER, SELECTOR, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11) \
        ((void (*)(id, SEL, id, id, id, id, id, id, id, id, id, id, id, id))(void *)(MACRO))(SENDER, SELECTOR, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11)

#define metamacro_foreach2_cxt13(MACRO, SENDER, SELECTOR, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12) \
        ((void (*)(id, SEL, id, id, id, id, id, id, id, id, id, id, id, id, id))(void *)(MACRO))(SENDER, SELECTOR, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12)

#define metamacro_foreach2_cxt14(MACRO, SENDER, SELECTOR, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13) \
        ((void (*)(id, SEL, id, id, id, id, id, id, id, id, id, id, id, id, id, id))(void *)(MACRO))(SENDER, SELECTOR, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13)

#define metamacro_foreach2_cxt15(MACRO, SENDER, SELECTOR, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14) \
        ((void (*)(id, SEL, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id))(void *)(MACRO))(SENDER, SELECTOR, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14)

#define metamacro_foreach2_cxt16(MACRO, SENDER, SELECTOR, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15) \
        ((void (*)(id, SEL, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id))(void *)(MACRO))(SENDER, SELECTOR, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15)

#define metamacro_foreach2_cxt17(MACRO, SENDER, SELECTOR, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16) \
        ((void (*)(id, SEL, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id))(void *)(MACRO))(SENDER, SELECTOR, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16)

#define metamacro_foreach2_cxt18(MACRO, SENDER, SELECTOR, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17) \
        ((void (*)(id, SEL, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id))(void *)(MACRO))(SENDER, SELECTOR, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17)

#define metamacro_foreach2_cxt19(MACRO, SENDER, SELECTOR, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18) \
        ((void (*)(id, SEL, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id))(void *)(MACRO))(SENDER, SELECTOR, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18)

#define metamacro_foreach2_cxt20(MACRO, SENDER, SELECTOR, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19) \
        ((void (*)(id, SEL, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id))(void *)(MACRO))(SENDER, SELECTOR, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19)





#define callFunc_0(MACRO, SENDER, SELECTOR) \
        ((void (*)(id, SEL))(void *)(MACRO))(SENDER, SELECTOR)

#define callFunc_1(MACRO, SENDER, SELECTOR, _array) \
        ((void (*)(id, SEL, id))(void *)(MACRO))(SENDER, SELECTOR, _array[0])

#define callFunc_2(MACRO, SENDER, SELECTOR, _array) \
        ((void (*)(id, SEL, id, id))(void *)(MACRO))(SENDER, SELECTOR, _array[0], _array[1])

#define callFunc_3(MACRO, SENDER, SELECTOR, _array) \
        ((void (*)(id, SEL, id, id, id))(void *)(MACRO))(SENDER, SELECTOR, _array[0], _array[1], _array[2])

#define callFunc_4(MACRO, SENDER, SELECTOR, _array) \
        ((void (*)(id, SEL, id, id, id, id))(void *)(MACRO))(SENDER, SELECTOR, _array[0], _array[1], _array[2], _array[3])

#define callFunc_5(MACRO, SENDER, SELECTOR, _array) \
        ((void (*)(id, SEL, id, id, id, id, id))(void *)(MACRO))(SENDER, SELECTOR, _array[0], _array[1], _array[2], _array[3], _array[4])

#define callFunc_6(MACRO, SENDER, SELECTOR, _array) \
        ((void (*)(id, SEL, id, id, id, id, id, id))(void *)(MACRO))(SENDER, SELECTOR, _array[0], _array[1], _array[2], _array[3], _array[4], _array[5])

#define callFunc_7(MACRO, SENDER, SELECTOR, _array) \
        ((void (*)(id, SEL, id, id, id, id, id, id, id))(void *)(MACRO))(SENDER, SELECTOR, _array[0], _array[1], _array[2], _array[3], _array[4], _array[5], _array[6])

#define callFunc_8(MACRO, SENDER, SELECTOR, _array) \
        ((void (*)(id, SEL, id, id, id, id, id, id, id, id))(void *)(MACRO))(SENDER, SELECTOR, _array[0], _array[1], _array[2], _array[3], _array[4], _array[5], _array[6], _array[7])

#define callFunc_9(MACRO, SENDER, SELECTOR, _array) \
        ((void (*)(id, SEL, id, id, id, id, id, id, id, id, id))(void *)(MACRO))(SENDER, SELECTOR, _array[0], _array[1], _array[2], _array[3], _array[4], _array[5], _array[6], _array[7], _array[8])

#define callFunc_10(MACRO, SENDER, SELECTOR, _array) \
        ((void (*)(id, SEL, id, id, id, id, id, id, id, id, id, id))(void *)(MACRO))(SENDER, SELECTOR, _array[0], _array[1], _array[2], _array[3], _array[4], _array[5], _array[6], _array[7], _array[8], _array[9])

#define callFunc_11(MACRO, SENDER, SELECTOR, _array) \
        ((void (*)(id, SEL, id, id, id, id, id, id, id, id, id, id, id))(void *)(MACRO))(SENDER, SELECTOR, _array[0], _array[1], _array[2], _array[3], _array[4], _array[5], _array[6], _array[7], _array[8], _array[9], _array[10])

#define callFunc_12(MACRO, SENDER, SELECTOR, _array) \
        ((void (*)(id, SEL, id, id, id, id, id, id, id, id, id, id, id, id))(void *)(MACRO))(SENDER, SELECTOR, _array[0], _array[1], _array[2], _array[3], _array[4], _array[5], _array[6], _array[7], _array[8], _array[9], _array[10], _array[11])

#define callFunc_13(MACRO, SENDER, SELECTOR, _array) \
        ((void (*)(id, SEL, id, id, id, id, id, id, id, id, id, id, id, id, id))(void *)(MACRO))(SENDER, SELECTOR, _array[0], _array[1], _array[2], _array[3], _array[4], _array[5], _array[6], _array[7], _array[8], _array[9], _array[10], _array[11], _array[12])

#define callFunc_14(MACRO, SENDER, SELECTOR, _array) \
        ((void (*)(id, SEL, id, id, id, id, id, id, id, id, id, id, id, id, id, id))(void *)(MACRO))(SENDER, SELECTOR, _array[0], _array[1], _array[2], _array[3], _array[4], _array[5], _array[6], _array[7], _array[8], _array[9], _array[10], _array[11], _array[12], _array[13])

#define callFunc_15(MACRO, SENDER, SELECTOR, _array) \
        ((void (*)(id, SEL, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id))(void *)(MACRO))(SENDER, SELECTOR, _array[0], _array[1], _array[2], _array[3], _array[4], _array[5], _array[6], _array[7], _array[8], _array[9], _array[10], _array[11], _array[12], _array[13], _array[14])

#define callFunc_16(MACRO, SENDER, SELECTOR, _array) \
        ((void (*)(id, SEL, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id))(void *)(MACRO))(SENDER, SELECTOR, _array[0], _array[1], _array[2], _array[3], _array[4], _array[5], _array[6], _array[7], _array[8], _array[9], _array[10], _array[11], _array[12], _array[13], _array[14], _array[15])

#define callFunc_17(MACRO, SENDER, SELECTOR, _array) \
        ((void (*)(id, SEL, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id))(void *)(MACRO))(SENDER, SELECTOR, _array[0], _array[1], _array[2], _array[3], _array[4], _array[5], _array[6], _array[7], _array[8], _array[9], _array[10], _array[11], _array[12], _array[13], _array[14], _array[15], _array[16])

#define callFunc_18(MACRO, SENDER, SELECTOR, _array) \
        ((void (*)(id, SEL, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id))(void *)(MACRO))(SENDER, SELECTOR, _array[0], _array[1], _array[2], _array[3], _array[4], _array[5], _array[6], _array[7], _array[8], _array[9], _array[10], _array[11], _array[12], _array[13], _array[14], _array[15], _array[16], _array[17])

#define callFunc_19(MACRO, SENDER, SELECTOR, _array) \
        ((void (*)(id, SEL, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id))(void *)(MACRO))(SENDER, SELECTOR, _array[0], _array[1], _array[2], _array[3], _array[4], _array[5], _array[6], _array[7], _array[8], _array[9], _array[10], _array[11], _array[12], _array[13], _array[14], _array[15], _array[16], _array[17], _array[18])

#define callFunc_20(MACRO, SENDER, SELECTOR, _array) \
        ((void (*)(id, SEL, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id))(void *)(MACRO))(SENDER, SELECTOR, _array[0], _array[1], _array[2], _array[3], _array[4], _array[5], _array[6], _array[7], _array[8], _array[9], _array[10], _array[11], _array[12], _array[13], _array[14], _array[15], _array[16], _array[17], _array[18], _array[19])



#define metamacro_foreach_cxt0(MACRO, SEP, CONTEXT)
#define metamacro_foreach_cxt1(MACRO, SEP, CONTEXT, _0) MACRO(0, CONTEXT, _0)

#define metamacro_foreach_cxt2(MACRO, SEP, CONTEXT, _0, _1) \
        metamacro_foreach_cxt1(MACRO, SEP, CONTEXT, _0) \
        SEP \
        MACRO(1, CONTEXT, _1)

#define metamacro_foreach_cxt3(MACRO, SEP, CONTEXT, _0, _1, _2) \
        metamacro_foreach_cxt2(MACRO, SEP, CONTEXT, _0, _1) \
        SEP \
        MACRO(2, CONTEXT, _2)

#define metamacro_foreach_cxt4(MACRO, SEP, CONTEXT, _0, _1, _2, _3) \
        metamacro_foreach_cxt3(MACRO, SEP, CONTEXT, _0, _1, _2) \
        SEP \
        MACRO(3, CONTEXT, _3)

#define metamacro_foreach_cxt5(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4) \
        metamacro_foreach_cxt4(MACRO, SEP, CONTEXT, _0, _1, _2, _3) \
        SEP \
        MACRO(4, CONTEXT, _4)

#define metamacro_foreach_cxt6(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5) \
        metamacro_foreach_cxt5(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4) \
        SEP \
        MACRO(5, CONTEXT, _5)

#define metamacro_foreach_cxt7(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6) \
        metamacro_foreach_cxt6(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5) \
        SEP \
        MACRO(6, CONTEXT, _6)

#define metamacro_foreach_cxt8(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7) \
        metamacro_foreach_cxt7(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6) \
        SEP \
        MACRO(7, CONTEXT, _7)

#define metamacro_foreach_cxt9(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8) \
        metamacro_foreach_cxt8(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7) \
        SEP \
        MACRO(8, CONTEXT, _8)

#define metamacro_foreach_cxt10(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9) \
        metamacro_foreach_cxt9(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8) \
        SEP \
        MACRO(9, CONTEXT, _9)

#define metamacro_foreach_cxt11(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10) \
        metamacro_foreach_cxt10(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9) \
        SEP \
        MACRO(10, CONTEXT, _10)

#define metamacro_foreach_cxt12(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11) \
        metamacro_foreach_cxt11(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10) \
        SEP \
        MACRO(11, CONTEXT, _11)

#define metamacro_foreach_cxt13(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12) \
        metamacro_foreach_cxt12(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11) \
        SEP \
        MACRO(12, CONTEXT, _12)

#define metamacro_foreach_cxt14(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13) \
        metamacro_foreach_cxt13(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12) \
        SEP \
        MACRO(13, CONTEXT, _13)

#define metamacro_foreach_cxt15(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14) \
        metamacro_foreach_cxt14(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13) \
        SEP \
        MACRO(14, CONTEXT, _14)

#define metamacro_foreach_cxt16(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15) \
        metamacro_foreach_cxt15(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14) \
        SEP \
        MACRO(15, CONTEXT, _15)

#define metamacro_foreach_cxt17(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16) \
        metamacro_foreach_cxt16(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15) \
        SEP \
        MACRO(16, CONTEXT, _16)

#define metamacro_foreach_cxt18(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17) \
        metamacro_foreach_cxt17(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16) \
        SEP \
        MACRO(17, CONTEXT, _17)

#define metamacro_foreach_cxt19(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18) \
        metamacro_foreach_cxt18(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17) \
        SEP \
        MACRO(18, CONTEXT, _18)

#define metamacro_foreach_cxt20(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19) \
        metamacro_foreach_cxt19(MACRO, SEP, CONTEXT, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18) \
        SEP \
        MACRO(19, CONTEXT, _19)

#endif /* SConnectMacro_Inner_h */
