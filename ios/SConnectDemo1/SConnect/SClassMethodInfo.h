//
//  SClassMethodInfo.h
//  SConnectDemo
//
//  Created by cs on 16/11/24.
//  Copyright © 2016年 cs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, SEncodingType) {
    YYEncodingTypeMask       = 0xFF, ///< mask of type value
    YYEncodingTypeUnknown    = 0, ///< unknown
    YYEncodingTypeVoid       = 1, ///< void
    YYEncodingTypeBool       = 2, ///< bool
    YYEncodingTypeInt8       = 3, ///< char / BOOL
    YYEncodingTypeUInt8      = 4, ///< unsigned char
    YYEncodingTypeInt16      = 5, ///< short
    YYEncodingTypeUInt16     = 6, ///< unsigned short
    YYEncodingTypeInt32      = 7, ///< int
    YYEncodingTypeUInt32     = 8, ///< unsigned int
    YYEncodingTypeInt64      = 9, ///< long long
    YYEncodingTypeUInt64     = 10, ///< unsigned long long
    YYEncodingTypeFloat      = 11, ///< float
    YYEncodingTypeDouble     = 12, ///< double
    YYEncodingTypeLongDouble = 13, ///< long double
    YYEncodingTypeObject     = 14, ///< id
    YYEncodingTypeClass      = 15, ///< Class
    YYEncodingTypeSEL        = 16, ///< SEL
    YYEncodingTypeBlock      = 17, ///< block
    YYEncodingTypePointer    = 18, ///< void*
    YYEncodingTypeStruct     = 19, ///< struct
    YYEncodingTypeUnion      = 20, ///< union
    YYEncodingTypeCString    = 21, ///< char*
    YYEncodingTypeCArray     = 22, ///< char[10] (for example)
};



typedef NS_ENUM(NSUInteger, SValueType) {
    /*unknown*/
    SValueTypeUnknown    = 0,
    /*void*/
    SValueTypeVoid       = 1,
    /*bool*/
    SValueTypeBool       = 2,
    /*char / BOOL*/
    SValueTypeInt8       = 3,
    /*unsigned char*/
    SValueTypeUInt8      = 4,
    /*short*/
    SValueTypeInt16      = 5,
    /*unsigned short*/
    SValueTypeUInt16     = 6,
    /*int*/
    SValueTypeInt32      = 7,
    /*unsigned int*/
    SValueTypeUInt32     = 8,
    /*long long*/
    SValueTypeInt64      = 9,
    /*unsigned long long*/
    SValueTypeUInt64     = 10,
    /*float*/
    SValueTypeFloat      = 11,
    /*double*/
    SValueTypeDouble     = 12,
    /*long double*/
    SValueTypeLongDouble = 13,
    /*id*/
    SValueTypeObject     = 14,
    /*Class*/
    SValueTypeClass      = 15,
    /*SEL*/
    SValueTypeSEL        = 16,
    /*block*/
    SValueTypeBlock      = 17,
    /*void* */
    SValueTypePointer    = 18,
    /*struct*/
    SValueTypeStruct     = 19,
    /*union*/
    SValueTypeUnion      = 20,
    /*char**/
    SValueTypeCString    = 21,
    /*char[10] (for example)*/
    SValueTypeCArray     = 22,
    /**CGPoint*/
    SValueTypeCGPoint    = 23,
    /*CGSize*/
    SValueTypeCGSize     = 24,
    /*UIEdgeInsets*/
    SValueTypeUIEdgeInsets = 25,
    /*long*/
    SValueTypeLong       = 26,
    /*usigned long*/
    SValueTypeULong      = 27,
    
    
};


@interface objTypeValues : NSObject
{
@public
    id _obj;
    SValueType _type;
}
@end

@interface SClassMethodInfo : NSObject

@property (nonatomic, readonly) Method method;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, readonly) SEL sel;
@property (nonatomic, readonly) IMP imp;
@property (nonatomic, strong, readonly) NSString *typeEncoding;
@property (nonatomic, strong, readonly) NSString *returnTypeEncoding;
@property (nonatomic, strong, nullable, readonly) NSArray<NSString *> *argumentTypeEncodings;

- (instancetype)initWithMethod:(Method)method;

- (void)showType;

+ (NSArray *)BoxValues:(SClassMethodInfo *)info withVaList:(va_list)v;

@end

//static SEncodingType SEncodingGetType(const char *typeEncoding);
//id _GQBoxValue(SClassMethodInfo *info, va_list v);

NS_ASSUME_NONNULL_END
