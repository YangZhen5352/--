//
//  SecurityUtil.m
//  rest
//
//  Created by masonneil on 15/8/26.
//  Copyright (c) 2015年 masonneil. All rights reserved.
//

#import "SecurityUtil.h"
#import "NSData+NSData_AES.h"
@implementation SecurityUtil

#pragma mark - AES加密
//将string转成带密码的data
+(NSString*)encryptAESData:(NSString*)string app_key:(NSString*)key
{
    //将nsstring转化为nsdata
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    //使用密码对nsdata进行加密
//    NSData *encryptedData = [data AES128EncryptWithKey:key];
    NSData *encryptedData = [data AES256EncryptWithKey:key];

//    NSLog(@"加密后的字符串 :%@",[encryptedData base64Encoding]);
    
    [self decryptAESData:encryptedData app_key:key];
    return [encryptedData base64Encoding];
}

#pragma mark - AES解密
//将带密码的data转成string
+(NSString*)decryptAESData:(NSData*)data  app_key:(NSString*)key
{
    //使用密码对data进行解密
//    NSData *decryData = [data AES128DecryptWithKey:key];
    NSData *decryData = [data AES256DecryptWithKey:key];

    //将解了密码的nsdata转化为nsstring
    NSString *str = [[NSString alloc] initWithData:decryData encoding:NSUTF8StringEncoding];
//    NSLog(@"解密后的字符串 :%@",str);
    return [str autorelease];
}

@end
