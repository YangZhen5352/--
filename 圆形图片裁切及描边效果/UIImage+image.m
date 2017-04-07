//
//  UIImage+image.m
//  08-02-圆形剪裁
//
//  Created by apple on 20/6/8.
//  Copyright (c) 2020年 itheima. All rights reserved.
//

#import "UIImage+image.h"

@implementation UIImage (image)
+ (UIImage *)imageWithBorderW:(CGFloat)borderW color:(UIColor *)color CircleImageName:(NSString *)imageName
{
    UIImage *img = [UIImage imageNamed:imageName];
    CGFloat w = img.size.width + 2 * borderW;
    CGFloat h = img.size.height + 2 * borderW;
    CGRect bigCricleRect = CGRectMake(0, 0, w, h);
    
    // 1.开启位图上下文
    UIGraphicsBeginImageContextWithOptions(bigCricleRect.size, NO, 0);
    
    // 2.拼接路径
    // 2.1绘制大圆
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:bigCricleRect];
    // 设置圆环颜色
    [color set];
    
    [path fill];
    
    // 2.2设置裁剪区域
    CGRect clipRect = CGRectMake(borderW, borderW, img.size.width, img.size.height);
    // 描述裁剪区域路径
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:clipRect];
    
    [clipPath addClip];
    
    // 绘制图片
    [img drawAtPoint:CGPointMake(borderW, borderW)];
    
    // 获取图片
    img = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return img;
    
    
}
@end
