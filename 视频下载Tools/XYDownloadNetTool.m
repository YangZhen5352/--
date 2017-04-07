//
//  XYDownloadNetTool.m
//  zhaoZhaoBa
//
//  Created by apple on 16/6/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "XYDownloadNetTool.h"

static NSInteger download_speed_view_width = 117;


//保存视频的 文件夹
static NSString * documents_video_path = @"video";

static NSString * archiver_key = @"archiverkey";



@implementation XYDownloadModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [[XYDownloadNetTool getDownloadDic] setValue:self forKey:self.httpUrl];
    [self autoEncodeWithCoder:aCoder];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if ([super init]) {
        [self autoDecode:aDecoder];
    }
    return self;
}

+ (XYDownloadModel *)downloadModelWithDic:(NSDictionary *)dic
{
    XYDownloadModel * model = [XYDownloadNetTool getDownloadDic][dic[video_ev_videourl]];
//    model.httpUrl = model.httpUrl;
    if (!model) {
        model = [XYDownloadModel createDownLoadModeWithDic:dic];
    }
    return model;
}
+ (XYDownloadModel *)downloadModelWithKey:(NSString *)key
{
    XYDownloadModel * model = [XYDownloadNetTool getDownloadDic][key];
//    model.httpUrl = model.httpUrl;

    if (!model) {
        model = [XYDownloadModel createDownLoadModeWithUrl:key];
    }
    return model;
}


- (NSURL *)localURL
{
    return [XYDownloadNetTool getDownloadURLWith:self.httpUrl];
}

- (NSURL *)fialLocalURL
{
    return [XYDownloadNetTool getFialDownloadURLWith:self.httpUrl];
}

#pragma mark -----------------------------------------------------------
#pragma mark - Setting


- (void)setHttpUrl:(NSString *)httpUrl
{
    _httpUrl = httpUrl.copy;
}

- (void)setDownloadSpeed:(NSString *)downloadSpeed
{
    _downloadSpeed = downloadSpeed.copy;
    
    NSArray * array = [downloadSpeed componentsSeparatedByString:@"/"];
    
    NSString * str1 = array.firstObject;
    NSString * str2 = array.lastObject;
    
    str1 = [str1 stringByReplacingOccurrencesOfString:@"M" withString:@""];
    str2 = [str2 stringByReplacingOccurrencesOfString:@"M" withString:@""];
    
    self.speed = str1.floatValue / str2.floatValue;
    
    NSLog(@" self.speed  % f = str1.floatValue  %f / str2.floatValue %f;  ", self.speed , str1.floatValue , str2.floatValue);


    dispatch_async(dispatch_get_main_queue(), ^{
        self.label.text = downloadSpeed;
        
        if (!isnan(self.speed)) {
            self.speedViewWidth.constant = (int)(self.speed * download_speed_view_width);
            NSLog(@"self.speed (%f)* download_speed_view_width (%ld) = %f",self.speed,(long)download_speed_view_width,(self.speed * download_speed_view_width));
        }
    });
}
- (void)setType:(DownloadModelType)type
{
    _type = type;
    
    switch (type) {
        case DownloadModelType_None: {
           
            break;
        }
        case DownloadModelType_Download: {
            self.imageView.image = [self getImageWithType:1];
            break;
        }
        case DownloadModelType_Suspent: {
            [self.downloadTask suspend];
            self.imageView.image = [self getImageWithType:0];
            break;
        }
        case DownloadModelType_Finish: {
            self.imageView.image = [self getImageWithType:2];
            self.speed = 1;
            self.downloadSpeed = @"完成";
            self.isFinish = YES;
            break;
        }
        case DownloadModelType_Cancle: {
            self.imageView.image = [self getImageWithType:0];
            break;
        }
    }

}

#pragma mark -----------------------------------------------------------
#pragma mark - Method

- (void)save
{
    [[XYDownloadNetTool getDownloadDic] setValue:self forKey:self.httpUrl];
}

+ (XYDownloadModel *)createDownLoadModeWithDic:(NSDictionary *)dic
{
    XYDownloadModel * model = [[XYDownloadModel alloc] init];
    model.httpUrl = dic[video_ev_videourl];
    [model save];
    return model;
}

+ (XYDownloadModel *)createDownLoadModeWithUrl:(NSString *)url
{
    XYDownloadModel * model = [[XYDownloadModel alloc] init];
    model.httpUrl = url;
    [model save];
    return model;
}




//开始下载 图片换为 暂停
- (void)downloadWithFinishBolick:(void(^)())finishBlock
{
    WeakSelf(weakSelf);
    
    if (self.type == DownloadModelType_None) {
        [XYDownloadNetTool downloadFileURL:self.httpUrl model:self speed:^(NSString *download) {
            weakSelf.downloadSpeed = download;
        } finish:^{
            finishBlock ? finishBlock() : 0;
            weakSelf.type = DownloadModelType_Finish;
            [XYDownloadNetTool saveToDiskOfDownloadDic];
        }];
    } else if(self.type == DownloadModelType_Cancle) {
        NSData * data = [NSData dataWithContentsOfURL:self.fialLocalURL];
        if (!data) {
            return;
        }
        self.downloadTask = [XYDownloadNetTool downloadFileData:data url:self.httpUrl model:self speed:^(NSString *speed) {
            weakSelf.downloadSpeed = speed;
        } finish:^(NSString *filePath) {
            finishBlock ? finishBlock() : 0;
            weakSelf.type = DownloadModelType_Finish;
            [XYDownloadNetTool saveToDiskOfDownloadDic];
        }];
    } else {
        [self.downloadTask resume];
    }
    
    self.type = DownloadModelType_Download;
}



- (void)clickImageViewWithPlayBlock:(void(^)(NSURL * url))playBlock
                       suspendBlock:(void(^)())suspendBlock
                      downloadBlock:(void(^)())downloadBlock
                       finishBolick:(void(^)())finishBlock;
{
    switch (self.type) {
        case DownloadModelType_None: {
            [self downloadWithFinishBolick:finishBlock];
            downloadBlock ? downloadBlock() : 0;
            break;
        }
        case DownloadModelType_Download: {
            self.type = DownloadModelType_Suspent;
            suspendBlock ? suspendBlock() : 0;
            break;
        }
        case DownloadModelType_Suspent: {
            [self downloadWithFinishBolick:finishBlock];
            downloadBlock ? downloadBlock() : 0;
            break;
        }
        case DownloadModelType_Finish: {
            playBlock ? playBlock(self.localURL) : 0;
            break;
        }
        case DownloadModelType_Cancle: {
            [self downloadWithFinishBolick:finishBlock];
            break;
        }
    }
}


// 0 => 下载  1 => 暂停  2 => 播放
- (UIImage *)getImageWithType:(NSInteger)type
{
    static UIImage * downloadImage = nil;
    static UIImage * suspendImage = nil;
    static UIImage * playImage = nil;

    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downloadImage = kImage(@"下载");
        suspendImage = kImage(@"暂停");
        playImage = kImage(@"播放");
    });
    
    switch (type) {
        case 0: return downloadImage;
        case 1: return suspendImage;
        case 2: return playImage;
    }
    return kDefaultImage;
}

@end

@implementation XYDownloadNetTool


+ (NSMutableDictionary *)getDownloadDic
{
    static NSMutableDictionary * downloadDic = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downloadDic = [XYDownloadNetTool getDownloadDicWithDisk];
        NSLog(@"downloadDic ==> %@",downloadDic);
        if (!downloadDic) {
            downloadDic = @{}.mutableCopy;
        }
    });
    return downloadDic;
}


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
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    [XYDownloadNetTool setTaskDidCompleteWithManager:manager model:model];

    NSURL *URL = [NSURL URLWithString:[aUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];

    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSString * download = [XYDownloadNetTool getDownloadSpeedWithProgress:downloadProgress];
        speed ? speed(download) : 0;
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        return model.localURL;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        
        if ([filePath.description isEqualToString:@"(null)"] || !filePath) {
            return ;
        }
        finish ? finish(filePath.absoluteString) : 0;
    }];
    //开始
    [downloadTask resume];
    
    model.downloadTask = downloadTask;
    
    return downloadTask;

}


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
                                        finish:(void(^)(NSString * filePath))finish
{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    [XYDownloadNetTool setTaskDidCompleteWithManager:manager model:model];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithResumeData:data progress:^(NSProgress * _Nonnull downloadProgress) {
        NSString * download = [XYDownloadNetTool getDownloadSpeedWithProgress:downloadProgress];
        speed ? speed(download) : 0;
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return model.localURL;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if ([filePath.description isEqualToString:@"(null)"] || !filePath) {
            return ;
        }
        finish ? finish(filePath.absoluteString) : 0;
    }];
    
       //开始
    [downloadTask resume];
    

    return downloadTask;
}





#pragma mark -------------------------------------------------------
#pragma mark Inner Method



+ (void)setTaskDidCompleteWithManager:(AFURLSessionManager *)manager model:(XYDownloadModel *)model
{
    [manager setTaskDidCompleteBlock:^(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSError * _Nullable error) {
        
        NSLog(@"fail error--- %@",error);

        // **** 下载出错，缓存已经下载的数据到指定的缓存文件中
        NSData *resumeData = error.userInfo[NSURLSessionDownloadTaskResumeData];
        if (resumeData.length > 0) {
            model.type = DownloadModelType_Cancle;
            BOOL success = [resumeData writeToURL:model.fialLocalURL atomically:YES];
            NSLog(@"fail success--- %d",success);
        }
    }];
}

//计算 进度
+ (NSString *)getDownloadSpeedWithProgress:(NSProgress *)downloadProgress
{
    return [NSString stringWithFormat:@"%.2fM/%.2fM",downloadProgress.completedUnitCount / 1000000.0,downloadProgress.totalUnitCount / 1000000.0];
}


//获取 完成 视频地址
+ (NSURL *)getDownloadURLWith:(NSString *)url
{
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    documentsDirectoryURL = [documentsDirectoryURL URLByAppendingPathComponent:documents_video_path];
    NSURL * newURL = [documentsDirectoryURL URLByAppendingPathComponent:[XYDownloadNetTool getStringWithUrl:url]];
   
    return newURL;
}


//获取 未完成 视频地址
+ (NSURL *)getFialDownloadURLWith:(NSString *)url
{
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    documentsDirectoryURL = [documentsDirectoryURL URLByAppendingPathComponent:documents_video_path];
    NSURL * newURL = [documentsDirectoryURL URLByAppendingPathComponent:[[XYDownloadNetTool getStringWithUrl:url] stringByAppendingString:@".data"]];
    
    return newURL;
}




/**
 *  删除 地址中的特殊字符
 */
+ (NSString *)getStringWithUrl:(NSString *)url
{
    return [url componentsSeparatedByString:@"/"].lastObject;
}

//反UTF8，然后去掉 file://
+ (NSString *)getPathWithURL:(NSURL *)URL
{
    NSString * newUrl = [URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [newUrl stringByReplacingOccurrencesOfString:@"file://" withString:@""];
}




//////////////////////////////////// 对下载队列的操作 //////////////////////////////////////
+ (void)saveToDiskOfDownloadDicAppDelegate
{
    NSMutableDictionary * dic = [XYDownloadNetTool getDownloadDic];
    
    NSMutableDictionary * newDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    for (NSString * key in dic.allKeys) {
        XYDownloadModel * model = newDic[key];
        model.type = DownloadModelType_Cancle;

        [model.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            // **** 下载出错，缓存已经下载的数据到指定的缓存文件中
            
            if (resumeData.length > 0) {
                BOOL success = [resumeData writeToURL:model.fialLocalURL atomically:YES];
                NSLog(@"fail success--- %d",success);
            }
        }];
        
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:model forKey:archiver_key];
        [archiver finishEncoding];
        
        [newDic setValue:data forKey:key];
    }
    NSLog(@"dic => %@",newDic);
    BOOL success = [newDic writeToFile:[XYDownloadNetTool getDownloadDicPath] atomically:NO];
    
    
    if (success) {
        NSLog(@" download dic save success!!!");
    } else {
        NSLog(@" download dic save fail !!!");
    }

}
+ (void)saveToDiskOfDownloadDic
{
    NSMutableDictionary * dic = [XYDownloadNetTool getDownloadDic];
    
    NSMutableDictionary * newDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    for (NSString * key in dic.allKeys) {
        XYDownloadModel * model = newDic[key];
        
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:model forKey:archiver_key];
        [archiver finishEncoding];
         
        [newDic setValue:data forKey:key];
    }
    NSLog(@"dic => %@",newDic);
    BOOL success = [newDic writeToFile:[XYDownloadNetTool getDownloadDicPath] atomically:NO];
    
    
    if (success) {
        NSLog(@" download dic save success!!!");
    } else {
        NSLog(@" download dic save fail !!!");
    }
}


+ (NSMutableDictionary *)getDownloadDicWithDisk
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithContentsOfFile:[XYDownloadNetTool getDownloadDicPath]];
    
    for (NSString * key in dic.allKeys) {
        
        NSData * data = dic[key];
        
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        
        XYDownloadModel * model = [unarchiver decodeObjectForKey:archiver_key];
        [unarchiver finishDecoding];
        
        [dic setValue:model forKey:key];
    }
    return dic;
}


/**
 * 获取队列路径
 */
+ (NSString *)getDownloadDicPath
{
    NSString * documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString * directory = [documents stringByAppendingPathComponent:documents_video_path];
    documents = [directory stringByAppendingPathComponent:@"downloadDic.data"];
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:documents]) {
        
        if(![fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil] ) {
            NSLog(@"create directory fail");
            NSLog(@"Error was code: %d - message: %s", errno, strerror(errno));
            return documents;
        }
        NSLog(@"create directory success");
        if (![fileManager createFileAtPath:documents contents:[NSData data] attributes:nil]) {
            NSLog(@"create File Fail");
            NSLog(@"Error was code: %d - message: %s", errno, strerror(errno));
            return documents;
        }
        NSLog(@"create file success");
    }
    
    return documents;
}
@end
