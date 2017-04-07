//
//  XYDownloadNetTool.h
//  zhaoZhaoBa
//
//  Created by apple on 16/6/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "XYNetTool.h"
#import "NSObject+NSCoding.h"


/**
 *  下载状态
 */
typedef NS_ENUM(NSInteger, DownloadModelType) {
    /**
     *  未开始
     */
    DownloadModelType_None      = 0,
    /**
     *  下载中
     */
    DownloadModelType_Download  = 1,
    /**
     *  暂停
     */
    DownloadModelType_Suspent   = 2,
    /**
     *  完成
     */
    DownloadModelType_Finish    = 3,
    /**
     *  取消，在 挂起后 一段时间不恢复 会自动断开连接
     */
    DownloadModelType_Cancle    = 4,
};

@interface XYDownloadModel : NSObject <NSCoding>

@property (nonatomic, strong)NSURLSessionDownloadTask * downloadTask;

/**
 *  12.4M/22.5M
 */
@property (nonatomic, copy)NSString * downloadSpeed;

/**
 *  0 ~ 1
 */
@property (nonatomic, assign)CGFloat speed;

/**
 *  完成的本地文件地址
 */
@property (nonatomic, strong)NSURL * localURL;
/**
 *  未完成的本地文件地址
 */
@property (nonatomic, strong)NSURL * fialLocalURL;

/**
 *  HTTP 连接
 */
@property (nonatomic, copy)NSString * httpUrl;

/**
 *  是否完成
 */
@property (nonatomic, assign)BOOL isFinish;





@property (nonatomic, assign)DownloadModelType type;



@property (nonatomic, strong)UILabel * label;
@property (nonatomic, strong)NSLayoutConstraint * speedViewWidth;
@property (nonatomic, strong)UIImageView * imageView;


- (void)save;

+ (XYDownloadModel *)downloadModelWithDic:(NSDictionary *)dic;
+ (XYDownloadModel *)downloadModelWithKey:(NSString *)key;


//开始下载 图片换为 暂停
- (void)downloadWithFinishBolick:(void(^)())finishBlock;



- (void)clickImageViewWithPlayBlock:(void(^)(NSURL * url))playBlock
                       suspendBlock:(void(^)())suspendBlock
                      downloadBlock:(void(^)())downloadBlock
                       finishBolick:(void(^)())finishBlock;

@end


@interface XYDownloadNetTool : XYNetTool


+ (NSMutableDictionary *)getDownloadDic;




/**
 *  下载文件
 *
 *  @param aUrl   网络地址
 *  @param speed  进度回调
 *  @param finish 完成
 *
 *  @return  NSURLSessionDownloadTask
 */
+ (NSURLSessionDownloadTask *)downloadFileURL:(NSString *)aUrl
                                        model:(XYDownloadModel *)model
                                        speed:(void(^)(NSString * download))speed
                                       finish:(void(^)())finish;
/**
 *  下载未完成的文件
 *
 *  @param aUrl   网络地址
 *  @param speed  进度回调
 *  @param finish 完成
 *
 *  @return  NSURLSessionDownloadTask
 */
+ (NSURLSessionDownloadTask *)downloadFileData:(NSData *)data
                                           url:(NSString *)url
                                         model:(XYDownloadModel *)model
                                         speed:(void(^)(NSString * speed))speed
                                        finish:(void(^)(NSString * filePath))finish;



//////////////////////////////////// 本地URL 文件不一定存在 //////////////////////////////////////

//获取 完成 视频地址
+ (NSURL *)getDownloadURLWith:(NSString *)url;

//获取 未完成 视频地址
+ (NSURL *)getFialDownloadURLWith:(NSString *)url;




//////////////////////////////////// 对下载队列的操作 //////////////////////////////////////
+ (void)saveToDiskOfDownloadDicAppDelegate;
+ (void)saveToDiskOfDownloadDic;


@end
