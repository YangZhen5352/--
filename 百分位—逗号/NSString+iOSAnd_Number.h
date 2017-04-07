//
//  NSString+iOSAnd_Number.h
//  iOSAnd%Number_Damo
//
//  Created by 杨振 on 16/3/2.
//  Copyright © 2016年 yangzhen5352. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (iOSAnd_Number)

// 给数字添加逗号
- (NSString *)countNumAndChangeformat:(NSString *)num;
+ (NSString *)countNumAndChangeformat:(NSString *)num;

@end
