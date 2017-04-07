//
//  NSString+YZExtension.m
//  ZhongYingRenShou
//
//  Created by 杨振 on 15/12/14.
//  Copyright © 2015年 seerkey_joker. All rights reserved.
//

#import "NSString+YZExtension.h"

@implementation NSString (YZExtension)

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (CGSize)sizeOfTextFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    return [NSString sizeWithText:self font:font maxSize:maxSize];
}

@end
