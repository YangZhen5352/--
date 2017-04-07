//
//  NSData+NSData_AES.h
//  rest
//
//  Created by masonneil on 15/8/26.
//  Copyright (c) 2015年 masonneil. All rights reserved.
//

#import <Foundation/Foundation.h>
// 对称加密
@class NSString;
@interface NSData (NSData_AES)

- (NSData *)AES128EncryptWithKey:(NSString *)key;   //加密
- (NSData *)AES128DecryptWithKey:(NSString *)key;   //解密

- (NSData *)AES256EncryptWithKey:(NSString *)key;
- (NSData *)AES256DecryptWithKey: (NSString *)key;

@end
