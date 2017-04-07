//
//  UIImage+image.h
//  08-02-圆形剪裁
//
//  Created by apple on 20/6/8.
//  Copyright (c) 2020年 itheima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (image)
/**
 *  圆形剪裁图片
 *
 *  @param borderW   圆环宽度
 *  @param color     圆环颜色
 *  @param imageName 图片名称
 *
 *  @return 剪裁好的图片
 */
+ (UIImage *)imageWithBorderW:(CGFloat)borderW color:(UIColor *)color CircleImageName:(NSString *)imageName;
@end
