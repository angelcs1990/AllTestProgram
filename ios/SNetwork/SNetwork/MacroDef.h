//
//  MacroDef.h
//  SNetworkDemo
//
//  Created by cs on 16/6/3.
//  Copyright © 2016年 cs. All rights reserved.
//

#ifndef MacroDef_h
#define MacroDef_h

#define XCODE_COLORS_ESCAPE @"\033["
#define XCODE_COLORS_RESET_FG XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET XCODE_COLORS_ESCAPE @";" // Clear any foreground or background color

#define S_LOG(_value) NSLog((XCODE_COLORS_ESCAPE @"fg255,0,0;" @"文件：%@ 函数：%s(%d) > %@" XCODE_COLORS_RESET), [[NSString stringWithUTF8String: __FILE__] lastPathComponent], __func__, __LINE__, _value )

#define _FUN_IMPLEMENT_ASSERT() {\
NSString *_FUN_IMPLEMENT_ASSERT_TMP = [NSString stringWithFormat:@"%@请在%@类中实现%s函数",[[NSString stringWithUTF8String: __FILE__] lastPathComponent], NSStringFromClass([self class]), __FUNCTION__];\
NSAssert(NO, _FUN_IMPLEMENT_ASSERT_TMP);\
}
#endif /* MacroDef_h */
