//
//  ApplicationInfo.h
//  TK_Community
//
//  Created by zq on 15/7/29.
//  Copyright (c) 2015年 zhangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "Constants.h"

#define appRemove(ikey) [[ApplicationInfo getInstance] removeKey:ikey] // 移除对象key
// Integer
#define appInteger(ikey) [[ApplicationInfo getInstance] getInteger:ikey] // 返回Integer->key
#define appSetInteger(ikey, sval) \
    [[ApplicationInfo getInstance] setInteger:ikey val:sval] // 设置Integer->key

// String
#define appString(ikey) [[ApplicationInfo getInstance] getString:ikey]// 返回String->key
#define appSetString(ikey, sval) \
    [[ApplicationInfo getInstance] setStringKey:ikey str:sval]// 设置String->key

// Dictionary
#define appDic(ikey) [[ApplicationInfo getInstance] getDictionary:ikey]
#define appSetDic(ikey, sval) \
    [[ApplicationInfo getInstance] setDictionary:ikey dict:sval]

// Array
#define appArray(ikey) [[ApplicationInfo getInstance] getArray:ikey]
#define appSetArray(ikey, sval) \
    [[ApplicationInfo getInstance] setArrayKey:ikey arr:sval]

// Bool
#define appBOOL(ikey) [[ApplicationInfo getInstance] getBool:ikey]
#define appSetBOOL(ikey, sval) \
    [[ApplicationInfo getInstance] setBool:ikey val:sval]

//#define UserID [[ApplicationInfo getInstance] getString:AppInfo_User_ID]
//#define agentNo [[ApplicationInfo getInstance] getString:AppInfo_AgentNo]
//#define companyCode [[ApplicationInfo getInstance] getString:AppInfo_CompanyCode]
//#define branchCode [[ApplicationInfo getInstance] getString:AppInfo_BranchCode]

//@"cs" //@"cs1"
#define UserID [[ApplicationInfo getInstance] getString:AppInfo_User_ID] ? [[ApplicationInfo getInstance] getString:AppInfo_User_ID] : @"cs"

#define agentNo [[ApplicationInfo getInstance] getString:AppInfo_AgentNo]

#define companyCode [[ApplicationInfo getInstance] getString:AppInfo_CompanyCode] ? [[ApplicationInfo getInstance] getString:AppInfo_CompanyCode] : @"1"

#define branchCode [[ApplicationInfo getInstance] getString:AppInfo_BranchCode] ? [[ApplicationInfo getInstance] getString:AppInfo_BranchCode] : @"10"

#define appHouseTypeArray [[ApplicationInfo getInstance] houseTypeArray]
#define appProductTypeArray [ApplicationInfo getInstance].productTypeArray

#define zyCreateButton(title) [[ApplicationInfo getInstance] createButton:title]
#define zyCreateTxtField(placeHolder) [[ApplicationInfo getInstance] createTextField:placeHolder]
#define zyCreateLabel(title) [[ApplicationInfo getInstance] createLabel:title]
#define zyCreateImgView(tempImg) [[ApplicationInfo getInstance] createImgV:tempImg]

//加密后回调的block
typedef void (^EndPwdCompleteBlock)(NSString* resultPwdStr);

@interface ApplicationInfo : NSObject <UIWebViewDelegate> {
    UIWebView* _tempWebView;
    NSString* _tempPwdStr;
    EndPwdCompleteBlock _endPwdComBlock;
}
//户型、产品类型
@property (nonatomic, retain) NSMutableArray *houseTypeArray, *productTypeArray;
//@property (nonatomic, retain) NSDictionary* ZY_UserInfo;

+ (instancetype)getInstance;

- (UILabel*)createLabel:(NSString*)caption;
- (UITextField*)createTextField:(NSString*)strHolder;
- (UIButton*)createButton:(NSString*)title;
- (UIImageView*)createImgV:(UIImage*)tempImg;

#pragma mark----------- Userdefault持久化信息 -------------------
- (BOOL)getBool:(int)ikey;
- (void)setBool:(int)ikey val:(BOOL)val;
- (int)getInteger:(int)ikey;
- (void)setInteger:(int)ikey val:(int)val;
- (NSString*)getString:(int)ikey;
- (void)setStringKey:(int)ikey str:(NSString*)str;
- (NSDictionary*)getDictionary:(int)ikey;
- (void)setDictionary:(int)ikey dict:(NSDictionary*)dict;
- (NSArray*)getArray:(int)ikey;
- (void)setArrayKey:(int)ikey arr:(NSArray*)arr;
- (void)removeKey:(int)ikey;


#pragma mark----------- 获取加密后的密码 -------------------
- (void)doGetEncryptedPassword:(NSString*)pwdStr
                   andComplete:(EndPwdCompleteBlock)endBlock;

@end
