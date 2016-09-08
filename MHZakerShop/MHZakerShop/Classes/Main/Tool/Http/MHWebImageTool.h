//
//  MHWebImageTool.h
//  MHNetworking
//
//  Created by apple on 16/3/10.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  下载图片完成的block
 */
typedef void(^HttpCompletedBlock)(UIImage *image);
/**
 *  下载图片完成的block
 */
typedef void(^MHWebImageCompletionWithFinishedBlock)(UIImage *image);
/**
 *  下载图片进度
 */
typedef void(^MHWebImageDownloaderProgressBlock)(NSInteger receivedSize, NSInteger expectedSize);


@interface MHWebImageTool : NSObject

/**
 *  异步获取图片
 *
 *  @param url         图片url
 *  @param placeholder 占位图片
 *  @param imageView   图片显示控件 必须是强引用
 */
+ (void)setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder imageView:(UIImageView *)imageView;


/**
 *  异步获取图片 返回下载成功的图片
 *
 *  @param url            图片url
 *  @param placeholder    占位图片
 *  @param imageView      图片显示控件 必须是强引用
 *  @param completedBlock 下载完成的block回调
 */
+ (void)setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder imageView:(UIImageView *)imageView completed:(MHWebImageCompletionWithFinishedBlock)completedBlock;

/**
 *  异步获取图片 带进度
 *
 *  @param url            图片url
 *  @param placeholder    占位图片
 *  @param imageView      图片显示控件 必须是强引用
 *  @param progressBlock  下载进度回调
 *  @param completedBlock 下载完成的block回调
 */
+ (void)setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder imageView:(UIImageView *)imageView progress:(MHWebImageDownloaderProgressBlock)progressBlock completed:(MHWebImageCompletionWithFinishedBlock)completedBlock;


/**
 *  解决内存警告
 */
+ (void) clearWebImageCache;

@end
