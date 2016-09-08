//
//  UIImage+MHOrientation.m
//  MHDevLibExample
//
//  Created by apple on 16/5/12.
//  Copyright © 2016年 Mike_He. All rights reserved.
//

#import "UIImage+MHOrientation.h"

@implementation UIImage (MHOrientation)
/**
 *  将图片旋转到指定的方向
 *
 *  @param sourceImage 要旋转的图片
 *  @param orientation 旋转方向
 *
 *  @return 返回旋转后的图片
 */
+ (UIImage *) mh_fixImageOrientationWithSourceImage:(UIImage *)sourceImage orientation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
        {
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, sourceImage.size.height, sourceImage.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
        }
            break;
        case UIImageOrientationRight:
        {
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, sourceImage.size.height, sourceImage.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
        }
            break;
        case UIImageOrientationDown:
        {
            rotate = M_PI;
            rect = CGRectMake(0, 0, sourceImage.size.width, sourceImage.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
        }
            break;
        default:
        {
            rotate = 0.0;
            rect = CGRectMake(0, 0, sourceImage.size.width, sourceImage.size.height);
            translateX = 0;
            translateY = 0;
        }
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), sourceImage.CGImage);
    
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    
    return destImage;
}
@end
