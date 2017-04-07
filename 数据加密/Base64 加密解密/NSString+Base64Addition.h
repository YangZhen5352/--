//
//  NSString+Base64Addition.h
//  TTD
//
//  Created by ZhangChuntao on 12/18/12.
//  Copyright (c) 2012 totem. All rights reserved.
//

#import <Foundation/NSString.h>

@interface NSString (base64Addition)

+ (NSString *) base64StringFromData:(NSData *)data length:(int)length;

@end
