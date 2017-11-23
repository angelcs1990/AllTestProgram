//
//  SClassMethodInfo.m
//  SConnectDemo
//
//  Created by cs on 16/11/24.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "SClassMethodInfo.h"
#import <UIKit/UIKit.h>


static SEncodingType SEncodingGetType(const char *typeEncoding) {
    char *type = (char *)typeEncoding;
    if (!type) return YYEncodingTypeUnknown;
    size_t len = strlen(type);
    if (len == 0) return YYEncodingTypeUnknown;
    


    len = strlen(type);
    if (len == 0) return YYEncodingTypeUnknown;
    
    switch (*type) {
        case 'v': return YYEncodingTypeVoid;
        case 'B': return YYEncodingTypeBool;
        case 'c': return YYEncodingTypeInt8;
        case 'C': return YYEncodingTypeUInt8;
        case 's': return YYEncodingTypeInt16;
        case 'S': return YYEncodingTypeUInt16;
        case 'i': return YYEncodingTypeInt32;
        case 'I': return YYEncodingTypeUInt32;
        case 'l': return YYEncodingTypeInt32;
        case 'L': return YYEncodingTypeUInt32;
        case 'q': return YYEncodingTypeInt64;
        case 'Q': return YYEncodingTypeUInt64;
        case 'f': return YYEncodingTypeFloat;
        case 'd': return YYEncodingTypeDouble;
        case 'D': return YYEncodingTypeLongDouble;
        case '#': return YYEncodingTypeClass;
        case ':': return YYEncodingTypeSEL;
        case '*': return YYEncodingTypeCString;
        case '^': return YYEncodingTypePointer;
        case '[': return YYEncodingTypeCArray;
        case '(': return YYEncodingTypeUnion;
        case '{': return YYEncodingTypeStruct;
        case '@': {
            if (len == 2 && *(type + 1) == '?')
                return YYEncodingTypeBlock;
            else
                return YYEncodingTypeObject;
        }
        default: return YYEncodingTypeUnknown;
    }
}



@implementation objTypeValues
@end

@implementation SClassMethodInfo

+ (void)load
{
    NSSetUncaughtExceptionHandler(&handlerExc);
    for (int i = 1; i < 31; i++) {
        signal(i, sigException);
    }

}
- (void)showType
{
    for (int i = 0; i < _argumentTypeEncodings.count; ++i) {
        const char *type = [_argumentTypeEncodings[i] UTF8String];
        SEncodingType tp = SEncodingGetType(type);
        NSLog(@"%@", [NSString stringWithFormat:@"%ld", tp]);
    }
}

void sigException(int signal)
{
    NSLog(@"出错了");
}
void handlerExc(NSException *ex)
{
    NSLog(@"cccc");
}
+ (NSArray *)BoxValues:(SClassMethodInfo *)info withVaList:(va_list)v;
{
    NSMutableArray *array = [NSMutableArray array];

    for (int i = 2; i < info.argumentTypeEncodings.count; ++i) {
        const char *type = [info.argumentTypeEncodings[i] UTF8String];
        objTypeValues *obj = [objTypeValues new];
        if (strcmp(type, @encode(id)) == 0) {
            id actual = va_arg(v, id);
            obj->_obj = actual;
            obj->_type = SValueTypeObject;
        } else if (strcmp(type, @encode(CGPoint)) == 0) {
            CGPoint actual = (CGPoint)va_arg(v, CGPoint);
            obj->_obj = [NSValue value:&actual withObjCType:type];
            obj->_type = SValueTypeCGPoint;
        } else if (strcmp(type, @encode(CGSize)) == 0) {
            CGSize actual = (CGSize)va_arg(v, CGSize);
            obj->_obj = [NSValue value:&actual withObjCType:type];
            obj->_type = SValueTypeCGSize;
        } else if (strcmp(type, @encode(UIEdgeInsets)) == 0) {
            UIEdgeInsets actual = (UIEdgeInsets)va_arg(v, UIEdgeInsets);
            obj->_obj = [NSValue value:&actual withObjCType:type];
            obj->_type = SValueTypeUIEdgeInsets;
        } else if (strcmp(type, @encode(double)) == 0) {
            double actual = (double)va_arg(v, double);
            obj->_obj = [NSNumber numberWithDouble:actual];
            obj->_type = SValueTypeDouble;
        } else if (strcmp(type, @encode(float)) == 0) {
            float actual = (float)va_arg(v, double);
            obj->_obj = [NSNumber numberWithFloat:actual];
            obj->_type = SValueTypeFloat;
        } else if (strcmp(type, @encode(int)) == 0) {
            int actual = (int)va_arg(v, int);
            obj->_obj = [NSNumber numberWithInt:actual];
            obj->_type = SValueTypeInt32;
        } else if (strcmp(type, @encode(long)) == 0) {
            long actual = (long)va_arg(v, long);
            obj->_obj = [NSNumber numberWithLong:actual];
            obj->_type = SValueTypeLong;
        } else if (strcmp(type, @encode(long long)) == 0) {
            long long actual = (long long)va_arg(v, long long);
            obj->_obj = [NSNumber numberWithLongLong:actual];
            obj->_type = SValueTypeInt64;
        } else if (strcmp(type, @encode(short)) == 0) {
            short actual = (short)va_arg(v, int);
            obj->_obj = [NSNumber numberWithShort:actual];
            obj->_type = SValueTypeInt16;
        } else if (strcmp(type, @encode(char)) == 0) {
            char actual = (char)va_arg(v, int);
            obj->_obj = [NSNumber numberWithChar:actual];
            obj->_type = SValueTypeInt8;
        } else if (strcmp(type, @encode(bool)) == 0) {
            bool actual = (bool)va_arg(v, int);
            obj->_obj = [NSNumber numberWithBool:actual];
            obj->_type = SValueTypeBool;
        } else if (strcmp(type, @encode(unsigned char)) == 0) {
            unsigned char actual = (unsigned char)va_arg(v, unsigned int);
            obj->_obj = [NSNumber numberWithUnsignedChar:actual];
            obj->_type = SValueTypeUInt8;
        } else if (strcmp(type, @encode(unsigned int)) == 0) {
            unsigned int actual = (unsigned int)va_arg(v, unsigned int);
            obj->_obj = [NSNumber numberWithUnsignedInt:actual];
            obj->_type = SValueTypeUInt32;
        } else if (strcmp(type, @encode(unsigned long)) == 0) {
            unsigned long actual = (unsigned long)va_arg(v, unsigned long);
            obj->_obj = [NSNumber numberWithUnsignedLong:actual];
            obj->_type = SValueTypeULong;
        } else if (strcmp(type, @encode(unsigned long long)) == 0) {
            unsigned long long actual = (unsigned long long)va_arg(v, unsigned long long);
            obj->_obj = [NSNumber numberWithUnsignedLongLong:actual];
            obj->_type = SValueTypeUInt64;
        } else if (strcmp(type, @encode(unsigned short)) == 0) {
            unsigned short actual = (unsigned short)va_arg(v, unsigned int);
            obj->_obj = [NSNumber numberWithUnsignedShort:actual];
            obj->_type = SValueTypeUInt16;
        }
        
        [array addObject:obj];
    }

    
    return array;
}

- (instancetype)initWithMethod:(Method)method
{
    if (!method) return nil;
    self = [super init];
    _method = method;
    _sel = method_getName(method);
    _imp = method_getImplementation(method);
    const char *name = sel_getName(_sel);
    if (name) {
        _name = [NSString stringWithUTF8String:name];
    }
    const char *typeEncoding = method_getTypeEncoding(method);
    if (typeEncoding) {
        _typeEncoding = [NSString stringWithUTF8String:typeEncoding];
    }
    char *returnType = method_copyReturnType(method);
    if (returnType) {
        _returnTypeEncoding = [NSString stringWithUTF8String:returnType];
        free(returnType);
    }
    unsigned int argumentCount = method_getNumberOfArguments(method);
    if (argumentCount > 0) {
        NSMutableArray *argumentTypes = [NSMutableArray new];
        for (unsigned int i = 0; i < argumentCount; i++) {
            char *argumentType = method_copyArgumentType(method, i);
            NSString *type = argumentType ? [NSString stringWithUTF8String:argumentType] : nil;
            [argumentTypes addObject:type ? type : @""];
            if (argumentType) free(argumentType);
        }
        _argumentTypeEncodings = argumentTypes;
    }
    return self;
}

@end
