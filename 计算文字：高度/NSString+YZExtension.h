//
//  NSString+YZExtension.h
//  ZhongYingRenShou
//
//  Created by 杨振 on 15/12/14.
//  Copyright © 2015年 seerkey_joker. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  自动获取：给定字符串的高度
 */
@interface NSString (YZExtension)

/** 类方法 */
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;
/** 对象方法 */
- (CGSize)sizeOfTextFont:(UIFont *)font maxSize:(CGSize)maxSize;

@end
