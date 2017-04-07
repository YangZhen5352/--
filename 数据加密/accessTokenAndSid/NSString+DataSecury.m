//
//  NSString+DataSecury.m
//  ZhongYingRenShou
//
//  Created by pangxinyu on 15/12/1.
//  Copyright © 2015年 seerkey_joker. All rights reserved.
//

#import "NSString+DataSecury.h"
#import "ASIHTTPRequest.h"
#import "SBJSON.h"
#import "LSYDBHelper.h"
#import "PXYSAVEHelper.h"
#import <Security/Security.h>
#import "SecurityUtil.h"
#import "GTMBase64.h"
#import "NSString+HMAC.h"
#import "NSString+Base64.h"
#import <AdSupport/ASIdentifierManager.h>
#import "CommonFunc.h"
#import "NSData+NSData_AES.h"

@implementation NSString (DataSecury)
-(NSString *)Datasecurity
{
    NSString * openId =[[NSUserDefaults standardUserDefaults] objectForKey:@"openId"];
    
    NSString *key = [@"46052543" HMACWithSecret:openId];
    
    NSString *data =[NSString stringWithFormat:@"%@",self];
    
    
    NSString *result =[SecurityUtil encryptAESData:data app_key:key];
    
    return result;
}
@end
