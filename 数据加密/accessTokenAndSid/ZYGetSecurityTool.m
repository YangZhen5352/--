//
//  ZYGetSecurityTool.m
//  ZhongYingRenShou
//
//  Created by pangxinyu on 15/9/25.
//  Copyright (c) 2015年 seerkey_joker. All rights reserved.
//

#import "ZYGetSecurityTool.h"
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

@implementation ZYGetSecurityTool


+(NSDictionary*)GetSecurity:(NSString *)url
{
    
    //1  sid
    NSString * sid =[[LSYDBHelper shareDB] gen_uuid];
    sid = [sid lowercaseString];// 转换成小写转换
    
    //2imei
//    NSString *oldidentifierStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
   NSString *imeiId = [ZYGetSecurityTool GetImei];
    
    
    //3 生成一个：key
    NSString * openId =[[NSUserDefaults standardUserDefaults] objectForKey:@"openId"];
    
    NSString * access_token =[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];

    NSString *imeiandopenid =[NSString stringWithFormat:@"%@%@",imeiId,openId];
    NSLog(@"%@___",imeiandopenid);
    NSString *key = [imeiandopenid HMACWithSecret:sid];

    
    //4  data 加密 (拼接url和sid生成SECdata)
    NSString *data =[NSString stringWithFormat:@"%@?requestId=%@",url,sid];
    NSString *result =[SecurityUtil encryptAESData:data app_key:key]; //SEC加密的字符串
    
    
#warning access_token 值问题
    // 总结：1. sid：直接从设备中获取
    //      2. access_token：直接从偏好设置中获取
    //      3. SECdata：url + sid 进行AES加密(imeiId + openId 进行拼接再HMAC加密声称key)
    if (access_token) {
        NSDictionary *dict =@{@"sid":sid,@"access_token":access_token,@"SECdata":result};
        return dict;
    }

    
    return nil;
}
#pragma mark 添加数据解密
+(NSString *)DataDesecurity:(NSString *)securityString
{
    if(securityString == nil){
        return @"";
    }
    NSString * openId =[[NSUserDefaults standardUserDefaults] objectForKey:@"openId"];

    NSString *key = [@"46052543" HMACWithSecret:openId];

    NSData *data = [[NSData alloc]initWithBase64Encoding:securityString];
    
    NSString *result =[SecurityUtil decryptAESData:data app_key:key];
//    [ZYGetSecurityTool Datasecurity:result];
    return result;
  
    
}
#pragma mark 添加数据加密

+(NSString *)Datasecurity:(NSString *)securityString
{
    NSString * openId =[[NSUserDefaults standardUserDefaults] objectForKey:@"openId"];
    
    NSString *key = [@"46052543" HMACWithSecret:openId];
    
    NSString *data =[NSString stringWithFormat:@"%@",securityString];

    
    NSString *result =[SecurityUtil encryptAESData:data app_key:key];
    
    return result;
}



+(NSString *)GetImei
{
    //2imei
    NSString *oldidentifierStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    NSString *identifierStr  = [oldidentifierStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSLog(@"%@____",identifierStr);
    NSString * const KEY_USERNAME_PASSWORD = @"com.snda.app.usernamepassword";
    NSString * const KEY_PASSWORD = @"MYidentifierStr";
    NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
     //取
    NSMutableDictionary *readUserPwd = (NSMutableDictionary *)[PXYSAVEHelper load:KEY_USERNAME_PASSWORD];
    NSLog(@"%@____imeiId  dict_",readUserPwd);

    if (!readUserPwd) {
        //存

        [usernamepasswordKVPairs setObject:identifierStr forKey:KEY_PASSWORD];

        [PXYSAVEHelper  save:KEY_USERNAME_PASSWORD data:usernamepasswordKVPairs];

    }
    
//    NSMutableDictionary *readUserPwd = (NSMutableDictionary *)[PXYSAVEHelper load:KEY_USERNAME_PASSWORD];
    
    NSString *imeiId= [readUserPwd objectForKey:KEY_PASSWORD];
    NSLog(@"%@____imeiId_",imeiId);
    return imeiId;
}

@end
