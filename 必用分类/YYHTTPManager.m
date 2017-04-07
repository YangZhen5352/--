//
//  YYHTTPManager.m
//  NEWS
//
//  Created by 杨振 on 15/11/16.
//  Copyright © 2015年 yangzhen5352. All rights reserved.
//

#import "YYHTTPManager.h"

@implementation YYHTTPManager

+ (instancetype)manager {
    YYHTTPManager *manager = [super manager];
    
    NSMutableSet *newsSet = [NSMutableSet set];
    newsSet.set = manager.responseSerializer.acceptableContentTypes;
    [newsSet addObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = newsSet;
    
    return manager;
}

@end
