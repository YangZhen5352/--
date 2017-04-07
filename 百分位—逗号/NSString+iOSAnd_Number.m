//
//  NSString+iOSAnd_Number.m
//  iOSAnd%Number_Damo
//
//  Created by 杨振 on 16/3/2.
//  Copyright © 2016年 yangzhen5352. All rights reserved.
//

#import "NSString+iOSAnd_Number.h"

@implementation NSString (iOSAnd_Number)
+ (NSString *)countNumAndChangeformat:(NSString *)num
{
    return [self countNumAndChangeformat:num];
}
- (NSString *)countNumAndChangeformat:(NSString *)num
{
    int count = 0;
    long long int a = num.longLongValue;
    while (a != 0) {
        count++;
        a /= 10;
    }
    
    NSMutableString *string = [NSMutableString stringWithString:num];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    
    [newstring insertString:string atIndex:0];
    return newstring;
}

@end
