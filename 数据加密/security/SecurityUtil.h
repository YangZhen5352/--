//
//  SecurityUtil.h
//  rest
//
//  Created by masonneil on 15/8/26.
//  Copyright (c) 2015年 masonneil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SecurityUtil : NSObject

+ (NSString*)encryptAESData:(NSString*)string app_key:(NSString*)key ;
//将带密码的data转成string
+(NSString*)decryptAESData:(NSData*)data app_key:(NSString*)key ;

@end
