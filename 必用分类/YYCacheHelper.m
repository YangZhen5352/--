//
//  YYCacheHelper.m
//  YYCacheHelper
//
//  Created by 杨振 on 16/4/15.
//  Copyright © 2016年 yangzhen5352. All rights reserved.
//

#import "YYCacheHelper.h"

@implementation YYCacheHelper

+ (void) setObject:(NSData *) data forKey:(NSString *) key withExpires:(int) expires
{
    // 生成时间戳文件
    NSDate *dt = [NSDate date];
    double now = [dt timeIntervalSince1970];
    NSMutableString *expiresString = [[NSMutableString alloc] init];
    NSData *dataExpires = [[expiresString stringByAppendingFormat:@"%f",now+ expires] dataUsingEncoding:NSUTF8StringEncoding];
    //创建缓存时间控制文件
    [dataExpires writeToFile:[[self getTempPath:key] stringByAppendingFormat:@"%@",@".expires"] atomically:NO];
    
    //创建缓存文件，写入缓存
    [data writeToFile:[self getTempPath:key] atomically:NO];
}

// 根据key 获取临时文件夹中的二进制数据文件
+ (NSData *) get:(NSString *) key
{
    if(![self fileExists:[self getTempPath:key]] || [self isExpired:[self getTempPath:key]]){
        NSLog(@"no cache");
        return nil;
    }
    NSData *data = [NSData dataWithContentsOfFile:[self getTempPath:key]];
    return data;
}
// 如果时间戳过期 删除此文件
+ (BOOL)clear: key
{
    NSFileManager *fileManeger = [NSFileManager defaultManager];
    BOOL isExistsPath = [fileManeger fileExistsAtPath:[self getTempPath:key]];
    if (isExistsPath) {
        NSString *path = [self getTempPath:key];
        
        if ([self isExpired:[self getTempPath:key]]) {
            [fileManeger removeItemAtPath:path error:nil];
            return YES;
        }
        return NO;
    }
    return NO;
}
//获取临时文件目录
+ (NSString *)getTempPath:(NSString*)key
{
    NSString *tempPath = NSTemporaryDirectory();
    return [tempPath stringByAppendingPathComponent:key];
}
//判断文件是否存在
+ (BOOL)fileExists:(NSString *)filepath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:filepath];
}

//判断是否过期
+ (BOOL)isExpired:(NSString *) filepath
{
    NSData *data = [NSData dataWithContentsOfFile:[filepath stringByAppendingFormat:@"%@",@".expires"]];
    NSString *expires = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
    double exp = [expires doubleValue];
    NSDate *dt = [NSDate date];
    double value = [dt timeIntervalSince1970];
    
    if(exp > value){
        
        return NO;
    }
    return YES;
}
#pragma mark----------- 文件缓存大小 -------------------
+ (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
+ (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
//    return folderSize/(1024.0*1024.0);
    return folderSize;
}
@end
