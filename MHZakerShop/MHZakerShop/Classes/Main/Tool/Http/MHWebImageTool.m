//
//  MHWebImageTool.m
//  MHNetworking
//
//  Created by apple on 16/3/10.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "MHWebImageTool.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"

@implementation MHWebImageTool

+ (void) setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder imageView:(UIImageView *)imageView
{
    [self setImageWithURL:url placeholderImage:placeholder imageView:imageView completed:nil];
}


+ (void)setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder imageView:(UIImageView *)imageView completed:(MHWebImageCompletionWithFinishedBlock)completedBlock
{
    [self setImageWithURL:url placeholderImage:placeholder imageView:imageView progress:nil completed:completedBlock];
}


+ (void) setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder imageView:(UIImageView *)imageView progress:(MHWebImageDownloaderProgressBlock)progressBlock completed:(MHWebImageCompletionWithFinishedBlock)completedBlock
{
    [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder options:SDWebImageLowPriority | SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        if (progressBlock) {
            progressBlock(receivedSize,expectedSize);
        }
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image);
        }
    }];
}


+ (void) clearWebImageCache
{
    // 赶紧清除所有的内存缓存
    [[SDImageCache sharedImageCache] clearMemory];
    
    [[SDImageCache sharedImageCache] clearDisk];
    
    // 赶紧停止正在进行的图片下载操作
    [[SDWebImageManager sharedManager] cancelAll];
}
@end
