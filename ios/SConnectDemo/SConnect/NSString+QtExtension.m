//
//  NSString+QtExtension.m
//  SConnectDemo
//
//  Created by cs on 16/11/22.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "NSString+QtExtension.h"

@implementation NSString (QtExtension)

- (BOOL)contains:(NSString *)c
{
    return ([self rangeOfString:c].location != NSNotFound);
}

- (NSInteger)indexOf:(NSString *)c
{
    return [self rangeOfString:c].location;
}

- (NSArray<NSString *> *)split:(NSString *)c
{
    return [self componentsSeparatedByString:c];
}

- (BOOL)startsWith:(NSString *)c
{
    return [self hasPrefix:c];
}

- (BOOL)endsWith:(NSString *)c
{
    return [self hasSuffix:c];
}

@end
