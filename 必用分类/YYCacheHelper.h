//
//  YYCacheHelper.h
//  YYCacheHelper
//
//  Created by 杨振 on 16/4/15.
//  Copyright © 2016年 yangzhen5352. All rights reserved.
//

#import <Foundation/Foundation.h>

#define YYSetObjectForKeyWithExpires(d, k, e) [YYCacheHelper setObject:d forKey:k withExpires:e]
#define YYGetObjectForKey(k) [YYCacheHelper get:k]
#define YYClearObjectForKey(k) [YYCacheHelper clear:k]


#define YYFoldSizeTemp [YYCacheHelper folderSizeAtPath:NSTemporaryDirectory()]
#define YYFoldSizeDocument [YYCacheHelper folderSizeAtPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]]
#define YYFolderSizePath(p) [YYCacheHelper folderSizeAtPath:p]

#define YYFileSizePath(p) [YYCacheHelper fileSizeAtPath:p]


@interface YYCacheHelper : NSObject

#pragma mark----------- Temp: 文件保存和删除 -------------------
// 保存: 对象二进制数据到临时文件夹 并设置有效期时间（单位：秒）
+ (void)setObject:(NSData *)data forKey:(NSString *)key withExpires:(int)expires;

// 获取: 临时文件夹中的二进制数据文件
+ (NSData *)get:(NSString *)key;

// 删除: 临时文件夹中的文件
+ (BOOL)clear:(NSString *)key;

#pragma mark----------- 计算文件缓存大小 -------------------
// 单个: 文件大小
+ (long long)fileSizeAtPath:(NSString*) filePath;

// 文件夹: 文件大小
+ (float )folderSizeAtPath:(NSString*) folderPath;
@end
