//
//  NSString+QtExtension.h
//  SConnectDemo
//
//  Created by cs on 16/11/22.
//  Copyright © 2016年 cs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (QtExtension)

- (BOOL)contains:(NSString *)c;

- (NSInteger)indexOf:(NSString *)c;

- (NSArray<NSString *> *)split:(NSString *)c;

- (BOOL)endsWith:(NSString *)c;

- (BOOL)startsWith:(NSString *)c;

@end
