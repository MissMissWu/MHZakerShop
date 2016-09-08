//
//  MHLeftImageButton.m
//  MHZakerShop
//
//  Created by apple on 16/9/6.
//  Copyright © 2016年 Mike_He. All rights reserved.
//

#import "MHLeftImageButton.h"

@implementation MHLeftImageButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 布局
    CGFloat imageViewX = 24;
    CGFloat imageViewY = 0;
    CGFloat imageViewW = 48;
    CGFloat imageViewH = 48;
    
    self.imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
    self.imageView.mh_centerY  = self.mh_height *.5f;
    
    CGFloat titleLabelX = CGRectGetMaxX(self.imageView.frame)+10;
    CGFloat titleLabelY = 0;
    CGFloat titleLabelW = self.mh_width - titleLabelX;
    CGFloat titleLabelH = self.mh_height;
    self.titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
}


@end
