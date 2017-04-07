//
//  MCProgressBarView.h
//  MCProgressBarView
//
//  Created by Baglan on 12/29/12.
//  Copyright (c) 2012 MobileCreators. All rights reserved.
/*
 
 UIImage * backgroundImage = [[UIImage imageNamed:@"progress-bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
 UIImage * foregroundImage = [[UIImage imageNamed:@"progress-fg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
 _progressBarView = [[MCProgressBarView alloc] initWithFrame:CGRectMake(25, 100, 270, 20)
 backgroundImage:backgroundImage
 foregroundImage:foregroundImage];
 [self.view addSubview:_progressBarView];
 _progressBarView.progress= 0.1;
 
 */

#import <UIKit/UIKit.h>

@interface MCProgressBarView : UIView

- (id)initWithFrame:(CGRect)frame backgroundImage:(UIImage *)backgroundImage foregroundImage:(UIImage *)foregroundImage;

@property (nonatomic, assign) double progress;

@end
