//
//  ZYGetSecurityTool.h
//  ZhongYingRenShou
//
//  Created by pangxinyu on 15/9/25.
//  Copyright (c) 2015年 seerkey_joker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYGetSecurityTool : NSObject
/*
 *  sid  access_token  SECdata  加入header
    url 传入 加密url
 */

+(NSDictionary*)GetSecurity:(NSString *)url;

/**
 *   数据解密
 */
+(NSString *)DataDesecurity:(NSString *)securityString;
/**
 *   数据加密
 */

+(NSString *)Datasecurity:(NSString *)securityString;



+(NSString *)testSec;
+(NSString *)GetImei;
@end
