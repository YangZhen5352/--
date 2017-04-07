//
//  ApplicationInfo.m
//  TK_Community
//
//  Created by zq on 15/7/29.
//  Copyright (c) 2015年 zhangqiang. All rights reserved.
//

#import "ApplicationInfo.h"

@implementation ApplicationInfo

+ (instancetype)getInstance
{
    static ApplicationInfo* _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [ApplicationInfo new];
    });
    return _instance;
}

#pragma mark - GenerateCustomView
- (UILabel*)createLabel:(NSString*)caption
{
    UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectZero];
    lbl.font = [UIFont systemFontOfSize:16.0];
    lbl.userInteractionEnabled = YES;
    lbl.textColor = [UIColor blackColor];
    lbl.text = caption;
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.clipsToBounds = YES;
    return lbl;
}
- (UIImageView*)createImgV:(UIImage*)tempImg
{
    UIImageView* imgV = [[UIImageView alloc] initWithFrame:CGRectZero];
    if (tempImg) {
        [imgV setImage:tempImg];
    }
    return imgV;
}
- (UITextField*)createTextField:(NSString*)strHolder
{
    UITextField* tf = [[UITextField alloc] initWithFrame:CGRectZero];
    tf.borderStyle = UITextBorderStyleNone;
    tf.backgroundColor = [UIColor clearColor];
    tf.font = [UIFont systemFontOfSize:16.0];
    tf.textColor = [UIColor blackColor];
    tf.placeholder = strHolder;
    tf.autocorrectionType = UITextAutocorrectionTypeNo;
    tf.adjustsFontSizeToFitWidth = YES;
    tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    tf.returnKeyType = UIReturnKeyDone;
    return tf;
}
- (UIButton*)createButton:(NSString*)title
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    btn.backgroundColor = [UIColor clearColor];
    return btn;
}

#pragma mark - 从Userdefault获取信息
- (BOOL)getBool:(int)ikey
{
    NSString* strKey = [NSString stringWithFormat:@"%d", ikey];
    return [[NSUserDefaults standardUserDefaults] boolForKey:strKey];
}
- (void)setBool:(int)ikey val:(BOOL)val
{
    NSString* strKey = [NSString stringWithFormat:@"%d", ikey];
    [[NSUserDefaults standardUserDefaults] setBool:val forKey:strKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (int)getInteger:(int)ikey
{
    NSString* strKey = [NSString stringWithFormat:@"%d", ikey];
    return (int)[[NSUserDefaults standardUserDefaults] integerForKey:strKey];
}
- (void)setInteger:(int)ikey val:(int)val
{
    NSString* strKey = [NSString stringWithFormat:@"%d", ikey];
    [[NSUserDefaults standardUserDefaults] setInteger:val forKey:strKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString*)getString:(int)ikey
{
    NSString* strKey = [NSString stringWithFormat:@"%d", ikey];
    NSString* temp = [[NSUserDefaults standardUserDefaults] stringForKey:strKey];
    return temp ? temp : nil;
}
- (void)setStringKey:(int)ikey str:(NSString*)str
{
    if (str == nil) {
        [self removeKey:ikey];
        return;
    }
    NSString* strKey = [NSString stringWithFormat:@"%d", ikey];
    [[NSUserDefaults standardUserDefaults] setObject:[str copy] forKey:strKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSDictionary*)getDictionary:(int)ikey
{
    NSString* strKey = [NSString stringWithFormat:@"%d", ikey];
    NSDictionary* temp =
        [[NSUserDefaults standardUserDefaults] dictionaryForKey:strKey];
    return temp;
}

- (void)setDictionary:(int)ikey dict:(NSDictionary*)dict
{
    if (dict == nil) {
        [self removeKey:ikey];
        return;
    }
    NSString* strKey = [NSString stringWithFormat:@"%d", ikey];
    [[NSUserDefaults standardUserDefaults] setObject:[dict copy] forKey:strKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSArray*)getArray:(int)ikey
{
    NSString* strKey = [NSString stringWithFormat:@"%d", ikey];
    NSArray* temp =
        [[NSUserDefaults standardUserDefaults] arrayForKey:strKey];
    return temp;
}

- (void)setArrayKey:(int)ikey arr:(NSArray*)arr
{
    if (arr == nil) {
        [self removeKey:ikey];
        return;
    }
    NSString* strKey = [NSString stringWithFormat:@"%d", ikey];
    [[NSUserDefaults standardUserDefaults] setObject:[arr copy] forKey:strKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeKey:(int)ikey
{
    NSString* strKey = [NSString stringWithFormat:@"%d", ikey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:strKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 懒加载
static NSMutableArray* houseTArray = nil;
static NSMutableArray* productTArray = nil;
- (NSMutableArray*)houseTypeArray
{
    if (houseTArray == nil) {
        houseTArray = [@[
            @{
                @"name" : @"标准一居室",
                @"code" : @"001"
            },
            @{
                @"name" : @"小一室一厅",
                @"code" : @"002"
            },
            @{
                @"name" : @"大一室一厅",
                @"code" : @"003"
            },
            @{
                @"name" : @"二室一厅",
                @"code" : @"004"
            }
        ] mutableCopy];
    }
    return houseTArray;
}
- (NSMutableArray*)productTypeArray
{
    if (productTArray == nil) {
        productTArray = [@[
            @{
                @"name" : @"独立生活",
                @"code" : @"01"
            },
            @{
                @"name" : @"协助生活",
                @"code" : @"02"
            },
            @{
                @"name" : @"专业护理",
                @"code" : @"03"
            },
            @{
                @"name" : @"记忆障碍",
                @"code" : @"04"
            }
        ] mutableCopy];
    }
    return productTArray;
}
#pragma mark - 获取加密后的密码
- (void)doGetEncryptedPassword:(NSString*)pwdStr
                   andComplete:(EndPwdCompleteBlock)endBlock
{
    _tempPwdStr = pwdStr;
    UIWebView* webView =
        [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
    _tempWebView = webView;
    //设置webView
    webView.backgroundColor = [UIColor lightGrayColor];
    webView.layer.borderColor = [[UIColor redColor] CGColor];
    webView.layer.borderWidth = 2;
    webView.delegate = self;
    //找到jsIOS.html文件的路径
    NSString* basePath = [[NSBundle mainBundle] bundlePath];
    NSString* helpHtmlPath =
        [basePath stringByAppendingPathComponent:@"sha1.html"];
    NSURL* url = [NSURL fileURLWithPath:helpHtmlPath];
    //加载本地html文件
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    _endPwdComBlock = endBlock;
}
- (void)webViewDidFinishLoad:(UIWebView*)webView
{
    NSString* inputStr =
        [NSString stringWithFormat:@"postStr('%@');", _tempPwdStr];
    NSString* resultStr =
        [_tempWebView stringByEvaluatingJavaScriptFromString:inputStr];
    _endPwdComBlock(resultStr);
}

@end