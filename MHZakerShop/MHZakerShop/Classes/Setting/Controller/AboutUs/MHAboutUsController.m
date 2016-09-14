//
//  MHAboutUsController.m
//  MHZakerShop
//
//  Created by apple on 16/9/5.
//  Copyright © 2016年 Mike_He. All rights reserved.
//

#import "MHAboutUsController.h"
#import "MHBottomToolBar.h"
@interface MHAboutUsController ()

@end

@implementation MHAboutUsController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

// 跳转到zaker阅读
- (IBAction)_gotoZakerReadding:(UIButton *)sender {
    
    MHLogFunc;
    // 跳转到评论
//    NSString *urlString = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=462149227";
    
    // 跳转到详情
    NSString *urlString = @"itms-apps://itunes.apple.com/cn/app/zaker-guan-zhu-shi-shi-xin/id462149227?mt=8";
    
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]])
    {
        // 跳转
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
    

    //FIXME:ios 跳转到其他应用
    // 参考链接
    /**
     // 跳转到评论区
     // @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=462149227"
     // http://blog.csdn.net/hu_songsong/article/details/48973621
     // http://www.jianshu.com/p/4523eafb4cd4
     
     // 跳转到应用详情
     // @"itms-apps://itunes.apple.com/cn/app/zaker-guan-zhu-shi-shi-xin/id462149227?mt=8"
     // http://blog.csdn.net/hu_songsong/article/details/48973621
     */
    
}

@end
